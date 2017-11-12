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
#import "NSDate+Extension.h"
#import "NSDate+ext.h"
#import "WPPeriodModel.h"
#import "WPPeriodCountManager.h"

@interface WPTemperatureViewModel ()

@property(nonatomic, strong)NSArray *startEvents;
@property(nonatomic, strong)NSArray *endEvents;
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;
//@property (nonatomic,strong)NSMutableArray *periods;

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
//        _periods = [self getPeriods];
    }
    return self;
}

- (void)getTempsBlock:(void (^)(NSMutableArray *sortTemps))result{
    WPTemperatureModel *searchTemp = [[WPTemperatureModel alloc] init];
    NSArray *temperatures = [XJFDBManager searchModelsWithCondition:searchTemp andpage:-1 andOrderby:@"time" isAscend:NO];
    NSDate *tempDate;
    PeriodType tempType = kPeriodTypeOfSafe;
    WPTemperatureModel *temp;
    NSMutableArray *sortTemp = [[NSMutableArray alloc] init];
    NSMutableArray *temps = [[NSMutableArray alloc] init];
    for (WPTemperatureModel *temperature in temperatures) {
        NSDate *date = [NSDate dateFromString:temperature.date format:DATE_FORMATE_STRING];
        if (tempDate) {
            //判断两个日期是否是同一天
            if (![NSDate isDate:date equalToDate:tempDate toCalendarUnit:NSCalendarUnitDay]) {
             //不是同一天判断是否连续
                NSInteger days = [NSDate daysFromDate:date toDate:tempDate];
                if (days <= 1 && days >= -1) {
                    //连续
                    //判断两天是否在同一个期间
                    WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:date];
                    temperature.period_type = period.type;
                    if (tempType == period.type) {
                        [temps addObject:temperature];
                        tempDate = date;
                        tempType = period.type;
                        temp = temperature;
                    }else{
                        temps = [[NSMutableArray alloc] init];
                        [temps addObject:temp];
                        [temps addObject:temperature];
                        [sortTemp addObject:temps];
                        tempDate = date;
                        tempType = period.type;
                        temp = temperature;
                    }
                }else{
                    temps = [[NSMutableArray alloc] init];
                    [sortTemp addObject:temps];
                    WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:date];
                    temperature.period_type =  period.type;
                    [temps addObject:temperature];
                    tempDate = date;
                    tempType =  period.type;
                    temp = temperature;
                }
            }
        }else{
            [sortTemp addObject:temps];
            WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:date];
            temperature.period_type = period.type;
            [temps addObject:temperature];
            tempDate = date;
            tempType =  period.type;
            temp = temperature;
        }
    }
    if (result) {
        result(sortTemp);
    }
}
@end
