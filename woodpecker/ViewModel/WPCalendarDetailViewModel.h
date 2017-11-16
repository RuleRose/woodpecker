//
//  WPCalendarDetailViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "WPTemperatureModel.h"
#import "WPDayInfoInPeriod.h"

@interface WPCalendarDetailViewModel : NSObject
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;

- (NSInteger)eventCountAtDate:(NSDate *)date withDayInfor:(WPDayInfoInPeriod *)dayInfo;
- (WPTemperatureModel *)getTempWithDate:(NSDate *)date;
@end
