//
//  MMCDeviceManager.m
//  mmcS2
//
//  Created by 肖君 on 16/11/4.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "UNICDeviceManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleDevice.h"
#import "MMC_Ntc.h"
#import "UNICBluetoothManager.h"
#import "UNICDBManager.h"
#import "UNICUnicornSensorData.h"

@interface UNICDeviceManager ()<CBPeripheralDelegate, UNICBluetoothManagerDiscoveryDelegate>
@property(nonatomic, assign) BOOL scanAndConncet;
@property(nonatomic, copy) NSString *desMacAddr;
@property(nonatomic, assign) MMCDeviceNoneReason reason;
@end

@implementation UNICDeviceManager
Singleton_Implementation(UNICDeviceManager);
- (void)setDeviceConnectionState:(MMCDeviceConnectionState)deviceConnectionState {
    if (_deviceConnectionState != deviceConnectionState) {
        _preConnectionDeviceState = _deviceConnectionState;
        _deviceConnectionState = deviceConnectionState;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (_deviceConnectionState == STATE_DEVICE_NONE) {
            self.desMacAddr = nil;
            self.scanAndConncet = NO;
            [userInfo setObject:[NSNumber numberWithUnsignedInteger:self.reason] forKey:@"MMCDeviceNoneReason"];
            self.reason = DEVICE_NONE_DEFAULT;
        }

        [userInfo setObject:[NSNumber numberWithUnsignedInteger:_deviceConnectionState] forKey:@"MMCNotificationKeyDeviceConnectionState"];

        DDLogDebug(@"[Device Manager] device connection state change to: %ld", _deviceConnectionState);
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyDeviceConnectionState object:nil userInfo:userInfo];
    }
}

- (void)setDeviceState:(MMCDeviceState)deviceState {
    if (_deviceState != deviceState) {
        _preDeviceState = _deviceState;
        _deviceState = deviceState;
        DDLogDebug(@"[Device Manager] device  state change to: %ld", _deviceState);
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyDeviceState object:nil userInfo:nil];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [UNICBluetoothManager defaultInstance].discoveryDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:MMCNotificationKeyBluetoothState object:nil];
        _deviceConnectionState = STATE_DEVICE_NONE;
        _preConnectionDeviceState = STATE_DEVICE_NONE;
        _deviceState = MMC_STATE_IDLE;
        _preDeviceState = MMC_STATE_IDLE;
        _scanAndConncet = NO;
    }
    return self;
}

- (void)startScanWithMacAddr:(NSString *)macAddr needConnect:(BOOL)needConnect callback:(void (^)(NSInteger sendState))callback {
    if (self.deviceConnectionState != STATE_DEVICE_NONE) {
        if (callback) {
            callback(1);
        }
        return;
    }
    self.desMacAddr = macAddr;
    self.scanAndConncet = needConnect;
    //这个loading仅限制在扫描期间，扫描到设备或者超时，都会关闭。
    // UI 不用主动停止扫描，只有扫描成功或者超时，才会退出扫描。
    [[UNICHUDManager defaultInstance] showLoadingHUDwithCallback:nil];
    [[UNICBluetoothManager defaultInstance] startScan:callback];
}

- (void)stopScan:(void (^)(NSInteger sendState))callback {
    [[UNICBluetoothManager defaultInstance] stopScan:callback];
}

- (void)disconnect:(void (^)(NSInteger sendState))callback {
    if (self.currentDevice) {
        [[UNICBluetoothManager defaultInstance] disconnectToPeripheral:self.currentDevice.peripheral callback:callback];
    } else {
        if (callback) {
            callback(1);
        }
    }
}

- (void)setTemperatureIndexRangeFrom:(int32_t)from to:(int32_t)to {
    DDLogDebug(@"[Device Manager] set temperature index from: %d to: %d", from, to);
    if (self.currentDevice) {
        NSMutableData *value = [[NSMutableData alloc] initWithCapacity:8];
        [value appendBytes:&from length:sizeof(int32_t)];
        [value appendBytes:&to length:sizeof(int32_t)];
        if ([self writeCharacteristic:self.currentDevice.peripheral sUUID:SERVICE_UUID_MMCSERVICE cUUID:CHARACT_UUID_TEMPERATURE_RANGE_WRITE data:value]) {
            [self enableNotify];
        }
    }
}

- (void)enableNotify {
    if (self.currentDevice) {
        [self setCharacteristicNotify:self.currentDevice.peripheral sUUID:SERVICE_UUID_MMCSERVICE cUUID:CHARACT_UUID_RECORD_NOTIFY state:YES];
    }
}

- (void)disableNotify {
    [self setCharacteristicNotify:self.currentDevice.peripheral sUUID:SERVICE_UUID_MMCSERVICE cUUID:CHARACT_UUID_RECORD_NOTIFY state:NO];
}

- (void)notificationHandler:(NSNotification *)sender {
    NSString *notificationName = sender.name;
    if ([notificationName isEqualToString:MMCNotificationKeyBluetoothState]) {
        MMCConnectionState state = [[sender.userInfo objectForKey:NOTIFY_KEY_STATE] integerValue];
        switch (state) {
            case STATE_NONE: {
                self.deviceConnectionState = STATE_DEVICE_NONE;
            } break;
            case STATE_SCANNING: {
                self.deviceConnectionState = STATE_DEVICE_SCANNING;
            } break;
            case STATE_SCAN_TIMEOUT: {
                [[UNICHUDManager defaultInstance] hideLoading];
                [[UNICHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_scan_time_out")];
                self.reason = DEVICE_NONE_SCAN_TIME_OUT;
                self.deviceConnectionState = STATE_DEVICE_NONE;
            } break;
            case STATE_SCAN_STOPPED: {
                if (self.scanAndConncet == NO) {
                    [[UNICHUDManager defaultInstance] hideLoading];
                    self.deviceConnectionState = STATE_DEVICE_NONE;
                }
            } break;
            case STATE_CONNECTING: {
                self.deviceConnectionState = STATE_DEVICE_CONNECTING;
            } break;
            case STATE_CONNECT_TIMEOUT: {
                [[UNICHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_connect_time_out")];
                self.deviceConnectionState = STATE_DEVICE_NONE;
            } break;
            case STATE_DISCONNECTING: {
                self.deviceConnectionState = STATE_DEVICE_DISCONNECTING;
            } break;
            case STATE_CONNECTED: {
                self.deviceConnectionState = STATE_DEVICE_CONNECTED;
            } break;
            case STATE_DISCONNECTED: {
                self.deviceConnectionState = STATE_DEVICE_NONE;
            } break;

            default:
                break;
        }
    }
}

#pragma mark - bluetooth discovery delegate
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    BOOL isConcernedDevice = NO;

    // add a new device, if it is concerned.
    NSDictionary *service_data = advertisementData[CBAdvertisementDataServiceDataKey];

    // C or D MMC sensor that does not hava BLE service data
    if (service_data == nil) {
        DDLogDebug(@"[Device Manager] servcie data is empty");
        return;
    } else {
        MMCDeviceType scanDeviceType = MMC_TYPE_NONE;
        NSData *beacon_data = service_data[[CBUUID UUIDWithString:SERVICE_DATA_UUID_UNICORN]];
        UNICUnicornSensorData *dataObject;
        if (beacon_data) {
            dataObject = [[UNICUnicornSensorData alloc] initWithRawData:beacon_data];
            if (dataObject && [dataObject.MacAddr isEqualToString:self.desMacAddr]) {
                scanDeviceType = MMC_TYPE_UNICORN;
            } else {
                beacon_data = nil;
            }
        }

        if (beacon_data) {
            BleDeviceBroadcast *newDevice = [[BleDeviceBroadcast alloc] init];
            newDevice.RSSI = RSSI.integerValue;
            newDevice.peripheral = peripheral;
            newDevice.identifier = peripheral.identifier;
            newDevice.TTL = 0;
            newDevice.type = scanDeviceType;

            newDevice.MacAddr = dataObject.MacAddr;
            newDevice.highLimitRaw = dataObject.highLimit;
            newDevice.lowLimitRaw = dataObject.lowLimit;
            newDevice.currentTemperatureRaw = dataObject.currentTemperature;
            newDevice.ntcIndex = dataObject.ntcIndex;
            newDevice.powerLevelRaw = dataObject.powerLevel;
            self.currentDevice = newDevice;
            DDLogDebug(@"[Device Manager] MMC device type: %ld", (long)newDevice.type);
            isConcernedDevice = YES;
        }
    }

    // Find concerned device and finish scanning.
    if (isConcernedDevice) {
        [[UNICBluetoothManager defaultInstance] stopScan:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:UNICNotificationKeyDeviceFound
                                                            object:nil
                                                          userInfo:@{
                                                              NOTIFY_KEY_DEVICE_ID : self.currentDevice.MacAddr,
                                                              NOTIFY_KEY_TEMPERATURE : [NSNumber numberWithFloat:self.currentDevice.currentTemperature]
                                                          }];
        if (self.scanAndConncet) {
            [[UNICBluetoothManager defaultInstance] connectToPeripheral:peripheral];
        } else {
            self.deviceConnectionState = STATE_DEVICE_NONE;
        }
    }
}

- (void)didConnect:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    [peripheral discoverServices:@[ [CBUUID UUIDWithString:SERVICE_UUID_MMCSERVICE] ]];
}

- (void)didDisconnect:(CBPeripheral *)peripheral {
    self.preDeviceState = MMC_STATE_IDLE;
    self.deviceState = MMC_STATE_IDLE;
    self.currentDevice = nil;
}

- (BOOL)setCharacteristicNotify:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID state:(BOOL)state {
    // read data from BLE peripheral
    for (CBService *service in peripheral.services) {
        NSString *serviceUUIDStr = [service.UUID.UUIDString lowercaseString];
        if ([serviceUUIDStr isEqualToString:sUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *charactUUIDStr = [characteristic.UUID.UUIDString lowercaseString];
                if ([charactUUIDStr isEqualToString:cUUID]) {
                    /* EVERYTHING IS FOUND, read characteristic ! */
                    [peripheral setNotifyValue:state forCharacteristic:characteristic];
                    return YES;
                }
            }
        }
    }

    return NO;
}

- (BOOL)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID {
    // read data from BLE peripheral
    for (CBService *service in peripheral.services) {
        NSString *serviceUUIDStr = [service.UUID.UUIDString lowercaseString];
        if ([serviceUUIDStr isEqualToString:sUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *charactUUIDStr = [characteristic.UUID.UUIDString lowercaseString];
                if ([charactUUIDStr isEqualToString:cUUID]) {
                    /* EVERYTHING IS FOUND, read characteristic ! */
                    [peripheral readValueForCharacteristic:characteristic];
                    return YES;
                }
            }
        }
    }

    return NO;
}

- (BOOL)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data {
    // Sends data to BLE peripheral
    DDLogDebug(@"[Device Manager] writeCharacteristic");

    for (CBService *service in peripheral.services) {
        NSString *serviceUUIDStr = [service.UUID.UUIDString lowercaseString];
        //        DDLogDebug(@"[Device Manager] peripheral has servcie: %@",
        //        serviceUUIDStr);
        if ([serviceUUIDStr isEqualToString:sUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                NSString *charactUUIDStr = [characteristic.UUID.UUIDString lowercaseString];
                //                DDLogDebug(@"[Device Manager] peripheral has
                //                character: %@", charactUUIDStr);
                if ([charactUUIDStr isEqualToString:cUUID]) {
                    /* EVERYTHING IS FOUND, read characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
                    return YES;
                }
            }
        }
    }

    return NO;
}

#pragma mark - peripheral delegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    DDLogDebug(@"[Device Manager] periperal.didDiscoverServices");

    if (error) {
        DDLogDebug(@"[Device Manager] periperal.didDiscoverServices, error = %@", [error localizedDescription]);
        return;
    }

    for (CBService *service in peripheral.services) {
        DDLogDebug(@"[Device Manager] Service found with UUID: %@", service.UUID.UUIDString);

        /* MMC Services */
        if ([[service.UUID.UUIDString lowercaseString] isEqualToString:SERVICE_UUID_MMCSERVICE]) {
            [peripheral discoverCharacteristics:@[
                [CBUUID UUIDWithString:CHARACT_UUID_RECORD_COUNT_READ], [CBUUID UUIDWithString:CHARACT_UUID_RECORD_NOTIFY],
                [CBUUID UUIDWithString:CHARACT_UUID_TEMPERATURE_RANGE_WRITE]
            ]
                                     forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    DDLogDebug(@"[Device Manager] periperal.didDiscoverCharacteristicsForService");

    if (error) {
        DDLogDebug(@"[Device Manager] "
                   @"periperal.didDiscoverCharacteristicsForService, service = "
                   @"%@, error = %@",
                   service.UUID, [error localizedDescription]);
        return;
    }

    for (CBCharacteristic *Char in service.characteristics) {
        NSString *charactUUIDString = [Char.UUID.UUIDString lowercaseString];
        /* read values or set notification*/
        if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_COUNT_READ]) {
            if (Char.properties & CBCharacteristicPropertyRead) {
                DDLogDebug(@"[Device Manager] Discover Read value for Charactestic: %@", charactUUIDString);
                [peripheral readValueForCharacteristic:Char];
            }
        } else if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_NOTIFY]) {
            if (Char.properties & CBCharacteristicPropertyNotify) {
                DDLogDebug(@"[Device Manager] Discover Notification for Charactestic: %@", charactUUIDString);
            }
        } else if ([charactUUIDString isEqualToString:CHARACT_UUID_TEMPERATURE_RANGE_WRITE]) {
            DDLogDebug(@"[Device Manager] Discover Write Charactestic: %@", charactUUIDString);
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        DDLogDebug(@"[Device Manager] periperal.didUpdateValueForCharacteristic, "
                   @"charact = %@, error = %@",
                   characteristic.UUID, [error localizedDescription]);
        return;
    }

    NSString *charactUUIDString = [characteristic.UUID.UUIDString lowercaseString];
    DDLogDebug(@"[Device Manager] Update Value On charactestic value: %@", charactUUIDString);
    if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_COUNT_READ]) {
        int32_t count;
        [characteristic.value getBytes:&count range:NSMakeRange(0, 4)];
        self.currentDevice.recordCount = count;
        self.currentDevice.markDate = [NSDate date];
        //连接成功，并读取count以后，停止loading。UI 继续读取数据可以重开loading。
        //        [[UNICHUDManager defaultInstance] hideLoading];
        [[NSNotificationCenter defaultCenter] postNotificationName:UNICNotificationKeyDeviceRecordCountReady object:nil];
        DDLogDebug(@"[Device Manager] get count: %d", count);
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_NOTIFY]) {
        if (characteristic.value) {
            int32_t index;
            int32_t value;
            NSMutableArray *valueList = [NSMutableArray array];
            NSInteger valueCount = characteristic.value.length / 4 - 1;
            [characteristic.value getBytes:&index range:NSMakeRange(0, 4)];

            for (NSInteger i = 0; i < valueCount; i++) {
                [characteristic.value getBytes:&value range:NSMakeRange((i + 1) * 4, 4)];
                CGFloat temperature = [MMC_Ntc ntcResistanceToTemperature:value index:(int)self.currentDevice.ntcIndex];
                [valueList addObject:[NSNumber numberWithFloat:temperature]];
            }

            [[NSNotificationCenter defaultCenter]
                postNotificationName:UNICNotificationKeyDeviceTemperatureValue
                              object:nil
                            userInfo:@{NOTIFY_KEY_INDEX : [NSNumber numberWithInt:index], NOTIFY_KEY_TEMPERATURE_LIST : valueList}];

            DDLogDebug(@"[Device Manager] get index: %d", index);
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        DDLogDebug(@"[Device Manager] "
                   @"periperal.didUpdateNotificationStateForCharacteristic, "
                   @"charact = %@, error = %@",
                   characteristic.UUID, [error localizedDescription]);
        return;
    }

    NSString *charactUUIDString = [characteristic.UUID.UUIDString lowercaseString];
    DDLogDebug(@"[Device Manager] Update Notification charactestic value: %@", charactUUIDString);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        DDLogDebug(@"[Device Manager] periperal.didWriteValueForCharacteristic, "
                   @"charact = %@, error = %@",
                   characteristic.UUID, [error localizedDescription]);
        return;
    }
    //    NSString *charactUUIDString = [characteristic.UUID.UUIDString lowercaseString];
    //    DDLogDebug(@"[Device Manager] Did Write Value %@", charactUUIDString);
    //    if ([charactUUIDString isEqualToString:CHARACT_UUID_TEMPERATURE_RANGE_WRITE]) {
    //        [self enableNotify];
    //    }
}
@end
