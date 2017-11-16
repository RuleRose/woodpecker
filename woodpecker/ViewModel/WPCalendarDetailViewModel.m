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
#import "WPEventItemModel.h"
#import "NSString+JSON.h"

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
    }
    return self;
}

- (NSInteger)eventCountAtDate:(NSDate *)date withDayInfor:(WPDayInfoInPeriod *)dayInfo{
    WPEventItemModel *event =[[WPEventItemModel alloc] init];
    event.date = [NSDate stringFromDate:date format:DATE_FORMATE_STRING];
    NSArray *events = [XJFDBManager searchModelsWithCondition:event andpage:-1 andOrderby:nil isAscend:YES];
    NSInteger count = 0;
    if (dayInfo.type == kPeriodTypeOfMenstrual) {
        if ((!dayInfo.isForecast && dayInfo.isStart) || (!dayInfo.isEndDayForecast && dayInfo.isEnd)) {
            count ++;
        }
    }
    for (WPEventItemModel *item in events) {
        if (dayInfo.type != kPeriodTypeOfMenstrual) {
            if ([item.type isEqualToString:@"1"]
                || [item.type isEqualToString:@"2"]) {
                continue;
            }
        }
        NSDictionary *breifDic =[NSString getDictionary:item.brief];
        for (NSString *value in breifDic.allValues) {
            if (![NSString leie_isBlankString:value]) {
                count ++;
            }
        }
    }
    return count;
}

- (WPTemperatureModel *)getTempWithDate:(NSDate *)date{
    if (date) {
        WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
        temperature.date = [NSDate stringFromDate:date format:DATE_FORMATE_STRING];
        NSArray *tempsArr = [XJFDBManager searchModelsWithCondition:temperature andpage:-1 andOrderby:@"time" isAscend:NO];
        return tempsArr.firstObject;
    }
    return nil;
}
@end
