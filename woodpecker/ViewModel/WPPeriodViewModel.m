//
//  WPPeriodViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPeriodViewModel.h"
#import "WPNetInterface.h"
#import "WPEventModel.h"
#import "NSDate+Extension.h"

@implementation WPPeriodViewModel
- (void)updateUserinfo:(WPUserModel *)userinfo reuslt:(void (^)(BOOL success))result{
    [WPNetInterface updateUserInfoWithUserID:kDefaultObjectForKey(USER_DEFAULT_USER_ID) nickname:userinfo.nick_name birthday:userinfo.birthday height:userinfo.height weight:userinfo.weight success:^(BOOL success) {
        if (result) {
            result(success);
        }
    } failure:^(NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)registerProfile:(WPProfileModel *)profile reuslt:(void (^)(BOOL success))result{
    [WPNetInterface registerProfileWithUserID:kDefaultObjectForKey(USER_DEFAULT_USER_ID) menstruation:profile.menstruation period:profile.period lastperiod:profile.lastperiod extra_data:profile.extra_data success:^(NSString *profile_id) {
        profile.profile_id = profile_id;
        kDefaultSetObjectForKey([profile transToDictionary], USER_DEFAULT_PROFILE);
        WPEventModel *event = [[WPEventModel alloc] init];
        event.date = profile.lastperiod;
        event.pid = event.date;
        [event insertOrupdateToDBDependsOn:nil];
        if (result) {
            result(YES);
        }
    } failure:^(NSError *error) {
        result(NO);
    }];
}

- (void)updateProfile:(WPProfileModel *)profile reuslt:(void (^)(BOOL success))result{
    [WPNetInterface updateProfileWithProfileID:profile.pid menstruation:profile.menstruation period:profile.period lastperiod:profile.lastperiod extra_data:profile.extra_data success:^(BOOL success) {
        kDefaultSetObjectForKey([profile transToDictionary], USER_DEFAULT_PROFILE);
        if (result) {
            result(YES);
        }
    } failure:^(NSError *error) {
        result(NO);
    }];
}
@end
