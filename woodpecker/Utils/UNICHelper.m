//
//  UNICHelper.m
//  unicorn
//
//  Created by 肖君 on 16/12/7.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "UNICHelper.h"

@implementation UNICHelper
// mac address convert
// XXXXXXXXXXXX
+ (NSString *)serverMac:(NSString *)orginalMac {
    return [orginalMac stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// XXXXXXXXXXXX low case
+ (NSString *)BLEConnectMac:(NSString *)orginalMac {
    return [orginalMac stringByReplacingOccurrencesOfString:@" " withString:@""].lowercaseString;
}

+ (NSString *)temperatureRangeString:(UNICCommonOrderModel *)order {
    return [NSString stringWithFormat:kLocalization(@"common_temperature_range"), order.low_temp, order.high_temp];
}

+ (NSInteger)getTemperatureIndexOfDate:(NSDate *)date baseDate:(NSDate *)baseDate baseIndex:(NSInteger)baseIndex {
    NSTimeInterval interval = [date timeIntervalSinceDate:baseDate];
    NSInteger intervalIndex = interval / (60 * 5);

    return MAX(1, intervalIndex + baseIndex);
}

+ (NSDate *)getDateOfTemperatureIndex:(NSInteger)index baseDate:(NSDate *)baseDate baseIndex:(NSInteger)baseIndex {
    NSInteger intervalIndex = (index - baseIndex) * (60 * 5);

    return [NSDate dateWithTimeInterval:intervalIndex sinceDate:baseDate];
}

+ (NSString *)timeRangeFromDate:(NSDate *)fromDate to:(NSDate *)toDate {
    NSString *from = [fromDate displayStringOfDate];
    NSString *to = [toDate displayStringOfDate];

    return [NSString
        stringWithFormat:@"%@ - %@", [from substringWithRange:NSMakeRange(2, from.length - 5)], [to substringWithRange:NSMakeRange(2, to.length - 5)]];
}

+ (NSString *)totalTimeOfTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger min = ((NSInteger)(timeInterval / 60)) % 60;
    NSInteger hour = ((NSInteger)(timeInterval / (60 * 60))) % 24;
    NSInteger day = (NSInteger)timeInterval / (60 * 60 * 24);
    NSString *retString;
    if (day > 0) {
        NSString *dayStr = [NSString stringWithFormat:kLocalization(@"common_temperature_chart_total_time_d"), day];
        NSString *hourStr = [NSString stringWithFormat:kLocalization(@"common_temperature_chart_total_time_h"), hour];
        NSString *minStr = [NSString stringWithFormat:kLocalization(@"common_temperature_chart_total_time_m"), min];
        retString = [NSString stringWithFormat:@"%@%@%@", dayStr, hourStr, minStr];
    } else if (hour > 0) {
        NSString *hourStr = [NSString stringWithFormat:kLocalization(@"common_temperature_chart_total_time_h"), hour];
        NSString *minStr = [NSString stringWithFormat:kLocalization(@"common_temperature_chart_total_time_m"), min];
        retString = [NSString stringWithFormat:@"%@%@", hourStr, minStr];
    } else {
        NSString *minStr = [NSString stringWithFormat:kLocalization(@"common_temperature_chart_total_time_m"), min];
        retString = minStr;
    }

    return retString;
}
@end
