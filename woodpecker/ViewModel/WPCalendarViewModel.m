//
//  WPCalendarViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarViewModel.h"
#import "XJFDBManager.h"

@interface WPCalendarViewModel ()

@end

@implementation WPCalendarViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _user = [[WPUserModel alloc] init];
        [_user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        _profile = [[WPProfileModel alloc] init];
        [_profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
        WPEventModel *event = [[WPEventModel alloc] init];
        event.status = @"1"; //start
        _startEvents = [XJFDBManager searchModelsWithCondition:event andpage:-1 andOrderby:@"date" isAscend:NO];
        event.status = @"2"; //end
        _endEvents = [XJFDBManager searchModelsWithCondition:event andpage:-1 andOrderby:@"date" isAscend:NO];
        
    }
    return self;
}

- (PeriodType)getPeriodWithDate:(NSDate *)date{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    WPEventModel *startEvent;
    for (WPEventModel *event in _startEvents) {
        NSDate *eventDate = [NSDate dateFromString:event.date format:@"yyyy MM dd"];
        NSTimeInterval event_timestamp = [eventDate timeIntervalSince1970];
        if (event_timestamp <= timestamp) {
            startEvent = event;
            break;
        }
    }
    if (startEvent) {
        if ([_profile.period integerValue] > 0) {
            NSDate *startDate = [NSDate dateFromString:startEvent.date format:@"yyyy MM dd"];
            NSInteger days = [NSDate daysFromDate:startDate toDate:date];
            startDate = [NSDate dateByAddingDays:-(days%([_profile.period integerValue])) toDate:date];
            NSTimeInterval startTime = [startDate timeIntervalSince1970];
            WPEventModel *endEvent;
            for (WPEventModel *event in _endEvents) {
                NSDate *eventDate = [NSDate dateFromString:event.date format:@"yyyy MM dd"];
                NSTimeInterval event_timestamp = [eventDate timeIntervalSince1970];
                if ((event_timestamp >= startTime) && (event_timestamp <= startTime + [_profile.period longLongValue])) {
                    endEvent = event;
                    break;
                }
            }
            days = [NSDate daysFromDate:startDate toDate:date];
            NSInteger menstruation = [_profile.menstruation integerValue];
            if (endEvent) {
                NSDate *endDate = [NSDate dateFromString:endEvent.date format:@"yyyy MM dd"];
                menstruation = [NSDate daysFromDate:startDate toDate:endDate];
            }
            if (days <= menstruation) {
                if ([NSDate isDateAfterToday:date]) {
                    return kPeriodTypeOfForecast;
                }else{
                    return kPeriodTypeOfMenstrual;
                }
            }else if(days == [_profile.period integerValue] - 14){
                return kPeriodTypeOfOviposit;
            }else if ((days >= [_profile.period integerValue] - 19) && (days <= [_profile.period integerValue] - 10)){
                return kPeriodTypeOfPregnancy;
            }else{
                return kPeriodTypeOfSafe;
            }
        }else{
            return kPeriodTypeOfSafe;
        }
    }else{
        return kPeriodTypeOfSafe;
    }
}
@end
