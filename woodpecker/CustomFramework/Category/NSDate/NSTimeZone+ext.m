//
//  NSTimeZone+ext.m
//  woodpecker
//
//  Created by yongche on 17/10/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "NSTimeZone+ext.h"

@implementation NSTimeZone (ext)
+(NSInteger)timeZoneDiffwithUTC{
    NSString *strFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate date];
    NSString *stringLocal = [NSDate stringFromDate:date format:strFormat];
    NSString *stringUTC = [NSDate UTCStringFromDate:date format:strFormat];
    NSDate *dateLocal = [NSDate dateFromString:stringLocal format:strFormat];
    NSDate *dateUTC = [NSDate dateFromString:stringUTC format:strFormat];
    
    NSTimeInterval interval = [dateLocal timeIntervalSinceDate:dateUTC];
    NSInteger timeZoneDiff = interval/(60 * 60);
    
    return timeZoneDiff;
}
@end
