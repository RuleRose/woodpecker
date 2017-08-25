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
@property(nonatomic, assign) NSInteger highLimitRaw;
@property(nonatomic, assign) NSInteger lowLimitRaw;
@property(nonatomic, assign) NSInteger currentTemperatureRaw;
@property(nonatomic, assign) NSInteger powerLevelRaw;
@property(nonatomic, assign) NSInteger ntcIndex;

@property(nonatomic, assign) CGFloat highLimit;
@property(nonatomic, assign) CGFloat lowLimit;
@property(nonatomic, assign) CGFloat currentTemperature;
@property(nonatomic, assign) NSInteger powerLevel;
@property(nonatomic, assign) NSInteger durationDay;
@property(nonatomic, assign) NSInteger recordCount;

//设备上recordCount点，对应的手机时间
@property(nonatomic, strong) NSDate *markDate;
@end
