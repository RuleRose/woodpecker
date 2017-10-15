//
//  WPTemperatureViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureViewModel.h"
#import "XJFDBManager.h"
#import "WPTemperatureModel.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "WPEventModel.h"
#import "NSDate+Extension.h"
#import "NSDate+ext.h"

@interface WPTemperatureViewModel ()

@property(nonatomic, strong)NSArray *startEvents;
@property(nonatomic, strong)NSArray *endEvents;
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;
@end
@implementation WPTemperatureViewModel
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

- (void)getTempsBlock:(void (^)(NSMutableArray *sortTemps))result{
    WPTemperatureModel *searchTemp = [[WPTemperatureModel alloc] init];
    NSArray *temperatures = [XJFDBManager searchModelsWithCondition:searchTemp andpage:-1 andOrderby:@"time" isAscend:NO];
    NSDate *tempDate;
    PeriodType tempType = kPeriodTypeOfSafe;
    NSMutableArray *sortTemp = [[NSMutableArray alloc] init];
    NSMutableArray *temps = [[NSMutableArray alloc] init];
    for (WPTemperatureModel *temperature in temperatures) {
        NSDate *date = [NSDate dateWithTimeIntervalSince2000:[temperature.time longLongValue]];
        if (tempDate) {
            //判断两个日期是否是同一天
            if (![NSDate isDate:date equalToDate:tempDate toCalendarUnit:NSCalendarUnitDay]) {
             //不是同一天判断是否连续
                NSInteger days = [NSDate daysFromDate:date toDate:tempDate];
                if (days <= 1 && days >= -1) {
                    //连续
                    //判断两天是否在同一个期间
                    PeriodType periodType = [self getPeriodWithDate:date];
                    temperature.period_type = periodType;
                    if (tempType == periodType) {
                        [temps addObject:temperature];
                        tempDate = date;
                        tempType = periodType;
                    }else{
                        [temps addObject:temperature];
                        temps = [[NSMutableArray alloc] init];
                        [sortTemp addObject:temps];
                        [temps addObject:temperature];
                        tempDate = date;
                        tempType = periodType;
                    }
                }else{
                    temps = [[NSMutableArray alloc] init];
                    [sortTemp addObject:temps];
                    PeriodType periodType = [self getPeriodWithDate:date];
                    temperature.period_type = periodType;
                    [temps addObject:temperature];
                    tempDate = date;
                    tempType = periodType;
                }
            }
        }else{
            [sortTemp addObject:temps];
            PeriodType periodType = [self getPeriodWithDate:date];
            temperature.period_type = periodType;
            [temps addObject:temperature];
            tempDate = date;
            tempType = periodType;
        }
    }
    if (result) {
        result(sortTemp);
    }
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
@end
