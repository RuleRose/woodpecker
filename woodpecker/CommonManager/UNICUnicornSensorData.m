//
//  OwlSensorData.m
//  MMCOwl
//
//  Created by robin guo on 16/3/21.
//  Copyright © 2016年 MiaoMiaoCe. All rights reserved.
//

#import "UNICUnicornSensorData.h"

@implementation UNICUnicornSensorData {
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
    int32_t hight;
    int32_t low;
    int16_t ntcIdx;
    int16_t batteryLevel;
    int32_t curTemperature;
    [_rawData getBytes:macAddr range:NSMakeRange(0, 6)];
    [_rawData getBytes:&hight range:NSMakeRange(6, 4)];
    [_rawData getBytes:&low range:NSMakeRange(10, 4)];
    [_rawData getBytes:&ntcIdx range:NSMakeRange(14, 1)];
    [_rawData getBytes:&batteryLevel range:NSMakeRange(15, 1)];
    [_rawData getBytes:&curTemperature range:NSMakeRange(16, 4)];

    self.MacAddr = [self getMacAddrString:macAddr];
    self.highLimit = hight;
    self.lowLimit = low;
    self.ntcIndex = ntcIdx;
    self.powerLevel = batteryLevel;
    self.currentTemperature = curTemperature;

    return YES;
}

- (NSString *)getMacAddrString:(char[])macAddr {
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", (unsigned char)macAddr[0], (unsigned char)macAddr[1], (unsigned char)macAddr[2],
                                      (unsigned char)macAddr[3], (unsigned char)macAddr[4], (unsigned char)macAddr[5]];
}
@end
