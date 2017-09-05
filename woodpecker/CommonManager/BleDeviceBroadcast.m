//
//  BleDeviceBroadcast.m
//  MiaoMiaoCe
//
//  Created by robin guo on 16/1/13.
//  Copyright © 2016年 Weisi Smart. All rights reserved.
//

#import "BleDeviceBroadcast.h"

@interface BleDeviceBroadcast (){
    char macAddr[6];
}
@end

@implementation BleDeviceBroadcast

- (id)init
{
    self = [super init];
    if (self) {
        _TTL = 0;
        _t1 = 0;
        _t2 = 0;
        _batteryLevel = 0;
    }
    
    return self;
}

-(char *)getMacAddr
{
    return macAddr;
}

- (NSString *)getMacAddrString{
    return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
            (unsigned char)*(macAddr+5),(unsigned char)*(macAddr+4),
            (unsigned char)*(macAddr+3),(unsigned char)*(macAddr+2),
            (unsigned char)*(macAddr+1),(unsigned char)*macAddr];
}

-(void) setMacAddr:(char [6])mac
{
    macAddr[0] = mac[0];
    macAddr[1] = mac[1];
    macAddr[2] = mac[2];
    macAddr[3] = mac[3];
    macAddr[4] = mac[4];
    macAddr[5] = mac[5];
}

@end
