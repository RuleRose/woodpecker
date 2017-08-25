//
//  BleDeviceBroadcast.m
//  MiaoMiaoCe
//
//  Created by robin guo on 16/1/13.
//  Copyright © 2016年 Weisi Smart. All rights reserved.
//

#import "BleDeviceBroadcast.h"
#import "MMC_Ntc.h"

@implementation BleDeviceBroadcast

// 1.103*temp - 1.5339
- (CGFloat)highLimit {
    return [MMC_Ntc ntcResistanceToTemperature:(float)self.highLimitRaw index:(int)self.ntcIndex];
}

- (CGFloat)lowLimit {
    return [MMC_Ntc ntcResistanceToTemperature:(float)self.lowLimitRaw index:(int)self.ntcIndex];
}

- (CGFloat)currentTemperature {
    return [MMC_Ntc ntcResistanceToTemperature:(float)self.currentTemperatureRaw index:(int)self.ntcIndex];
}

- (NSInteger)powerLevel {
    NSInteger result;
    result = self.powerLevelRaw * 3.1f - 428;

    return result > 100 ? 100 : result;
}

- (NSInteger)durationDay {
    return (self.powerLevel / 100.0f) * 547;
}

- (id)init {
    self = [super init];
    if (self) {
        _TTL = 0;
        _t1 = 0;
        _t2 = 0;
        _recordCount = -1;
    }
    return self;
}
@end
