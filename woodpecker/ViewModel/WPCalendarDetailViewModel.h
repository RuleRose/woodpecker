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

@interface WPCalendarDetailViewModel : NSObject
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;
- (PeriodType)getPeriodWithDate:(NSDate *)date;
- (void)getPeriodWithData:(NSDate *)date block:(void (^)(PeriodType period_type,NSInteger period_days,NSInteger pregnancy_days))result;
@end
