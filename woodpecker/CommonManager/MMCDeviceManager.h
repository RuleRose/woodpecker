//
//  MMCDeviceManager.h
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MMCDeviceConnectionState) {
    STATE_DEVICE_NONE,
    STATE_DEVICE_SCANNING,
    STATE_DEVICE_CONNECTING,
    STATE_DEVICE_CONNECTED,
    STATE_DEVICE_DISCONNECTING
};

// all state valide when conncetion state is connected
typedef NS_ENUM(NSUInteger, MMCDeviceState) { MMC_STATE_IDLE, MMC_STATE_SYNC, MMC_STATE_MEASURING, MMC_STATE_MEASURING_FINISH };

@interface MMCDeviceManager : NSObject
Singleton_Interface(MMCDeviceManager);
@property(nonatomic, assign) MMCDeviceConnectionState preConnectionDeviceState;
@property(nonatomic, assign) MMCDeviceConnectionState deviceConnectionState;
@property(nonatomic, assign) MMCDeviceState preDeviceState;
@property(nonatomic, assign) MMCDeviceState deviceState;
@property(nonatomic, assign) NSInteger alarmTimeInterval;
@property(nonatomic, assign) NSInteger monitoringTemperatureResult;

- (void)startScan:(void (^)(NSInteger sendState))callback;  // 0 命令成功发送，1 命令发送失败。如果不关心是否发送成功，传nil。
- (void)stopScan:(void (^)(NSInteger sendState))callback;
- (void)disconnect:(void (^)(NSInteger sendState))callback;
- (void)writeAlarm:(NSInteger)alarmInterval callback:(void (^)(NSInteger sendState))callback;
- (void)syncHistoryRecord;
- (void)startCheckRealTimeTemperature;
- (void)stopCheckRealTimeTemperature;
@end