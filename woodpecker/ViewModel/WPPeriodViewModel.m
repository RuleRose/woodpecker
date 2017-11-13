//
//  WPPeriodViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPeriodViewModel.h"
#import "WPNetInterface.h"
#import "NSDate+Extension.h"
#import "XJFDBManager.h"

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

- (void)registerProfile:(WPProfileModel *)profile reuslt:(void (^)(NSString *profile_id))result{
    [WPNetInterface registerProfileWithUserID:kDefaultObjectForKey(USER_DEFAULT_USER_ID) menstruation:profile.menstruation period:profile.period lastperiod:profile.lastperiod extra_data:profile.extra_data success:^(NSString *profile_id) {
        //创建首个经期信息
        
        profile.profile_id = profile_id;
        kDefaultSetObjectForKey([profile transToDictionary], USER_DEFAULT_PROFILE);
        WPPeriodModel *period = [[WPPeriodModel alloc] init];
        period.period_start = profile.lastperiod;
        WPUserModel *user = [[WPUserModel alloc] init];
        [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
            for (NSDictionary *periodDic in periods) {
                WPPeriodModel *create_period = [[WPPeriodModel alloc] init];
                [create_period loadDataFromkeyValues:periodDic];
                create_period.pid = create_period.period_id;
                if ([create_period.removed boolValue]) {
                    [XJFDBManager deleteModel:create_period dependOnKeys:nil];
                }else{
                    if (![create_period insertToDB]) {
                        [create_period updateToDBDependsOn:nil];
                    }
                }
            }
            if (result) {
                result(profile_id);
            }
        } failure:^(NSError *error) {
            if (result) {
                result(profile_id);
            }
        }];
    } failure:^(NSError *error) {
        if (result) {
            result(nil);
        }
    }];
}

- (void)updateProfile:(WPProfileModel *)profile lastperiod:(WPPeriodModel *)lastperiod reuslt:(void (^)(BOOL success))result{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (lastperiod) {
        NSDate *local_start_date = [NSDate dateFromString:lastperiod.period_start format:DATE_FORMATE_STRING];
        NSDate *new_date = [NSDate dateFromString:profile.lastperiod format:DATE_FORMATE_STRING];
        if ([NSDate isDate:local_start_date equalToDate:new_date toCalendarUnit:NSCalendarUnitDay]) {
            //不更新经期信息
            [self updateProfile:profile reuslt:result];
        }else if ([NSDate isDate:local_start_date afterToDate:new_date toCalendarUnit:NSCalendarUnitDay]) {
            //设置了之前的日期
            [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_lastperiod")];
            if (result) {
                result(NO);
            }
            return;
        }else{
            [self updateProfile:profile reuslt:^(BOOL success) {
                if (success) {
                    NSInteger days = [NSDate daysFromDate:local_start_date toDate:new_date];
                    NSInteger menstruation = [profile.menstruation integerValue] - 1;
                    if (![NSString leie_isBlankString:lastperiod.period_end]) {
                        NSDate *local_end_date = [NSDate dateFromString:lastperiod.period_end format:DATE_FORMATE_STRING];
                        menstruation = [NSDate daysFromDate:local_start_date toDate:local_end_date];
                    }
                    if (days <= menstruation) {
                        //update
                        lastperiod.period_start = profile.lastperiod;
                        if (days == menstruation) {
                            lastperiod.period_end = @"";
                        }
                        [WPNetInterface updatePeriod:lastperiod.period_id period_start:lastperiod.period_start period_end:lastperiod.period_end success:^(NSArray *periods) {
                            for (NSDictionary *periodDic in periods) {
                                WPPeriodModel *update_period = [[WPPeriodModel alloc] init];
                                [update_period loadDataFromkeyValues:periodDic];
                                update_period.period_end = lastperiod.period_end;
                                update_period.pid = update_period.period_id;
                                if ([update_period.removed boolValue]) {
                                    [XJFDBManager deleteModel:update_period dependOnKeys:nil];
                                }else{
                                    if (![update_period insertToDB]) {
                                        [update_period updateToDBDependsOn:nil];
                                    }
                                }
                            }
                            if (result) {
                                result(YES);
                            }
                        } failure:^(NSError *error) {
                            if (result) {
                                result(NO);
                            }
                        }];
                    }else{
                        //create
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        period.period_start = profile.lastperiod;
                        [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                            for (NSDictionary *periodDic in periods) {
                                WPPeriodModel *create_period = [[WPPeriodModel alloc] init];
                                [create_period loadDataFromkeyValues:periodDic];
                                create_period.pid = create_period.period_id;
                                if ([create_period.removed boolValue]) {
                                    [XJFDBManager deleteModel:create_period dependOnKeys:nil];
                                }else{
                                    if (![create_period insertToDB]) {
                                        [create_period updateToDBDependsOn:nil];
                                    }
                                }
                            }
                            if (result) {
                                result(YES);
                            }
                        } failure:^(NSError *error) {
                            if (result) {
                                result(NO);
                            }
                        }];
                    }
                }else{
                    if (result) {
                        result(NO);
                    }
                }
            }];
        }
    }else{
        [self updateProfile:profile reuslt:^(BOOL success) {
            //create
            if (success) {
                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                period.period_start = profile.lastperiod;
                [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                    for (NSDictionary *periodDic in periods) {
                        WPPeriodModel *create_period = [[WPPeriodModel alloc] init];
                        [create_period loadDataFromkeyValues:periodDic];
                        create_period.pid = create_period.period_id;
                        if ([create_period.removed boolValue]) {
                            [XJFDBManager deleteModel:create_period dependOnKeys:nil];
                        }else{
                            if (![create_period insertToDB]) {
                                [create_period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES);
                    }
                } failure:^(NSError *error) {
                    if (result) {
                        result(NO);
                    }
                }];
            }else{
                if (result) {
                    result(NO);
                }
            }
        }];
    }
}

- (void)updateProfile:(WPProfileModel *)profile reuslt:(void (^)(BOOL success))result{
    [WPNetInterface updateProfileWithProfileID:profile.profile_id menstruation:profile.menstruation period:profile.period lastperiod:profile.lastperiod extra_data:profile.extra_data success:^(BOOL success) {
        kDefaultSetObjectForKey([profile transToDictionary], USER_DEFAULT_PROFILE);
        if (result) {
            result(YES);
        }
    } failure:^(NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}

- (WPPeriodViewModel *)getLastPeriod{
    WPPeriodModel *period = [[WPPeriodModel alloc] init];
    NSArray *results = [NSArray arrayWithArray:[XJFDBManager searchModelsWithCondition:period andpage:-1 andOrderby:@"period_start" isAscend:NO]];
    return results.firstObject;
}
@end
