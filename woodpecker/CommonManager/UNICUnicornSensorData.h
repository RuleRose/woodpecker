//
//  OwlSensorData.h
//  MMCOwl
//
//  Created by robin guo on 16/3/21.
//  Copyright © 2016年 MiaoMiaoCe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNICUnicornSensorData : NSObject

- (instancetype)initWithRawData:(NSData *)data;
@property(nonatomic, copy) NSString *MacAddr;
@property (nonatomic,assign) NSInteger highLimit;
@property (nonatomic,assign) NSInteger lowLimit;
@property (nonatomic,assign) NSInteger powerLevel;
@property (nonatomic,assign) NSInteger currentTemperature;
@property (nonatomic,assign) NSInteger ntcIndex;
@end
