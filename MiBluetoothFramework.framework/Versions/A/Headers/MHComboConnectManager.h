//
//  MHComboConnectManager.h
//  MiBluetoothFramework
//
//  Created by yinze zhang on 2016/11/22.
//  Copyright © 2016年 yinze zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,kComboConnectErrorType){
    comboConnectDeviceError         = 1,
    comboConnectRegisterError       = 2,
    comboConnectError               = 3,
    comboConnectPasswordError       = 4,
    comboConnectBledisconnectError  = 5,
};

@interface MHComboConnectManager : NSObject

@property(nonatomic, copy) NSString* uid;
@property(nonatomic, copy) NSString* ssid;
@property(nonatomic, copy) NSString* password;

-(void)comboConnect:(MHBluetoothDevice*)bluetoothDevice success:(void(^)())successBlock failure:(void(^)(NSError* error))failureBlock;

@end
