//
//  WPPeriodCountManager.m
//  woodpecker
//
//  Created by yongche on 17/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPeriodCountManager.h"
#import "WPProfileModel.h"
#import "WPPeriodModel.h"

#define PRE_PERIOD_START 7
#define POST_MENSTRUATION_END 4
#define OVULATE_DAY 14
#define PRE_OVULATE_START 5
#define POST_OVULATE_START 4
@interface WPPeriodCountManager()
@property (nonatomic,strong) NSMutableArray<WPPeriodCountModel *> *periodList;
@property (nonatomic,assign) NSInteger menstruation;
@property (nonatomic,assign) NSInteger period;
@end

@implementation WPPeriodCountManager
Singleton_Implementation(WPPeriodCountManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        WPProfileModel *profile = [[WPProfileModel alloc] init];
        [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
        self.menstruation = [profile.menstruation integerValue];
        self.period = [profile.period integerValue];
        self.periodList = [NSMutableArray array];
        
        [self recountPeriod];
    }
    return self;
}

-(void)recountPeriod{
    [self.periodList removeAllObjects];
    WPPeriodModel *periodModel = [[WPPeriodModel alloc] init];
    NSArray *rawPeriodList = [NSArray arrayWithArray:[XJFDBManager searchModelsWithCondition:periodModel andpage:-1 andOrderby:@"period_start" isAscend:YES]];
    
    //生产所有的period的start和end，标注是否是预测。
    for (NSInteger i = 0; i < rawPeriodList.count; i++) {
        WPPeriodCountModel *periodCountMode = [[WPPeriodCountModel alloc] init];
        WPPeriodModel * periodMode = [rawPeriodList objectAtIndex:i];
        periodCountMode.brief = periodMode.brief;
        periodCountMode.extra_data = periodMode.extra_data;
        periodCountMode.period_id = periodMode.period_id;
        periodCountMode.lastupdate = periodMode.lastupdate;
        periodCountMode.removed = periodMode.removed;
        NSDate *nextPeriodStartDate = nil;
        if (i < (rawPeriodList.count - 1)) {
            WPPeriodModel * nextPeriodMode = [rawPeriodList objectAtIndex:(i + 1)];
            nextPeriodStartDate = [NSDate dateFromString:nextPeriodMode.period_start format:DATE_FORMATE_STRING];
        }
        
        periodCountMode.period_start = [NSDate dateFromString:periodMode.period_start format:DATE_FORMATE_STRING];
        periodCountMode.isForecast = NO;
        periodCountMode.isEndDayForecast = YES;
        if (![NSString leie_isBlankString:periodModel.period_end]) {
            //用户输入了结束日期，直接记录
            periodCountMode.period_end = [NSDate dateFromString:periodMode.period_end format:DATE_FORMATE_STRING];
            periodCountMode.isEndDayForecast = NO;
        } else {
            if (nextPeriodStartDate) {
                NSInteger timeGap = [NSDate daysFromDate:periodCountMode.period_start toDate:nextPeriodStartDate];
                if (timeGap > self.menstruation) {
                    //间隔大于用户输入的周期，设置到周期最后一天
                    periodCountMode.period_end = [NSDate dateByAddingDays:self.menstruation toDate:periodCountMode.period_start];
                } else {
                    //间隔小于等于用户输入的周期，设置到下次开始的前一天
                    periodCountMode.period_end = [NSDate dateByAddingDays:-1 toDate:nextPeriodStartDate];
                }
            }else{
                periodCountMode.isForecast = NO;
                periodCountMode.period_end = [NSDate dateByAddingDays:self.menstruation toDate:periodCountMode.period_start];
            }
        }
        [self.periodList addObject:periodCountMode];
        
        NSDate *nextPreiodStartDateLimit = nil;//下次月经前7天
        if (nextPeriodStartDate) {
            nextPreiodStartDateLimit = [NSDate dateByAddingDays:-PRE_PERIOD_START toDate:nextPeriodStartDate];
        }
        
        //循环查找预测周期
        while (nextPreiodStartDateLimit && periodCountMode.period_start) {
            NSDate *nextForecastDate = [NSDate dateByAddingDays:self.period toDate:periodCountMode.period_start];
            NSDate *nextForecastDateEnd = [NSDate dateByAddingDays:self.menstruation toDate:nextForecastDate];
            if ([NSDate isDate:nextPreiodStartDateLimit afterToDate:nextForecastDateEnd toCalendarUnit:NSCalendarUnitDay]) {
                //预测的周期结束日期，在下次用户设置的开始日期的前7天之前，那么预测周期有效，添加
                periodCountMode = [[WPPeriodCountModel alloc] init];
                periodCountMode.period_start = nextForecastDate;
                periodCountMode.period_end = nextForecastDateEnd;
                periodCountMode.isForecast = YES;
                periodCountMode.isEndDayForecast = YES;
                [self.periodList addObject:periodCountMode];
            }else{
                //如果超过下次用户设置的开始日期的前七天，跳出
                break;
            }
        }
    }
    //如果最后一个周期小于今天，添加一个预测周期
    WPPeriodCountModel *lastPeriod = [self.periodList lastObject];
    if (lastPeriod && lastPeriod.period_start) {
        while (1) {
            if ([NSDate isDateAfterToday:lastPeriod.period_start]) {
                //如果最后的周期大于今日，说明已经添加了预测周期，跳出
                break;
            }else{
                WPPeriodCountModel *newPeriod = [[WPPeriodCountModel alloc] init];
                newPeriod.period_start = [NSDate dateByAddingDays:self.period toDate:lastPeriod.period_start];
                newPeriod.period_end = [NSDate dateByAddingDays:self.menstruation toDate:newPeriod.period_start];
                newPeriod.isForecast = YES;
                newPeriod.isEndDayForecast = YES;
                [self.periodList addObject:newPeriod];
                lastPeriod = newPeriod;
            }
        }
    }
    
    //计算周期的排暖日，安全期的起始日期。
    for (NSInteger i = 0; i < self.periodList.count; i++) {
        WPPeriodCountModel *currentPeriod = [self.periodList objectAtIndex:i];
        WPPeriodCountModel *nextPeriod = nil;
        if (i < (self.periodList.count - 1)) {
            nextPeriod = [self.periodList objectAtIndex:(i + 1)];
        }
        
        if (nextPeriod) {
            //如果存在下一个周期，根据下一个周期推算排卵日，安全期
            NSDate *rawOvulateDay = [NSDate dateByAddingDays:-OVULATE_DAY toDate:nextPeriod.period_start];
            NSDate *rawOvulateStartDay = [NSDate dateByAddingDays:-PRE_OVULATE_START toDate:rawOvulateDay];
            NSDate *rawOvulateEndDay = [NSDate dateByAddingDays:POST_OVULATE_START toDate:rawOvulateDay];
            
            //如果上述三个日子，比经期结束还早，那就安经期计算
            if ([NSDate isDate:rawOvulateStartDay afterToDate:currentPeriod.period_end toCalendarUnit:NSCalendarUnitDay]) {
                //没有重叠，正常易孕期
                currentPeriod.pregnant_start = rawOvulateStartDay;
                currentPeriod.pregnant_end = rawOvulateEndDay;
                currentPeriod.ovulate_day = rawOvulateDay;
            }else if ([NSDate isDate:rawOvulateDay afterToDate:currentPeriod.period_end toCalendarUnit:NSCalendarUnitDay]){
                //开始时间和经期结束时间重叠，经期优先级高，经期后一天开始直接是易孕期
                currentPeriod.pregnant_start = [NSDate dateByAddingDays:1 toDate:currentPeriod.period_end];
                currentPeriod.pregnant_end = rawOvulateEndDay;
                currentPeriod.ovulate_day = rawOvulateDay;
            }else if ([NSDate isDate:rawOvulateEndDay afterToDate:currentPeriod.period_end toCalendarUnit:NSCalendarUnitDay]){
                //排卵期在经期，经期优先级高，没有排暖日，经期结束后一天开始是易孕期
                currentPeriod.pregnant_start = [NSDate dateByAddingDays:1 toDate:currentPeriod.period_end];
                currentPeriod.pregnant_end = rawOvulateEndDay;
                currentPeriod.ovulate_day = nil;
            }else{
                //整个易孕期跟经期重叠没有易孕期
                currentPeriod.pregnant_start = nil;
                currentPeriod.pregnant_end = nil;
                currentPeriod.ovulate_day = nil;
            }
        }else{
            break;
        }
    }
    
    //计算最后一个周期的排卵日，安全期
    lastPeriod = [self.periodList lastObject];
    NSDate *nextForecastPeriodStart = [NSDate dateByAddingDays:self.period toDate:lastPeriod.period_start];
    lastPeriod.ovulate_day = [NSDate dateByAddingDays:-OVULATE_DAY toDate:nextForecastPeriodStart];
    lastPeriod.pregnant_start = [NSDate dateByAddingDays:-PRE_OVULATE_START toDate:lastPeriod.ovulate_day];
    lastPeriod.pregnant_end = [NSDate dateByAddingDays:POST_OVULATE_START toDate:lastPeriod.ovulate_day];
}

-(WPDayInfoInPeriod *)dayInfo:(NSDate*)day{
    WPDayInfoInPeriod *dayInfo = [[WPDayInfoInPeriod alloc] init];
    dayInfo.isValide = YES;
    dayInfo.isMenstruationSwitchOffValide = NO;
    dayInfo.type = kPeriodTypeOfSafe;
    dayInfo.isStart = NO;
    dayInfo.isEnd = NO;

    WPPeriodCountModel *destPeriod = [self getCurrentPeriodInfo:day];
    if (!destPeriod) {
        //没找到目标周期
        dayInfo.isValide = NO;
        return dayInfo;
    }
    
    dayInfo.dayInPeriod = [NSDate daysFromDate:destPeriod.period_start toDate:day] + 1;
    dayInfo.isForecast = destPeriod.isForecast;
    dayInfo.isEndDayForecast = destPeriod.isEndDayForecast;
    if ([NSDate isDate:destPeriod.period_start equalToDate:day toCalendarUnit:NSCalendarUnitDay]) {
        //经期开始日
        if (destPeriod.isForecast) {
//            dayInfo.type = kPeriodTypeOfForecastStart;
            dayInfo.isStart = YES;
            dayInfo.type = kPeriodTypeOfForecast;
        } else {
//            dayInfo.type = kPeriodTypeOfMenstrualStart;
            dayInfo.type = kPeriodTypeOfMenstrual;
            dayInfo.isStart = YES;
        }
        if (destPeriod.pregnant_start) {
            NSInteger dayBefore = [NSDate daysFromDate:day toDate:destPeriod.pregnant_start];
            if (dayBefore > 0) {
                dayInfo.dayBeforePregnantPeriod = dayBefore;
            } else {
                dayInfo.dayBeforePregnantPeriod = 0;
            }
        } else {
            dayInfo.dayBeforePregnantPeriod = 0;
        }
    } else if ([NSDate isDate:destPeriod.period_end equalToDate:day toCalendarUnit:NSCalendarUnitDay]){
        //经期结束日
        if (destPeriod.isForecast) {
//            dayInfo.type = kPeriodTypeOfForecastEnd;
            dayInfo.type = kPeriodTypeOfForecast;
            dayInfo.isEnd = YES;

        } else {
//            dayInfo.type = kPeriodTypeOfMenstrualEnd;
            dayInfo.type = kPeriodTypeOfMenstrual;
            dayInfo.isEnd = YES;
        }
        if (destPeriod.pregnant_start) {
            NSInteger dayBefore = [NSDate daysFromDate:day toDate:destPeriod.pregnant_start];
            if (dayBefore > 0) {
                dayInfo.dayBeforePregnantPeriod = dayBefore;
            } else {
                dayInfo.dayBeforePregnantPeriod = 0;
            }
        } else {
            dayInfo.dayBeforePregnantPeriod = 0;
        }
    } else if ([NSDate isDate:destPeriod.period_end afterToDate:day toCalendarUnit:NSCalendarUnitDay] && [NSDate isDate:day afterToDate:destPeriod.period_start toCalendarUnit:NSCalendarUnitDay]){
        //经期中
        if (destPeriod.isForecast) {
            dayInfo.type = kPeriodTypeOfForecast;
        } else {
            dayInfo.type = kPeriodTypeOfMenstrual;
        }
        if (destPeriod.pregnant_start) {
            NSInteger dayBefore = [NSDate daysFromDate:day toDate:destPeriod.pregnant_start];
            if (dayBefore > 0) {
                dayInfo.dayBeforePregnantPeriod = dayBefore;
            } else {
                dayInfo.dayBeforePregnantPeriod = 0;
            }
        } else {
            dayInfo.dayBeforePregnantPeriod = 0;
        }
    } else if (destPeriod.ovulate_day && [NSDate isDate:destPeriod.ovulate_day equalToDate:day toCalendarUnit:NSCalendarUnitDay]) {
        //排卵日
        dayInfo.type = kPeriodTypeOfOviposit;
        dayInfo.dayBeforePregnantPeriod = 0;
    } else if (destPeriod.pregnant_start && [NSDate isDate:destPeriod.pregnant_start equalToDate:day toCalendarUnit:NSCalendarUnitDay]){
        //易孕期开始日
//        dayInfo.type = kPeriodTypeOfPregnancyStart;
        dayInfo.type = kPeriodTypeOfPregnancy;
        dayInfo.isStart = YES;
        dayInfo.dayBeforePregnantPeriod = 0;
    } else if (destPeriod.pregnant_end && [NSDate isDate:destPeriod.pregnant_end equalToDate:day toCalendarUnit:NSCalendarUnitDay]){
        //易孕期结束日
//        dayInfo.type = kPeriodTypeOfPregnancyEnd;
        dayInfo.type = kPeriodTypeOfPregnancy;
        dayInfo.isEnd = YES;
        dayInfo.dayBeforePregnantPeriod = 0;
    } else if ([NSDate isDate:destPeriod.pregnant_end afterToDate:day toCalendarUnit:NSCalendarUnitDay] && [NSDate isDate:day afterToDate:destPeriod.pregnant_start toCalendarUnit:NSCalendarUnitDay]){
        //易孕期中
        dayInfo.type = kPeriodTypeOfPregnancy;
        dayInfo.dayBeforePregnantPeriod = 0;
    } else {
        //安全期
        dayInfo.type = kPeriodTypeOfSafe;
        if (destPeriod.pregnant_start) {
            NSInteger dayBefore = [NSDate daysFromDate:day toDate:destPeriod.pregnant_start];
            if (dayBefore > 0) {
                dayInfo.dayBeforePregnantPeriod = dayBefore;
            } else {
                dayInfo.dayBeforePregnantPeriod = 0;
            }
        } else {
            dayInfo.dayBeforePregnantPeriod = 0;
        }
    }
    
    //是否有经期结束开关
    if (NO == destPeriod.isForecast) {
        NSDate *tempDay = [NSDate dateByAddingDays:POST_MENSTRUATION_END toDate:destPeriod.period_end];
        if ([NSDate isDate:day afterToDate:tempDay toCalendarUnit:NSCalendarUnitDay] || [NSDate isDate:day equalToDate:destPeriod.period_start toCalendarUnit:NSCalendarUnitDay]) {
            dayInfo.isMenstruationSwitchOffValide = NO;
        } else {
            dayInfo.isMenstruationSwitchOffValide = YES;
        }
    }
    
    return dayInfo;
}

-(WPPeriodCountModel *)getCurrentPeriodInfo:(NSDate *)day{
    NSInteger index = [self getCurrentPeriodIndex:day];
    if (index >= 0) {
        WPPeriodCountModel *destPeriod = [self.periodList objectAtIndex:index];
        return destPeriod;
    } else {
        return nil;
    }
}

-(WPPeriodCountModel *)getPrePeriodInfo:(NSDate *)day{
    NSInteger index = [self getCurrentPeriodIndex:day];
    if (index > 0) {
        WPPeriodCountModel *destPeriod = [self.periodList objectAtIndex:(index - 1)];
        return destPeriod;
    } else if (index == -3){
        return self.periodList.lastObject;
    }else{
        return nil;
    }
}

-(WPPeriodCountModel *)getNextPeriodInfo:(NSDate *)day{
    NSInteger index = [self getCurrentPeriodIndex:day];
    if (index < (self.periodList.count - 1)) {
        WPPeriodCountModel *destPeriod = [self.periodList objectAtIndex:(index + 1)];
        return destPeriod;
    } else if (index == -2){
        return self.periodList.firstObject;
    }else{
        return nil;
    }
}

- (NSInteger)getCurrentPeriodIndex:(NSDate *)day{
    if ([self.periodList leie_isEmpty]) {
        //如果没有周期信息，全部返回无效
        return  -1;
    }
    
    WPPeriodCountModel *firstPeriod = [self.periodList firstObject];
    if ([NSDate isDate:firstPeriod.period_start afterToDate:day toCalendarUnit:NSCalendarUnitDay]) {
        //日期在所有周期信息之前，不计算
        return  -2;
    }
    
    WPPeriodCountModel *lastPeriod = [self.periodList lastObject];
    if ([NSDate isDate:day afterToDate:[NSDate dateByAddingDays:self.period toDate:lastPeriod.period_start] toCalendarUnit:NSCalendarUnitDay]) {
        //日期在最后一个周期外，不计算
        return -3;
    }
    
    
    NSInteger i = 0;
    for (i = 0; i < self.periodList.count; i++) {
        WPPeriodCountModel *period = [self.periodList objectAtIndex:i];
        if ([NSDate isDate:period.period_start afterToDate:day toCalendarUnit:NSCalendarUnitDay]) {
            break;
        }else{
            continue;
        }
    }

    i--;
    
    return i;
}


@end
