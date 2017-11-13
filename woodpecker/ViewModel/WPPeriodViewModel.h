//
//  WPPeriodViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "WPPeriodModel.h"

@interface WPPeriodViewModel : NSObject
- (void)updateUserinfo:(WPUserModel *)userinfo reuslt:(void (^)(BOOL success))result;
- (void)registerProfile:(WPProfileModel *)profile reuslt:(void (^)(NSString *profile_id))result;
- (void)updateProfile:(WPProfileModel *)profile lastperiod:(WPPeriodModel *)lastperiod reuslt:(void (^)(BOOL success))result;
- (WPPeriodModel *)getLastPeriod;
@end
