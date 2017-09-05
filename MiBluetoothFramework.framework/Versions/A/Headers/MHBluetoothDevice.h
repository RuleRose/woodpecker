//
//  MHBluetoothDevice.h
//  MiBluetoothFramework
//
//  Created by yinze zhang on 16/9/20.
//  Copyright © 2016年 yinze zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MHBluetoothDevice : MHDevice
////to-do 提取到基类中
//@property(nonatomic, copy)   NSString* model;
//@property(nonatomic, copy)   NSString* name;
//@property(nonatomic, copy)   NSString* did;
//@property(nonatomic, copy)   NSString* token;


@property(nonatomic, weak) CBCentralManager* centralManager;
@property(nonatomic, strong) CBPeripheral* peripheral;
@property(nonatomic, strong) NSNumber* RSSI;
//@property(nonatomic, strong) NSDictionary* extra;

@end
