//
//  OwlSensorData.m
//  MMCOwl
//
//  Created by robin guo on 16/3/21.
//  Copyright © 2016年 MiaoMiaoCe. All rights reserved.
//

#import "WoodpeckerSensorData.h"

@implementation WoodpeckerSensorData {
    NSData *_rawData;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"InitializationError" reason:@"Use initWithRawData: not init." userInfo:nil];
    return nil;
}

- (instancetype)initWithRawData:(NSData *)data {
    self = [super init];
    if (self) {
        _rawData = data;
        if (_rawData.length != 20) {
            return nil;
        }
        BOOL result = [self parseData];
        if (!result) {
            return nil;
        }
    }
    return self;
}

- (BOOL)parseData {
    char macAddr[6];
    char productID[2];
    int8_t batteryLevel;

    //    int16_t temp1, temp2;
    //    char batteryData;

    [_rawData getBytes:productID range:NSMakeRange(2, 2)];
    [_rawData getBytes:macAddr range:NSMakeRange(5, 6)];
    //    [_rawData getBytes:&temp1 range:NSMakeRange(15, 2)];
    //    [_rawData getBytes:&temp2 range:NSMakeRange(17, 2)];
    [_rawData getBytes:&batteryLevel range:NSMakeRange(19, 1)];

    self.MacAddr = [self getMacAddrString:macAddr];
    self.productID = [self getProductIDString:productID];
    self.powerLevel = batteryLevel;

    return YES;
}

- (NSString *)getMacAddrString:(char[])macAddr {
    return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", (unsigned char)macAddr[5], (unsigned char)macAddr[4], (unsigned char)macAddr[3], (unsigned char)macAddr[2], (unsigned char)macAddr[1], (unsigned char)macAddr[0]];
}

- (NSString *)getProductIDString:(char[])productID {
    return [NSString stringWithFormat:@"%02x%02x", (unsigned char)productID[1], (unsigned char)productID[0]];
}
@end
