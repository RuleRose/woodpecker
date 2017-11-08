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

@interface WPCalendarDetailViewModel : NSObject
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;
@property(nonatomic, strong)NSMutableDictionary *periodDic;

- (NSInteger)eventCountAtDate:(NSDate *)date;
- (WPTemperatureModel *)getTempWithDate:(NSDate *)date;
@end
