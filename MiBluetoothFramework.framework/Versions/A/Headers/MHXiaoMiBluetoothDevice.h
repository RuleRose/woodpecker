//
//  MHXiaoMiBluetoothDevice.h
//  MiBluetoothFramework
//
//  Created by yinze zhang on 2016/9/23.
//  Copyright © 2016年 yinze zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHBluetoothDevice;
@interface MHXiaoMiBluetoothDevice : NSObject

@property(nonatomic, strong, readonly) MHBluetoothDevice* bluetoothDevice;

//符合小米蓝牙协议的设备,经过regester后会生成一个token
//note:开发者可以保存这个token,以后可以直接使用
@property(nonatomic, strong) NSData* loginToken;

@property(nonatomic, copy)   NSString* firmwareVersion;

-(instancetype)initWithRawBluetooth:(MHBluetoothDevice*)bluetoothDevice;

@end
