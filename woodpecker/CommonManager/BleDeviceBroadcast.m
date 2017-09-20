//
//  BleDeviceBroadcast.m
//  MiaoMiaoCe
//
//  Created by robin guo on 16/1/13.
//  Copyright © 2016年 Weisi Smart. All rights reserved.
//

#import "BleDeviceBroadcast.h"

@implementation BleDeviceBroadcast

- (id)init {
    self = [super init];
    if (self) {
        _TTL = 0;
        _t1 = 0;
        _t2 = 0;
        _batteryLevelRaw = 0;
    }

    return self;
}
@end
