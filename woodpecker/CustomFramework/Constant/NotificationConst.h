//
//  NotificationConst.h
//  mmcS2
//
//  Created by 肖君 on 16/11/4.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NOTIFY_KEY_STATE @"state"
#define NOTIFY_KEY_TEMPERATURE_LIST @"temperature_list"
#define NOTIFY_KEY_INDEX @"index"
#define NOTIFY_KEY_DEVICE_ID @"device_ID"
#define NOTIFY_KEY_TEMPERATURE @"temperature"

@interface NotificationConst : NSObject
extern NSString* const MMCNotificationKeyBluetoothState;
extern NSString* const MMCNotificationKeyDeviceState;
extern NSString* const MMCNotificationKeyDeviceConnectionState;
extern NSString* const UNICNotificationKeyDeviceRecordCountReady;
extern NSString* const UNICNotificationKeyDeviceTemperatureValue;
extern NSString* const UNICNotificationKeyDeviceFound;
extern NSString* const UNICNotificationKeyRecoverSendOrder;
extern NSString* const UNICNotificationKeyUserModeChanged;
extern NSString* const UNICNotificationKeyOrderListChanged;
@end
