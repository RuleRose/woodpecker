//
//  BleDeviceBroadcast.h
//  MiaoMiaoCe
//
//  Created by robin guo on 16/1/13.
//  Copyright © 2016年 Weisi Smart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleDevice.h"

@interface BleDeviceBroadcast : BleDevice

@property(assign, nonatomic) NSInteger TTL;
@property(assign, nonatomic) float t1;
@property(assign, nonatomic) float t2;

@property(nonatomic, copy) NSString *MacAddr;
@property(assign, nonatomic) NSInteger batteryLevelRaw;
@property(nonatomic, copy) NSString *modelNum;
@property(nonatomic, copy) NSString *hardwareRev;
@property(nonatomic, copy) NSString *softwareRev;
@property(nonatomic, copy) NSString *SN;
@property(nonatomic, assign) NSInteger deviceID;

@end
