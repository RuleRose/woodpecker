//
//  NSDate+Extension.h
//  easyMeasure
//
//  Created by qiwl on 2017/6/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
+ (NSString *)timestampFromDate:(NSDate *)date;
+ (NSDate *)dateFromTimestampStr:(NSString *)timestampStr;
+ (NSString *)timestampFromDateStr:(NSString *)dateStr;
+ (NSString *)dateStrFromTimestampStr:(NSString *)timestamp;
@end
