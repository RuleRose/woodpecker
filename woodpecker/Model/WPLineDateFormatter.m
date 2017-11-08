//
//  WPLineDateFormatter.m
//  woodpecker
//
//  Created by QiWL on 2017/10/25.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLineDateFormatter.h"
#import "NSDate+Extension.h"
#import "WPPeriodCountManager.h"

@interface WPLineDateFormatter ()
{
    NSDateFormatter *_dateFormatter;
}
@end
@implementation WPLineDateFormatter
- (id)init
{
    self = [super init];
    if (self)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MMdd";
        _startDate = [NSDate date];
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSDate *date = [NSDate dateByAddingDays:value toDate:_startDate];
    WPDayInfoInPeriod *dayinfo = [[WPPeriodCountManager defaultInstance] dayInfo:date];
    _dateFormatter.dateFormat = [NSString stringWithFormat:@"MMdd\n%ld",(long)dayinfo.dayInPeriod];
    return [_dateFormatter stringFromDate:date];
}
@end
