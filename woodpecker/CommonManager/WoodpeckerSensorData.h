//
//  OwlSensorData.h
//  MMCOwl
//
//  Created by robin guo on 16/3/21.
//  Copyright © 2016年 MiaoMiaoCe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoodpeckerSensorData : NSObject

- (instancetype)initWithRawData:(NSData *)data;

@property (nonatomic, assign, readonly) uint8_t version;
@property (nonatomic, assign, readonly) uint16_t productID;
@property (nonatomic, assign, readonly) uint16_t eventID;
@property (nonatomic, assign, readonly) float temp1;
@property (nonatomic, assign, readonly) float temp2;
@property (nonatomic, assign, readonly) int8_t batteryLevel;

@end
