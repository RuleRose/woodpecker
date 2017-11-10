//
//  NSDate+Extension.m
//  easyMeasure
//
//  Created by qiwl on 2017/6/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+ (NSCalendar *)calendar{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.locale = [NSLocale currentLocale];
    calendar.timeZone = [NSTimeZone localTimeZone];
    return calendar;
}

+ (NSDateComponents *)components{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.calendar = [self calendar];
    components.timeZone = [NSTimeZone localTimeZone];
    return components;
}

+ (NSDateFormatter *)localFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [self calendar];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.locale = [NSLocale currentLocale];
    return formatter;
}

+ (NSInteger)yearOfDate:(NSDate *)date{
    NSDateComponents *component = [[self calendar] components:NSCalendarUnitYear fromDate:date];
    return component.year;
}

+ (NSInteger)monthOfDate:(NSDate *)date{
    
    NSDateComponents *component = [[self calendar] components:NSCalendarUnitMonth
                                                     fromDate:date];
    return component.month;
}
+ (NSInteger)weekOfDate:(NSDate *)date
{
    NSDateComponents *component = [[self calendar] components:NSCalendarUnitWeekOfYear fromDate:date];
    return component.weekOfYear;
}

+ (NSInteger)dayOfDate:(NSDate *)date{
    NSDateComponents *component = [[self calendar] components:NSCalendarUnitDay
                                                     fromDate:date];
    return component.day;
}

+ (NSInteger)hourOfDate:(NSDate *)date{
    NSDateComponents *component = [[self calendar] components:NSCalendarUnitHour
                                                     fromDate:date];
    return component.hour;
}

+ (NSInteger)weekdayOfDate:(NSDate*)date
{
    NSDateComponents* component = [[self calendar] components:NSCalendarUnitWeekday fromDate:date];
    return component.weekday;
}

+ (NSDate *)beginingOfMonthOfDate:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.locale = [NSLocale currentLocale];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitSecond|NSCalendarUnitMinute fromDate:date];
    components.day = 1;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfMonthOfDate:(NSDate *)date{
    
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    components.month++;
    components.day = 0;
    return [[self calendar] dateFromComponents:components];
}

+ (NSDate *)nextMonthOfDate:(NSDate *)date{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:date];
    components.month++;
    components.hour = 0;
    return [[self calendar] dateFromComponents:components];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *formatter = [self localFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date{
    return [NSDate stringFromDate:date format:@"yyyy MM dd"];
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter = [self localFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (NSDate *)dateFromUTCString:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter = [self UTCFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (NSString *)timestampFromDate:(NSDate *)date{
    if (date) {
        return [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]];
    }else{
        return @"";
    }
}

+ (NSDate *)dateFromTimestampStr:(NSString *)timestampStr{
    if (![NSString leie_isBlankString:timestampStr]) {
        return [NSDate dateWithTimeIntervalSince1970:[timestampStr longLongValue]];
    }else{
        return nil;
    }
}

+ (NSString *)timestampFromDateStr:(NSString *)dateStr{
    if (![NSString leie_isBlankString:dateStr]) {
        NSDate* date = [self dateFromString:dateStr format:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timestamp = [self timestampFromDate:date];
        return timestamp;
    }else{
        return @"";
    }
}

+ (NSString *)dateStrFromTimestampStr:(NSString *)timestamp{
    if (![NSString leie_isBlankString:timestamp]) {
        NSDate *date = [NSDate dateFromTimestampStr:timestamp];
        return [NSDate stringFromDate:date format:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        return @"";
    }
}

+ (BOOL)isDateInToday:(NSDate *)date{
    return [self isDate:date equalToDate:[NSDate date] toCalendarUnit:NSCalendarUnitDay];
}

+ (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toCalendarUnit:(NSCalendarUnit)unit{
    switch (unit) {
        case NSCalendarUnitMonth:
            return [self yearOfDate:date1] == [self yearOfDate:date2] && [self monthOfDate:date1] == [self monthOfDate:date2];
        case NSCalendarUnitWeekOfYear:
            return [self yearOfDate:date1] == [self yearOfDate:date2] && [self weekOfDate:date1] == [self weekOfDate:date2];
        case NSCalendarUnitDay:
            return [self yearOfDate:date1] == [self yearOfDate:date2] && [self monthOfDate:date1] == [self monthOfDate:date2] && [self dayOfDate:date1] == [self dayOfDate:date2];
        default:
            break;
    }
    return NO;
}

+ (BOOL)isDateAfterToday:(NSDate *)date{
    return [self isDate:date afterToDate:[NSDate date] toCalendarUnit:NSCalendarUnitDay];
}

+ (BOOL)isDate:(NSDate *)date1 afterToDate:(NSDate *)date2 toCalendarUnit:(NSCalendarUnit)unit{
    switch (unit) {
        case NSCalendarUnitMonth:
            if ([self yearOfDate:date1] > [self yearOfDate:date2]) {
                return YES;
            }else if ([self yearOfDate:date1] == [self yearOfDate:date2]){
                if ([self monthOfDate:date1] > [self monthOfDate:date2]) {
                    return YES;
                }
            }
        case NSCalendarUnitWeekOfYear:
            if ([self yearOfDate:date1] > [self yearOfDate:date2]) {
                return YES;
            }else if ([self yearOfDate:date1] == [self yearOfDate:date2]){
                if ([self weekOfDate:date1] > [self weekOfDate:date2]) {
                    return YES;
                }
            }
        case NSCalendarUnitDay:
            if ([self yearOfDate:date1] > [self yearOfDate:date2]) {
                return YES;
            }else if ([self yearOfDate:date1] == [self yearOfDate:date2]){
                if ([self monthOfDate:date1] > [self monthOfDate:date2]) {
                    return YES;
                }else if ([self monthOfDate:date1] == [self monthOfDate:date2]){
                    if ([self dayOfDate:date1] > [self dayOfDate:date2]) {
                        return YES;
                    }
                }
            }
        default:
            break;
    }
    return NO;
}

+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSDateComponents *components = [[self calendar] components:NSCalendarUnitDay
                                                     fromDate:fromDate
                                                       toDate:toDate
                                                      options:0];
    return components.day;
}

+ (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date
{
    if (!date) return nil;
    NSDateComponents *components = self.components;
    components.day = days;
    NSDate *d = [[self calendar] dateByAddingComponents:components toDate:date options:0];
    components.day = NSIntegerMax;
    return d;
}

+ (NSDateFormatter *)UTCFormatter{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = [self calendar];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    formatter.locale = [NSLocale currentLocale];
    return formatter;
}

+ (NSString *)UTCStringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *formatter = [self UTCFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}
@end
