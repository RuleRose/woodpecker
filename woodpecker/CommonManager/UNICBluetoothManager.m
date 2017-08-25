//
//  MMCBluetoothManager.m
//  mmcS2
//
//  Created by 肖君 on 16/11/3.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "UNICBluetoothManager.h"

#define TIMEOUT_DEVICE_SCAN 40.0
#define TIMEOUT_DEVICE_CONNECT 60.0

@interface UNICBluetoothManager ()<CBCentralManagerDelegate>
@property(nonatomic, strong) CBCentralManager *myCentralManager;

@property(nonatomic, strong) NSTimer *scanTimeOutTimer;
@property(nonatomic, strong) NSTimer *connectTimerOutTimer;
@end

@implementation UNICBluetoothManager
Singleton_Implementation(UNICBluetoothManager);
- (void)setCurrentState:(MMCConnectionState)currentState {
    _currentState = currentState;
    [[NSNotificationCenter defaultCenter] postNotificationName:MMCNotificationKeyBluetoothState
                                                        object:nil
                                                      userInfo:@{NOTIFY_KEY_STATE : [NSNumber numberWithInteger:currentState]}];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDictionary *option = @{CBCentralManagerOptionShowPowerAlertKey : [NSNumber numberWithBool:YES]};
        _myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:option];
        _currentState = STATE_NONE;
    }
    return self;
}

- (void)startScan:(void (^)(NSInteger sendState))callback {
    if ([self checkCentralManagerIsPowerOn]) {
        DDLogDebug(@"[bluetooth manager] start Scan");
        if (callback) {
            callback(0);
        }
        NSArray *serviceList = @[ [CBUUID UUIDWithString:SERVICE_UUID_UNICORN] ];
        [self.myCentralManager scanForPeripheralsWithServices:serviceList options:nil];
        self.currentState = STATE_SCANNING;
        self.currentPeripheral = nil;
        self.scanTimeOutTimer =
            [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_DEVICE_SCAN target:self selector:@selector(scanTimeOut) userInfo:nil repeats:NO];
    } else {
        if (callback) {
            callback(1);
        }
    }
}

- (void)scanTimeOut {
    DDLogDebug(@"[bluetooth manager] Scan time out");
    self.currentState = STATE_SCAN_TIMEOUT;
    [self stopScan:nil];
}

- (void)stopScan:(void (^)(NSInteger sendState))callback {
    if ([self checkCentralManagerIsPowerOn]) {
        DDLogDebug(@"[bluetooth manager] stop scan");
        if (callback) {
            callback(0);
        }
        [self.scanTimeOutTimer invalidate];
        [self.myCentralManager stopScan];
        self.currentState = STATE_SCAN_STOPPED;
    } else {
        if (callback) {
            callback(1);
        }
    }
}

- (void)connectToPeripheral:(CBPeripheral *)peripheral {
    if ([self checkCentralManagerIsPowerOn]) {
        DDLogDebug(@"[bluetooth manager] connect to peripheral");
        self.currentPeripheral = peripheral;
        [self.myCentralManager connectPeripheral:peripheral options:nil];
        self.currentState = STATE_CONNECTING;
        self.connectTimerOutTimer =
            [NSTimer scheduledTimerWithTimeInterval:TIMEOUT_DEVICE_CONNECT target:self selector:@selector(connectTimeOut) userInfo:nil repeats:NO];
    }
}

- (void)connectTimeOut {
    DDLogDebug(@"[bluetooth manager] connect time out");
    self.currentState = STATE_CONNECT_TIMEOUT;
}

- (void)disconnectToPeripheral:(CBPeripheral *)peripheral callback:(void (^)(NSInteger sendState))callback {
    if ([self checkCentralManagerIsPowerOn]) {
        DDLogDebug(@"[bluetooth manager] disconnect to peripheral");
        if (callback) {
            callback(0);
        }
        [self.myCentralManager cancelPeripheralConnection:peripheral];
        self.currentState = STATE_DISCONNECTING;
    } else {
        if (callback) {
            callback(1);
        }
    }
}

- (BOOL)checkCentralManagerIsPowerOn {
    if (self.myCentralManager.state == CBCentralManagerStatePoweredOn) {
        return YES;
    } else {
        DDLogDebug(@"[bluetooth manager] central manager is not power on");
        [[UNICHUDManager defaultInstance] showTextHUD:kLocalization(@"alert_core_bluetooth_is_not_power_on")];
        return NO;
    }
}

#pragma mark - central manager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    DDLogDebug(@"[bluetooth manager] central manager state change to: %ld", (long)central.state);
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStateUnsupported:
        case CBCentralManagerStateUnknown: {
            /* Bad news, let's wait for another event. */
            //            [scanTimer invalidate];
            //            [connectTimer invalidate];
            //            isPowerOff = TRUE;
            //            [self performSelector:@selector(connectivityStateCheck) withObject:nil afterDelay:0.5];
            //[statusDelegate onStateChanged:STATE_NO_CONNNECTIVITY];
            break;
        }

        case CBCentralManagerStatePoweredOn:
        case CBCentralManagerStateResetting: {
            //            [scanTimer invalidate];
            //            [connectTimer invalidate];
            //            isPowerOff = FALSE;
            //            [self startScan];
            break;
        }
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central
    didDiscoverPeripheral:(CBPeripheral *)peripheral
        advertisementData:(NSDictionary<NSString *, id> *)advertisementData
                     RSSI:(NSNumber *)RSSI {
    DDLogDebug(@"[bluetooth manager] I see an advertisement with identifer: %@, state: %ld, name: %@, services: %@, RSSI: %d, description: %@",
               [peripheral identifier], (long)[peripheral state], [peripheral name], [peripheral services], RSSI.intValue, [advertisementData description]);
    if (self.discoveryDelegate) {
        [self.discoveryDelegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DDLogDebug(@"[bluetooth manager] did connect peripheral");
    if (self.discoveryDelegate) {
        [self.discoveryDelegate didConnect:peripheral];
    }
    [self.connectTimerOutTimer invalidate];
    self.currentState = STATE_CONNECTED;
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"[bluetooth manager] Peripheral fail to connect, error: %@", [error debugDescription]);
    self.currentState = STATE_DISCONNECTED;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    DDLogDebug(@"[bluetooth manager] Peripheral disconnected, error: %@", [error debugDescription]);
    if (self.discoveryDelegate) {
        [self.discoveryDelegate didDisconnect:peripheral];
    }
    self.currentState = STATE_DISCONNECTED;
}

@end
