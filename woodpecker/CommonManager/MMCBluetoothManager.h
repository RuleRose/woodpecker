//
//  MMCBluetoothManager.h
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MMCConnectionState) {
    STATE_NONE,
    STATE_SCANNING,
    STATE_SCAN_STOPPED,
    STATE_SCAN_TIMEOUT,
    STATE_DEVICE_DISCOVERED,
    STATE_CONNECTING,
    STATE_CONNECT_TIMEOUT,
    STATE_CONNECTED,
    STATE_DISCONNECTING,
    STATE_DISCONNECTED,
    STATE_DISCONNECTED_ERROR,
    STATE_NO_CONNNECTIVITY,
    STATE_DATA_AVAILABLE,
    STATE_MONITORING_GOOD,
    STATE_MONITORING_WARNING_1,
    STATE_MONITORING_WARNING_2,
    STATE_MONITORING_WARNING_3,
    STATE_MONITORING_DISCONNECTED,
    STATE_MONITORING_STOP
};

@protocol MMCBluetoothManagerDiscoveryDelegate<NSObject>
@required
- (void)didConnect:(CBPeripheral *)peripheral;
- (void)didDisconnect:(CBPeripheral *)peripheral;
- (void)didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
@end

@interface MMCBluetoothManager : NSObject
Singleton_Interface(MMCBluetoothManager);
@property(nonatomic, strong) CBPeripheral *currentPeripheral;
@property(nonatomic, assign) MMCConnectionState currentState;
@property(nonatomic, weak) id<MMCBluetoothManagerDiscoveryDelegate> discoveryDelegate;

- (void)startScan:(void (^)(NSInteger sendState))callback;
- (void)stopScan:(void (^)(NSInteger sendState))callback;
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
- (void)disconnectToPeripheral:(CBPeripheral *)peripheral callback:(void (^)(NSInteger sendState))callback;
@end
