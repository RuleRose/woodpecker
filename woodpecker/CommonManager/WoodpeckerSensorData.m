//
//  OwlSensorData.m
//  MMCOwl
//
//  Created by robin guo on 16/3/21.
//  Copyright © 2016年 MiaoMiaoCe. All rights reserved.
//

#import "WoodpeckerSensorData.h"

@implementation WoodpeckerSensorData{
    NSData *_rawData;
}

- (instancetype)init{
    @throw [NSException exceptionWithName:@"InitializationError" reason:@"Use initWithRawData: not init." userInfo:nil];
    return nil;
}

- (instancetype)initWithRawData:(NSData *)data{
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

- (BOOL)parseData{
    char macAddr[6];
    int16_t temp1, temp2;
    char batteryData;
    
    [_rawData getBytes:&_productID range:NSMakeRange(2, 2)];
    [_rawData getBytes:macAddr range:NSMakeRange(5, 6)];
    [_rawData getBytes:&temp1 range:NSMakeRange(15, 2)];
    [_rawData getBytes:&temp2 range:NSMakeRange(17, 2)];
    [_rawData getBytes:&batteryData range:NSMakeRange(19, 1)];
    
    //ultralimit temperature detection
//    if (temp1==0x7FF1 || temp1==0x7FF2 || temp1==0x7FF0) {
//        return NO;
//    }else{
//        _temp1 = temp1 / 100.f;
//    }
//    
//    _temp2 = temp2 / 100.f;
//    _batteryLevel = batteryData;
    return YES;
}

@end
