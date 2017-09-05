//
//  MiioBluetoothDiscovery.h
//  Miio
//
//  Created by marteswang on 15/8/25.
//  Copyright (c) 2015年 xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void (^MiioNewBluetoothBroadcastBlock)(NSDictionary *package);
@class MHBluetoothDevice;
typedef void(^BluetoothDeviceDiscovery)(NSArray<MHBluetoothDevice*> *bluetoothDevices,NSError* error);

@interface MHBluetoothDiscovery : NSObject

-(void)startSearch:(BluetoothDeviceDiscovery)broadcast;
- (void)startSearch:(BluetoothDeviceDiscovery)broadcast timeout:(NSTimeInterval)timeout timeoutBlock:(BluetoothDeviceDiscovery)timeoutBlock;

- (void)stopSearch;


@end
