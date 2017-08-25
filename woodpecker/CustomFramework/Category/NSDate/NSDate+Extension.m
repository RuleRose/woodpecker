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

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format{
    NSDateFormatter *formatter = [self localFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date{
    return [NSDate stringFromDate:date format:@"yyyy-MM-dd"];
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter = [self localFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}

+ (NSString *)timestampFromDate:(NSDate *)date{
    if (date) {
        return [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]*1000];
    }else{
        return @"";
    }
}

+ (NSDate *)dateFromTimestampStr:(NSString *)timestampStr{
    if (![NSString leie_isBlankString:timestampStr]) {
        return [NSDate dateWithTimeIntervalSince1970:[timestampStr longLongValue]/1000];
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

@end
