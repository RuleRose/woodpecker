//
//  MMCDeviceManager.h
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
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

// all state valide when conncetion state is connected
typedef NS_ENUM(NSUInteger, MMCDeviceState) { MMC_STATE_IDLE, MMC_STATE_SYNC };

@interface MMCDeviceManager : NSObject
Singleton_Interface(MMCDeviceManager);
@property(nonatomic, strong) BleDeviceBroadcast *currentDevice;
@property(nonatomic, assign) MMCDeviceConnectionState preConnectionDeviceState;
@property(nonatomic, assign) MMCDeviceConnectionState deviceConnectionState;
@property(nonatomic, assign) MMCDeviceState preDeviceState;
@property(nonatomic, assign) MMCDeviceState deviceState;
@property(nonatomic, assign) NSInteger alarmTimeInterval;
@property(nonatomic, assign) BOOL alarmIsOn;
@property(nonatomic, assign) NSInteger dataCount;
@property(nonatomic, assign) NSInteger lastRecordIndex;
@property(nonatomic, assign) NSInteger monitoringTemperatureResult;
@property(nonatomic, assign) BOOL isCentigrade;

- (void)startScanAndConnect:(void (^)(NSInteger sendState))callback;  // 0 命令成功发送，1 命令发送失败。如果不关心是否发送成功，传nil。
- (void)startScanAndConnectWithMac:(NSString *)mac callback:(void (^)(NSInteger sendState))callback;
- (void)stopScan:(void (^)(NSInteger sendState))callback;
- (void)disconnect:(void (^)(NSInteger sendState))callback;
- (void)writeAlarm:(NSInteger)alarmInterval callback:(void (^)(NSInteger sendState))callback;
- (void)turnOffAlarm:(void (^)(NSInteger sendState))callback;
- (void)centigradeAsUnit:(BOOL)isCentigrade callback:(void (^)(NSInteger sendState))callback;
- (void)syncDataFromIndex:(NSInteger)index callback:(void (^)(NSInteger sendState))callback;  // index是下一个要返回的值，直到最后一个数据。
//- (void)syncHistoryRecord;
//- (void)startCheckRealTimeTemperature;
//- (void)stopCheckRealTimeTemperature;
@end
