//
//  MMCDeviceManager.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "MMCDeviceManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleDevice.h"
#import "BleDeviceBroadcast.h"
#import "MMCBluetoothManager.h"
#import "WoodpeckerSensorData.h"

@interface MMCDeviceManager ()<CBPeripheralDelegate, MMCBluetoothManagerDiscoveryDelegate>
@property(nonatomic, strong) BleDeviceBroadcast *currentDevice;
@property(nonatomic, assign) BOOL isConnectToNewDevice;
@property(nonatomic, assign) NSInteger lastReadRecordIndex;
@property(nonatomic, assign) NSInteger alarmTimeIntervalToSet;
@property(nonatomic, strong) NSTimer *monitoringTimer;

@property(nonatomic, assign) NSInteger workaroundReadTemperatureCount;
@end

@implementation MMCDeviceManager
Singleton_Implementation(MMCDeviceManager);
- (void)setDeviceConnectionState:(MMCDeviceConnectionState)deviceConnectionState {
    if (_deviceConnectionState != deviceConnectionState) {
        _preConnectionDeviceState = _deviceConnectionState;
        _deviceConnectionState = deviceConnectionState;
        DDLogDebug(@"[Device Manager] device connection state change to: %ld", _deviceConnectionState);
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyDeviceConnectionState object:nil userInfo:nil];
    }
}

// woodpecker项目不关心实时温度和状态
- (void)setDeviceState:(MMCDeviceState)deviceState {
    if (_deviceState != deviceState) {
        _preDeviceState = _deviceState;
        _deviceState = deviceState;
        DDLogDebug(@"[Device Manager] device  state change to: %ld", _deviceState);
        if (_preDeviceState == MMC_STATE_SYNC) {
            [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_data_sync_finish")];
            [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeySyncOver object:nil];
        }
        if (_preDeviceState == MMC_STATE_MEASURING) {
            //测温结束，同步历史数据
            [self syncHistoryRecord];
            [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_temperature_monitoring_finish")];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyDeviceState object:nil userInfo:nil];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [MMCBluetoothManager defaultInstance].discoveryDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:MMCNotificationKeyBluetoothState object:nil];
        _isConnectToNewDevice = NO;
        _deviceConnectionState = STATE_DEVICE_NONE;
        _preConnectionDeviceState = STATE_DEVICE_NONE;
        _deviceState = MMC_STATE_IDLE;
        _preDeviceState = MMC_STATE_IDLE;
        _alarmTimeInterval = -1;
    }
    return self;
}

- (void)startScan:(void (^)(NSInteger sendState))callback {
    self.monitoringTemperatureResult = -1;
    [[MMCBluetoothManager defaultInstance] startScan:callback];
}

- (void)stopScan:(void (^)(NSInteger sendState))callback {
    [[MMCBluetoothManager defaultInstance] stopScan:callback];
}

- (void)disconnect:(void (^)(NSInteger sendState))callback {
    if (self.currentDevice) {
        if (callback) {
            callback(0);
        }
        [[MMCBluetoothManager defaultInstance] disconnectToPeripheral:self.currentDevice.peripheral callback:callback];
    } else {
        if (callback) {
            callback(1);
        }
    }
}

- (void)readTemperature {
    if (self.currentDevice) {
        [self readCharacteristic:self.currentDevice.peripheral sUUID:SERVICE_UUID_MMCSERVICE cUUID:CHARACT_UUID_RECORD_INDEX_TEMPERATURE_READ];
    }
}

//- (void)readMonitoringTemperature {
//    if (self.currentDevice) {
//        [self readCharacteristic:self.currentDevice.peripheral sUUID:SERVICE_UUID_MMCSERVICE cUUID:CHARACT_UUID_MONITORING_TEMPERATURE_READ];
//    }
//}

- (void)readAlarm {
    if (self.currentDevice) {
        [self readCharacteristic:self.currentDevice.peripheral sUUID:SERVICE_UUID_MMCSERVICE cUUID:CHARACT_UUID_ALARM_READ_WRITE];
    }
}

- (void)setTimeToNow {
    if (self.currentDevice) {
        NSDate *now = [NSDate date];
        NSTimeInterval interval = [now timeIntervalSince2000];
        int32_t value = interval;
        [self writeCharacteristic:self.currentDevice.peripheral
                            sUUID:SERVICE_UUID_MMCSERVICE
                            cUUID:CHARACT_UUID_TIME_READ_WRITE
                             data:[NSData dataWithBytes:&value length:sizeof(int32_t)]];
    }
}

- (void)writeAlarm:(NSInteger)alarmInterval callback:(void (^)(NSInteger sendState))callback {
    if (self.currentDevice) {
        if (callback) {
            callback(0);
        }
        self.alarmTimeIntervalToSet = alarmInterval;
        int32_t value = (int32_t)alarmInterval;
        [self writeCharacteristic:self.currentDevice.peripheral
                            sUUID:SERVICE_UUID_MMCSERVICE
                            cUUID:CHARACT_UUID_ALARM_READ_WRITE
                             data:[NSData dataWithBytes:&value length:sizeof(int32_t)]];
    } else {
        if (callback) {
            callback(1);
        }
    }
}

- (void)writeTemperatureIndex:(NSInteger)index {
    if (self.currentDevice) {
        int16_t value = (int16_t)index;
        [self writeCharacteristic:self.currentDevice.peripheral
                            sUUID:SERVICE_UUID_MMCSERVICE
                            cUUID:CHARACT_UUID_RECORD_INDEX_READ_WRITE
                             data:[NSData dataWithBytes:&value length:sizeof(int16_t)]];
    }
}

- (void)syncHistoryRecord {
    if (self.currentDevice && (MMC_STATE_SYNC != self.deviceState) && (MMC_STATE_MEASURING != self.deviceState)) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX]) {
            self.lastReadRecordIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX] integerValue];
        } else {
            self.lastReadRecordIndex = -1;
        }
        self.deviceState = MMC_STATE_SYNC;
        [self readTemperature];
    }
}

//- (void)startCheckRealTimeTemperature {
//    if (self.monitoringTimer) {
//        [self.monitoringTimer invalidate];
//    }
//    self.monitoringTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(readMonitoringTemperature) userInfo:nil repeats:YES];
//    [self.monitoringTimer fire];
//}
//
//- (void)stopCheckRealTimeTemperature {
//    [self.monitoringTimer invalidate];
//}

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
                [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_scan_time_out")];
                self.deviceConnectionState = STATE_DEVICE_NONE;
            } break;
            case STATE_SCAN_STOPPED: {
            } break;
            case STATE_CONNECTING: {
                self.deviceConnectionState = STATE_DEVICE_CONNECTING;
            } break;
            case STATE_CONNECT_TIMEOUT: {
                [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_connect_time_out")];
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
        NSData *beacon_data = service_data[[CBUUID UUIDWithString:SERVICE_DATA_UUID_WOODPECKER]];
        if (beacon_data) {
            WoodpeckerSensorData *dataObject = [[WoodpeckerSensorData alloc] initWithRawData:beacon_data];
            if (dataObject && dataObject.productID == MMC_SENSOR_WOODPECKER_PRODUCT_ID) {
                scanDeviceType = MMC_TYPE_WOODPECKER;
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
            self.currentDevice = newDevice;
            DDLogDebug(@"[Device Manager] MMC device type: %ld", (long)newDevice.type);
            isConcernedDevice = YES;
        }
    }

    // Find a nearby enough device, and finish scanning.
    //    if (isConcernedDevice && RSSI.integerValue >=
    //    SELECTED_DEVICE_RSSI_THRESHOLD) {
    if (isConcernedDevice) {
        [[MMCBluetoothManager defaultInstance] stopScan:nil];
        self.isConnectToNewDevice = NO;
        self.alarmTimeInterval = -1;
        [[MMCBluetoothManager defaultInstance] connectToPeripheral:peripheral];
    }
}

- (void)didConnect:(CBPeripheral *)peripheral {
    //    NSString *preDeviceUUIDStr = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PRE_CONNECTED_DEVICE_UUIDSTRING];

    // if did connect new device, need clean history record
    // 温度计断电不能保留数据，每次连接删除历史记录，重新同步。以后放开
    //    if (!preDeviceUUIDStr || ![preDeviceUUIDStr isEqualToString:peripheral.identifier.UUIDString]) {
    NSString *UUIDStr = peripheral.identifier.UUIDString;
    [[NSUserDefaults standardUserDefaults] setObject:UUIDStr forKey:USER_DEFAULT_PRE_CONNECTED_DEVICE_UUIDSTRING];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:-1] forKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX];
    self.isConnectToNewDevice = YES;
    //    }

    [peripheral setDelegate:self];

    [peripheral discoverServices:@[ [CBUUID UUIDWithString:SERVICE_UUID_MMCSERVICE] ]];
}

- (void)didDisconnect:(CBPeripheral *)peripheral {
    self.preDeviceState = MMC_STATE_IDLE;
    self.deviceState = MMC_STATE_IDLE;
    //    [self stopCheckRealTimeTemperature];
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
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
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
                [CBUUID UUIDWithString:CHARACT_UUID_TIME_READ_WRITE], [CBUUID UUIDWithString:CHARACT_UUID_ALARM_READ_WRITE],
                [CBUUID UUIDWithString:CHARACT_UUID_RECORD_COUNT_READ], [CBUUID UUIDWithString:CHARACT_UUID_RECORD_INDEX_READ_WRITE],
                [CBUUID UUIDWithString:CHARACT_UUID_RECORD_INDEX_TEMPERATURE_READ],
                //                [CBUUID UUIDWithString:CHARACT_UUID_MONITORING_TEMPERATURE_READ],
                [CBUUID UUIDWithString:CHARACT_UUID_TEMPERATURE_UNIT_READ_WRITE]
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
        if ([charactUUIDString isEqualToString:CHARACT_UUID_TIME_READ_WRITE] || [charactUUIDString isEqualToString:CHARACT_UUID_ALARM_READ_WRITE] ||
            [charactUUIDString isEqualToString:CHARACT_UUID_RECORD_COUNT_READ] ||
            [charactUUIDString isEqualToString:CHARACT_UUID_TEMPERATURE_UNIT_READ_WRITE]) {
            if (Char.properties & CBCharacteristicPropertyRead) {
                DDLogDebug(@"[Device Manager] Read value for Charactestic: %@", charactUUIDString);
                [peripheral readValueForCharacteristic:Char];
            }
            if (Char.properties & CBCharacteristicPropertyNotify) {
                DDLogDebug(@"[Device Manager] Set notification for Charactestic: %@", charactUUIDString);
                [peripheral setNotifyValue:YES forCharacteristic:Char];
            }
        }
        //        else if ([charactUUIDString isEqualToString:CHARACT_UUID_MONITORING_TEMPERATURE_READ]) {
        //            [self startCheckRealTimeTemperature];
        //        }
        else if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_INDEX_READ_WRITE]) {
            //设置获取数据的index。新设备从1开始；上次连接的设备，从上次最后一次数据开始。
            //写index成功，是sync history的启动事件。
            if (self.isConnectToNewDevice) {
                [self writeTemperatureIndex:1];
            } else {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX]) {
                    int16_t index = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX] intValue];
                    [self writeTemperatureIndex:index + 1];
                }
            }
        }

        if ([charactUUIDString isEqualToString:CHARACT_UUID_TIME_READ_WRITE]) {
            if (self.isConnectToNewDevice) {
                [self setTimeToNow];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSString *charactUUIDString = [characteristic.UUID.UUIDString lowercaseString];

    if (error) {
        DDLogDebug(@"[Device Manager] periperal.didUpdateValueForCharacteristic, "
                   @"charact = %@, error = %@",
                   characteristic.UUID, [error localizedDescription]);
        if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_INDEX_TEMPERATURE_READ]) {
            self.deviceState = MMC_STATE_IDLE;
        }
        return;
    }

    DDLogDebug(@"[Device Manager] On charactestic value: %@", charactUUIDString);
    if ([charactUUIDString isEqualToString:CHARACT_UUID_TIME_READ_WRITE]) {
        int32_t time;
        [characteristic.value getBytes:&time range:NSMakeRange(0, 4)];
        DDLogDebug(@"[Device Manager] get time: %d", time);
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_ALARM_READ_WRITE]) {
        int32_t alarmTime;
        [characteristic.value getBytes:&alarmTime range:NSMakeRange(0, 4)];
        self.alarmTimeInterval = alarmTime;
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyAlarmUpdated object:nil userInfo:@{ NOTIFY_KEY_IS_WRITE_ALARM : @NO }];
        DDLogDebug(@"[Device Manager] get alarm time: %d", alarmTime);
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_COUNT_READ]) {
        int16_t recordsCount;
        [characteristic.value getBytes:&recordsCount range:NSMakeRange(0, 2)];
        DDLogDebug(@"[Device Manager] get records count: %d", recordsCount);
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_INDEX_TEMPERATURE_READ]) {
        int16_t recordIndex;
        int32_t time;
        int16_t temperature;
        [characteristic.value getBytes:&recordIndex range:NSMakeRange(0, 2)];
        [characteristic.value getBytes:&time range:NSMakeRange(2, 4)];
        [characteristic.value getBytes:&temperature range:NSMakeRange(6, 2)];

        //如果sync的时候检测到开始监测体温，结束同步，等监测体温结束以后再次开始同步数据。
        if ((MMC_STATE_MEASURING == self.deviceState)) {
            return;
        }

        if ((self.lastReadRecordIndex != recordIndex || self.workaroundReadTemperatureCount < 2) && (-1 != recordIndex)) {
            if (self.lastReadRecordIndex != recordIndex) {
                self.workaroundReadTemperatureCount = 0;
                [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyTemperature
                                                                    object:nil
                                                                  userInfo:@{
                                                                      NOTIFY_KEY_TEMPERATURE_INDEX : [NSNumber numberWithInt:recordIndex],
                                                                      NOTIFY_KEY_TEMPERATURE_TIME : [NSNumber numberWithInt:time],
                                                                      NOTIFY_KEY_TEMPERATURE_VALUE : [NSNumber numberWithInt:temperature]
                                                                  }];
            } else {
                self.workaroundReadTemperatureCount++;
            }
            //如果不是最后一条，继续读
            self.lastReadRecordIndex = recordIndex;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:recordIndex] forKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX];
            [self readTemperature];
        } else {
            self.workaroundReadTemperatureCount = 0;
            self.deviceState = self.preDeviceState;
            if (-1 != recordIndex) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:recordIndex] forKey:USER_DEFAULT_LAST_TEMPERATURE_INDEX];
            }
        }

        DDLogDebug(@"[Device Manager] get record index: %d, time : %d, temperature: %d", recordIndex, time, temperature);
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_TEMPERATURE_UNIT_READ_WRITE]) {
    }
    //    else if ([charactUUIDString isEqualToString:CHARACT_UUID_MONITORING_TEMPERATURE_READ]) {
    //        int16_t state;
    //        int16_t temperature;
    //        [characteristic.value getBytes:&state range:NSMakeRange(0, 2)];
    //        [characteristic.value getBytes:&temperature range:NSMakeRange(2, 2)];
    //
    //        /* MMC_STATE_NONE       0
    //           MMC_STATE_IDLE       1
    //           MMC_STATE_INIT       2
    //           MMC_STATE_HISTORY    3
    //           MMC_STATE_MEASURING  4
    //           MMC_STATE_FINISH     5
    //           MMC_STATE_SET_ALARM  6
    //           MMC_STATE_ALARM      7
    //           MMC_STATE_ERROR      0xFF
    //         */
    //
    //        if (4 == state) {
    //            self.deviceState = MMC_STATE_MEASURING;
    //            self.monitoringTemperatureResult = temperature;
    //        } else {
    //            if (5 == state) {
    //                if (self.deviceState != MMC_STATE_SYNC) {
    //                    self.deviceState = MMC_STATE_MEASURING_FINISH;
    //                }
    //                self.monitoringTemperatureResult = temperature;
    //            } else {
    //                if (self.deviceState != MMC_STATE_SYNC) {
    //                    self.deviceState = MMC_STATE_IDLE;
    //                    self.monitoringTemperatureResult = -1;
    //                }
    //            }
    //        }
    //
    //        if (4 == state) {
    //            [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyTemperatureMonitoring object:nil userInfo:nil];
    //        }
    //        DDLogDebug(@"[Device Manager] get monitoring data state: %d, temperature: %d", state, temperature);
    //    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        DDLogDebug(@"[Device Manager] "
                   @"periperal.didUpdateNotificationStateForCharacteristic, "
                   @"charact = %@, error = %@",
                   characteristic.UUID, [error localizedDescription]);
        return;
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        DDLogDebug(@"[Device Manager] periperal.didWriteValueForCharacteristic, "
                   @"charact = %@, error = %@",
                   characteristic.UUID, [error localizedDescription]);
        return;
    }

    NSString *charactUUIDString = [characteristic.UUID.UUIDString lowercaseString];
    DDLogDebug(@"[Device Manager] write %@", charactUUIDString);
    if ([charactUUIDString isEqualToString:CHARACT_UUID_RECORD_INDEX_READ_WRITE]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyTemperatureIndexUpdated object:nil];
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_ALARM_READ_WRITE]) {
        self.alarmTimeInterval = self.alarmTimeIntervalToSet;
        [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyAlarmUpdated object:nil userInfo:@{ NOTIFY_KEY_IS_WRITE_ALARM : @YES }];
    } else if ([charactUUIDString isEqualToString:CHARACT_UUID_TEMPERATURE_UNIT_READ_WRITE]) {
    }
}
@end
