//
//  XiaoMiConnectManager.h
//  MiBluetoothFramework
//
//  Created by yinze zhang on 2016/9/23.
//  Copyright © 2016年 yinze zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHBluetoothDevice;
@class MHXiaoMiBluetoothDevice;

typedef NS_ENUM(NSInteger,MHXiaoMiDeviceBindStyle){
    XiaoMiDeviceBindStyleUndefine = 0,
    XiaoMiDeviceBindStyleStrong   = 1,     //强绑定,如果设备不解绑,别的帐号不可用
    XiaoMiDeviceBindStyleWeak     = 2      //弱绑定,这个设备可以被任意连接
};
NS_ASSUME_NONNULL_BEGIN
@interface MHXiaoMiConnectManager : NSObject


//配置连接过程中的超时
@property(nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic, strong) void(^timeoutBlock)();


//Bind 分为强绑定,弱绑定
@property(nonatomic, assign) MHXiaoMiDeviceBindStyle bindStyle;


/**
 初始化函数

 @param model 设备的model

 @return instance
 */
-(instancetype)initWithDeviceModel:(NSString*)model;


/*以下两个接口的作用主要是提供一个符合小米协议的蓝牙的设备,第一次需要调用registerXiaoMiBluetoothDeviceWith:miDevice取得token后,直接可以用返回的outXiaoMiDevice.如果开发者已经存储了logintoken,之后直接用loginXiaoMiBluetoothDeviceWith:loginToken:miDevice取得outXiaoMiDevice.
 noet:以下两个接口没有先后顺序.判断需要调用哪个接口,只需要根据是否有loginToken判断即可.
 */


/**
 如果开发者还没有取得小米设备的logintoken,需要调用这个接口.
 在这个接口中返回的MHXiaoMiBluetoothDevice结构中包含有logintoken,开发者可以保存这个token,下次再次启动的时候,不需要再次调用这个接口.
 @param bluetoothDevice 原始的蓝牙设备
 @param outXiaoMiDevice 符合小米协议的蓝牙设备,开发者可以通过这个蓝牙设备接管所有的底层蓝牙回调.
                        example : outXiaoMiDevice.bluetoothDevice.centralManager.delegate = self;
                                  outXiaoMiDevice.bluetoothDevice.peripheral.delegate = self;
 */
-(void)registerXiaoMiBluetoothDeviceWith:(MHBluetoothDevice*)bluetoothDevice miDevice:(void(^)(MHXiaoMiBluetoothDevice* _Nullable))outXiaoMiDevice;




/**
 如果开发者已经保存了registerXiaoMiBluetoothDeviceWith:miDevice接口获得的logintoken,那么以后就可以直接调用这个接口.
 如果没有保存logintoken,只能调用registerXiaoMiBluetoothDeviceWith:miDevice接口

 @param bluetoothDevice 原始的蓝牙设备
 @param token           上个接口获得的token
 @param outXiaoMiDevice 符合小米协议的设备
 */
-(void)loginXiaoMiBluetoothDeviceWith:(MHBluetoothDevice*)bluetoothDevice loginToken:(NSData*)token miDevice:(void(^)(MHXiaoMiBluetoothDevice* _Nullable))outXiaoMiDevice;

@end
NS_ASSUME_NONNULL_END
