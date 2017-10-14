//
//  NSDate+Extension.h
//  easyMeasure
//
//  Created by qiwl on 2017/6/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSInteger)yearOfDate:(NSDate *)date;
+ (NSInteger)monthOfDate:(NSDate *)date;
+ (NSInteger)weekOfDate:(NSDate *)date;
+ (NSInteger)dayOfDate:(NSDate *)date;
+ (NSInteger)hourOfDate:(NSDate *)date;
+ (NSInteger)weekdayOfDate:(NSDate*)date;
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)UTCStringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
+ (NSString *)timestampFromDate:(NSDate *)date;
+ (NSDate *)dateFromTimestampStr:(NSString *)timestampStr;
+ (NSString *)timestampFromDateStr:(NSString *)dateStr;
+ (NSString *)dateStrFromTimestampStr:(NSString *)timestamp;
+ (BOOL)isDateInToday:(NSDate *)date;
+ (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toCalendarUnit:(NSCalendarUnit)unit;
+ (NSInteger)daysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date;
+ (BOOL)isDateAfterToday:(NSDate *)date;

@end
