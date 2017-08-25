//
//  MMCDeviceManager.h
//  mmcS2
//
//  Created by 肖君 on 16/11/4.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleDeviceBroadcast.h"

typedef NS_ENUM(NSUInteger, MMCDeviceConnectionState) {
    STATE_DEVICE_NONE,
    STATE_DEVICE_SCANNING,
    STATE_DEVICE_CONNECTING,
    STATE_DEVICE_CONNECTED,
    STATE_DEVICE_DISCONNECTING
};

typedef NS_ENUM(NSUInteger, MMCDeviceNoneReason) { DEVICE_NONE_DEFAULT, DEVICE_NONE_SCAN_TIME_OUT };

// all state valide when conncetion state is connected
typedef NS_ENUM(NSUInteger, MMCDeviceState) { MMC_STATE_IDLE, MMC_STATE_NOTIFYING };

@interface UNICDeviceManager : NSObject
Singleton_Interface(UNICDeviceManager);
@property(nonatomic, strong) BleDeviceBroadcast *currentDevice;
@property(nonatomic, assign) MMCDeviceConnectionState preConnectionDeviceState;
@property(nonatomic, assign) MMCDeviceConnectionState deviceConnectionState;
@property(nonatomic, assign) MMCDeviceState preDeviceState;
@property(nonatomic, assign) MMCDeviceState deviceState;

// callback 0 命令成功发送，1 命令发送失败。如果不关心是否发送成功，传nil。
- (void)startScanWithMacAddr:(NSString *)macAddr needConnect:(BOOL)needConnect callback:(void (^)(NSInteger sendState))callback;
- (void)stopScan:(void (^)(NSInteger sendState))callback;
- (void)disconnect:(void (^)(NSInteger sendState))callback;

- (void)setTemperatureIndexRangeFrom:(int32_t)from to:(int32_t)to;
- (void)enableNotify;
- (void)disableNotify;
@end
