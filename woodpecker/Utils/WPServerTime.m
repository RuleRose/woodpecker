//
//  UNICServerTime.m
//  unicorn
//
//  Created by 肖君 on 16/12/13.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "WPServerTime.h"
@interface WPServerTime ()
@property(nonatomic, assign) NSTimeInterval secondsAheadLocalTime;
@end

@implementation WPServerTime
Singleton_Implementation(WPServerTime);

- (instancetype)init {
    self = [super init];
    if (self) {
        _secondsAheadLocalTime = [[NSTimeZone systemTimeZone] secondsFromGMT];
    }
    return self;
}

- (NSString *)displayStringFromServerString:(NSString *)serverStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
    NSDate *serverDate = [dateFormatter dateFromString:serverStr];
    NSDate *displayDate = [NSDate dateWithTimeInterval:self.secondsAheadLocalTime sinceDate:serverDate];
    
    return [dateFormatter stringFromDate:displayDate];
}

- (NSString *)serverStringFromDisplayString:(NSString *)displayStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
    NSDate *displayDate = [dateFormatter dateFromString:displayStr];
    NSDate *serverDate = [NSDate dateWithTimeInterval:(-self.secondsAheadLocalTime) sinceDate:displayDate];

    return [dateFormatter stringFromDate:serverDate];
}
@end
