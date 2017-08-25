//
//  NSDate+ext.m
//  mmcS2
//
//  Created by 肖君 on 16/11/7.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "NSDate+ext.h"
@implementation NSDate (ext)
+ (instancetype)dateWithTimeIntervalSince2000:(NSTimeInterval)secs {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y/M/d HH:mm:ss"];
    NSDate *fromDate = [dateFormatter dateFromString:@"2000/1/1 00:00:00"];
    return [NSDate dateWithTimeIntervalSince1970:(secs + fromDate.timeIntervalSince1970)];
}

- (NSTimeInterval)timeIntervalSince2000 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"y/M/d HH:mm:ss"];
    NSDate *fromDate = [dateFormatter dateFromString:@"2000/1/1 00:00:00"];
    return self.timeIntervalSince1970 - fromDate.timeIntervalSince1970;
}

+ (instancetype)dateOfDisplayString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:dateStr];
}

- (NSString *)displayStringOfDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:[NSDate date]];

    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}

@end
