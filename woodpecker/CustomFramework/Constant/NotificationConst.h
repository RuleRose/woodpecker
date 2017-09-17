//
//  NotificationConst.h
//  mmcS2
//
//  Created by 肖君 on 16/11/4.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NOTIFY_KEY_STATE @"state"
#define NOTIFY_KEY_TEMPERATURE_INDEX @"temperature_index"
#define NOTIFY_KEY_TEMPERATURE_TIME @"temperature_time"
#define NOTIFY_KEY_TEMPERATURE_VALUE @"temperature_value"
#define NOTIFY_KEY_IS_WRITE_ALARM @"is_write_alarm"

@interface NotificationConst : NSObject
extern NSString* const MMCNotificationKeyBluetoothState;
extern NSString* const MMCNotificationKeyDeviceState;
extern NSString* const MMCNotificationKeyDeviceConnectionState;
extern NSString* const MMCNotificationKeyTemperature;
extern NSString* const MMCNotificationKeyTemperatureIndexUpdated;
extern NSString* const MMCNotificationKeyAlarmUpdated;
extern NSString* const MMCNotificationKeyTemperatureUnitUpdated;

extern NSString* const MMCNotificationKeySyncOver;
extern NSString* const MMCNotificationKeyTemperatureMonitoring;

extern NSString* const WPNotificationKeyLoginSuccess;
extern NSString* const WPNotificationKeyLoginFailed;
extern NSString* const WPNotificationKeyLoginCancel;
extern NSString* const WPNotificationKeyLogoutSuccess;
extern NSString* const WPNotificationKeyTokenExpire;
@end
