//
//  BleDevice.m
//  MiaoMiaoCe
//
//  Created by lanp on 15/12/4.
//  Copyright (c) 2015年 Weisi Smart. All rights reserved.
//

#import "BleDevice.h"

@implementation BleDevice

- (id)init
{
    self = [super init];
    if (self) {
        _RSSI = 0;
        _scanningTTL = 0;
    }
    
    return self;
}

-(MMCDeviceWorkMode)getWorkMode{
    if (self.type == MMC_TYPE_C ||
        self.type == MMC_TYPE_D ||
        self.type == MMC_TYPE_A ||
        self.type == MMC_TYPE_C_OR_D) {
        return MMCDeviceWorkMode_Connect;
    }else{
        return MMCDeviceWorkMode_Broadcast;
    }
}

- (BOOL)isSameIdentifier:(NSUUID *)identifier{
    return [self.identifier.UUIDString isEqualToString:identifier.UUIDString];
}

@end
