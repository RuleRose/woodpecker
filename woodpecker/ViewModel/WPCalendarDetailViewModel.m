//
//  WPCalendarDetailViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarDetailViewModel.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "NSDate+Extension.h"
#import "XJFDBManager.h"
#import "WPPeriodModel.h"

@interface WPCalendarDetailViewModel ()


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
        _periods = [self getPeriods];
    }
    return self;
}

- (PeriodType)getPeriodWithDate:(NSDate *)date{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    WPPeriodModel *current_period;
    WPPeriodModel *next_period;
    for (NSInteger i = _periods.count - 1; i >= 0; i --) {
        WPPeriodModel *period = [_periods objectAtIndex:i];
        NSDate *startDate = [NSDate dateFromString:period.period_start format:@"yyyy MM dd"];
        NSTimeInterval start_timestamp = [startDate timeIntervalSince1970];
        if (start_timestamp <= timestamp) {
            current_period = period;
            break;
        }
        next_period = period;
    }
    if (!current_period) {
        return kPeriodTypeOfSafe;
    }
    WPProfileModel *profile = [[WPProfileModel alloc] init];
    [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
    NSDate *startDate;
    NSDate *endDate;
    if (![NSString leie_isBlankString:current_period.period_start]) {
        startDate = [NSDate dateFromString:current_period.period_start format:@"yyyy MM dd"];
    }
    if (![NSString leie_isBlankString:current_period.period_end]) {
        endDate = [NSDate dateFromString:current_period.period_end format:@"yyyy MM dd"];
    }
    if (!startDate) {
        return kPeriodTypeOfSafe;
    }
    NSInteger days = [NSDate daysFromDate:startDate toDate:date];
    PeriodType period_type = kPeriodTypeOfSafe;
    if (days <= current_period.menstruation_lenth) {
        if (current_period.speculate) {
            period_type = kPeriodTypeOfForecast;
        }else{
            period_type =  kPeriodTypeOfMenstrual;
        }
    }else if (days == current_period.oviposit){
        period_type =  kPeriodTypeOfOviposit;
    }else if ((days >= current_period.pregnancy_start) && (days<= current_period.pregnancy_end)){
        period_type =  kPeriodTypeOfPregnancy;
    }
    return period_type;
}

- (void)getPeriodWithData:(NSDate *)date block:(void (^)(PeriodType period_type,NSInteger period_days,NSInteger pregnancy_days))result{
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    WPPeriodModel *current_period;
    WPPeriodModel *next_period;
    for (NSInteger i = _periods.count - 1; i >= 0; i --) {
        WPPeriodModel *period = [_periods objectAtIndex:i];
        NSDate *startDate = [NSDate dateFromString:period.period_start format:@"yyyy MM dd"];
        NSTimeInterval start_timestamp = [startDate timeIntervalSince1970];
        if (start_timestamp <= timestamp) {
            current_period = period;
            break;
        }
        next_period = period;
    }
    if (!current_period) {
        if (result) {
            result(kPeriodTypeOfSafe, 0,  0);
        }
    }
    WPProfileModel *profile = [[WPProfileModel alloc] init];
    [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
    NSDate *startDate;
    NSDate *endDate;
    if (![NSString leie_isBlankString:current_period.period_start]) {
        startDate = [NSDate dateFromString:current_period.period_start format:@"yyyy MM dd"];
    }
    if (![NSString leie_isBlankString:current_period.period_end]) {
        endDate = [NSDate dateFromString:current_period.period_end format:@"yyyy MM dd"];
    }
    if (!startDate) {
        if (result) {
            result(kPeriodTypeOfSafe, 0,  0);
        }
    }
    NSInteger days = [NSDate daysFromDate:startDate toDate:date];
    PeriodType period_type = kPeriodTypeOfSafe;
    if (days <= current_period.period_lenth) {
        if (current_period.speculate) {
            period_type = kPeriodTypeOfForecast;
        }else{
            period_type =  kPeriodTypeOfMenstrual;
        }
    }else if (days == current_period.oviposit){
        period_type =  kPeriodTypeOfOviposit;
    }else if ((days >= current_period.pregnancy_start) && (days<= current_period.pregnancy_end)){
        period_type =  kPeriodTypeOfPregnancy;
    }
    NSInteger pregnancy_days =  current_period.pregnancy_start - days;
    if (pregnancy_days < 0) {
        if (next_period) {
            pregnancy_days = current_period.period_lenth - days + next_period.pregnancy_start;
        }else{
            pregnancy_days += [_profile.period integerValue];
        }
    }
    if (result) {
        result(period_type, days, pregnancy_days);
    }
}

- (NSMutableArray *)getPeriods{
    WPProfileModel *profile = [[WPProfileModel alloc] init];
    [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
    WPPeriodModel *period = [[WPPeriodModel alloc] init];
    NSArray *periods = [XJFDBManager searchModelsWithCondition:period andpage:-1 andOrderby:@"period_start" isAscend:YES];
    NSMutableArray *allPeriods = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < periods.count; i ++) {
        WPPeriodModel *peirod = periods[i];
        NSDate *date = [NSDate dateFromString:peirod.period_start format:@"yyyy MM dd"];
        NSDate *nextDate = [NSDate date];
        if (periods.count > i +1) {
            //后面就还有数据
            WPPeriodModel *peirod_next = periods[i + 1];
            nextDate = [NSDate dateFromString:peirod_next.period_start format:@"yyyy MM dd"];
        }
        [allPeriods addObject:peirod];
        NSInteger days = [NSDate daysFromDate:date toDate:nextDate];
        while (days > [profile.period integerValue]) {
            NSDate *addDate = [NSDate dateByAddingDays:[profile.period integerValue] toDate:nextDate];
            WPPeriodModel *add_peirod = [[WPPeriodModel alloc] init];
            add_peirod.period_start = [NSDate stringFromDate:addDate];
            add_peirod.speculate = YES;
            [allPeriods addObject:add_peirod];
            days -=  [profile.period integerValue];
        }
    }
    WPPeriodModel *next_period;
    for (NSInteger i = allPeriods.count - 1; i >= 0; i --) {
        WPPeriodModel *period = [allPeriods objectAtIndex:i];
        NSDate *startDate;
        NSDate *endDate;
        if (![NSString leie_isBlankString:period.period_start]) {
            startDate = [NSDate dateFromString:period.period_start format:@"yyyy MM dd"];
        }
        if (![NSString leie_isBlankString:period.period_end]) {
            endDate = [NSDate dateFromString:period.period_end format:@"yyyy MM dd"];
        }
        NSInteger menstruation_lenth = [profile.menstruation integerValue];
        if (endDate) {
            menstruation_lenth = [NSDate daysFromDate:startDate toDate:endDate];
        }
        NSInteger period_lenth = [profile.period integerValue];
        if (next_period) {
            NSDate *nextStartDate;
            if (![NSString leie_isBlankString:next_period.period_start]) {
                nextStartDate = [NSDate dateFromString:next_period.period_start format:@"yyyy MM dd"];
            }
            period_lenth = [NSDate daysFromDate:startDate toDate:nextStartDate];
        }
        period.menstruation_lenth = menstruation_lenth;
        period.period_lenth  = period_lenth;
        period.oviposit = period_lenth - 14;
        period.pregnancy_start = period.oviposit - 5;
        period.pregnancy_end = period.oviposit + 4;
        next_period = period;
    }
    return allPeriods;
}
@end
