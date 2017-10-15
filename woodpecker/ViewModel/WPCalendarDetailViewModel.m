//
//  WPCalendarDetailViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarDetailViewModel.h"
#import "WPEventModel.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "NSDate+Extension.h"
#import "XJFDBManager.h"

@interface WPCalendarDetailViewModel ()

@property(nonatomic, strong)NSArray *startEvents;
@property(nonatomic, strong)NSArray *endEvents;

@end
@implementation WPCalendarDetailViewModel
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
        if ([event.date longLongValue] <= timestamp) {
            startEvent = event;
            break;
        }
    }
    if (startEvent) {
        if ([_profile.period integerValue] > 0) {
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startEvent.date longLongValue]];
            NSInteger days = [NSDate daysFromDate:startDate toDate:date];
            startDate = [NSDate dateByAddingDays:-(days%([_profile.period integerValue])) toDate:date];
            NSTimeInterval startTime = [startDate timeIntervalSince1970];
            WPEventModel *endEvent;
            for (WPEventModel *event in _endEvents) {
                if (([event.date longLongValue] >= [startEvent.date longLongValue]) && ([event.date longLongValue] <= startTime + [_profile.period longLongValue])) {
                    endEvent = event;
                    break;
                }
            }
            days = [NSDate daysFromDate:startDate toDate:date];
            NSInteger menstruation = [_profile.menstruation integerValue];
            if (endEvent) {
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endEvent.date longLongValue]];
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

- (void)getPeriodWithData:(NSDate *)date block:(void (^)(PeriodType period_type,NSInteger period_days,NSInteger pregnancy_days))result{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    WPEventModel *startEvent;
    for (WPEventModel *event in _startEvents) {
        if ([event.date longLongValue] <= timestamp) {
            startEvent = event;
            break;
        }
    }
    PeriodType period_type = kPeriodTypeOfSafe;
    if (startEvent) {
        if ([_profile.period integerValue] > 0) {
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startEvent.date longLongValue]];
            NSInteger days = [NSDate daysFromDate:startDate toDate:date];
            startDate = [NSDate dateByAddingDays:-(days%([_profile.period integerValue])) toDate:date];
            NSTimeInterval startTime = [startDate timeIntervalSince1970];
            WPEventModel *endEvent;
            for (WPEventModel *event in _endEvents) {
                if (([event.date longLongValue] >= [startEvent.date longLongValue]) && ([event.date longLongValue] <= startTime + [_profile.period longLongValue])) {
                    endEvent = event;
                    break;
                }
            }
            days = [NSDate daysFromDate:startDate toDate:date];
            NSInteger menstruation = [_profile.menstruation integerValue];
            if (endEvent) {
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endEvent.date longLongValue]];
                menstruation = [NSDate daysFromDate:startDate toDate:endDate];
            }
            if (days <= menstruation) {
                if ([NSDate isDateAfterToday:date]) {
                    period_type = kPeriodTypeOfForecast;
                }else{
                    period_type = kPeriodTypeOfMenstrual;
                }
            }else if(days == [_profile.period integerValue] - 14){
                period_type = kPeriodTypeOfOviposit;
            }else if ((days >= [_profile.period integerValue] - 19) && (days <= [_profile.period integerValue] - 10)){
                period_type = kPeriodTypeOfPregnancy;
            }
            NSInteger pregnancy_days = period_type + [_profile.period integerValue] - 20 - days;
            if (pregnancy_days < 0) {
                pregnancy_days = 0;
            }
            if (result) {
                result(period_type, days, pregnancy_days);
            }
        }else{
            if (result) {
                result(period_type, 0,  0);
            }
        }
    }else{
        if (result) {
            result(period_type, 0,  0);
        }
    }
}

- (NSInteger)daysOfPeriod:(NSDate *)date{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    WPEventModel *startEvent;
    for (WPEventModel *event in _startEvents) {
        if ([event.date longLongValue] <= timestamp) {
            startEvent = event;
            break;
        }
    }
    if (startEvent) {
        if ([_profile.period integerValue] > 0) {
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startEvent.date longLongValue]];
            NSInteger days = [NSDate daysFromDate:startDate toDate:date];
            startDate = [NSDate dateByAddingDays:-(days%([_profile.period integerValue])) toDate:date];
            days = [NSDate daysFromDate:startDate toDate:date];
            return days;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
@end
