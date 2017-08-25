//
//  UNICHelper.h
//  unicorn
//
//  Created by 肖君 on 16/12/7.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNICCommonOrderModel.h"

@interface UNICHelper : NSObject
+ (NSString *)serverMac:(NSString *)orginalMac;
+ (NSString *)BLEConnectMac:(NSString *)orginalMac;

+ (NSString *)temperatureRangeString:(UNICCommonOrderModel *)order;

+ (NSInteger)getTemperatureIndexOfDate:(NSDate *)date baseDate:(NSDate *)baseDate baseIndex:(NSInteger)baseIndex;
+ (NSDate *)getDateOfTemperatureIndex:(NSInteger)index baseDate:(NSDate *)baseDate baseIndex:(NSInteger)baseIndex;

+ (NSString *)timeRangeFromDate:(NSDate *)fromDate to:(NSDate *)toDate;
+ (NSString *)totalTimeOfTimeInterval:(NSTimeInterval)timeInterval;

@end
