//
//  WPLoginViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginViewModel.h"
#import "WPAccountManager.h"
#import "WPNetInterface.h"
#import "WPEventModel.h"
#import "NSDate+Extension.h"

@implementation WPLoginViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _user_id = kDefaultObjectForKey(USER_DEFAULT_USER_ID);
        NSDictionary *userDic = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER);
        if (userDic) {
            _user = [[WPUserModel alloc] init];
            [_user loadDataFromkeyValues:userDic];
        }
    }
    return self;
}

- (void)login{
    [[WPAccountManager defaultInstance] login];
}

- (void)registerAccount:(void (^)(BOOL success))result{
    [WPNetInterface registerWithAccountID:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_ID) type:@"M" nickname:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_NICKNAME) avatar:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_AVATAR) success:^(NSString *user_id) {
        _user_id = user_id;
        if (![NSString leie_isBlankString:user_id]) {
            kDefaultSetObjectForKey(user_id, USER_DEFAULT_USER_ID);
            if (result) {
                result(YES);
            }
        }else{
            if (result) {
                result(NO);
            }
        }
    } failure:^(NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}

- (void)getAccount:(void (^)(WPUserModel *user))result{
    [WPNetInterface getUserinfoWithUserId:_user_id password:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_TOKEN) success:^(NSDictionary* userDic) {
        if (userDic) {
            kDefaultSetObjectForKey(userDic, USER_DEFAULT_ACCOUNT_USER);
            _user = [[WPUserModel alloc] init];
            [_user loadDataFromkeyValues:userDic];
        }else{
            _user = nil;
            kDefaultRemoveForKey(USER_DEFAULT_ACCOUNT_USER);
        }
        if (result) {
            result(_user);
        }
    } failure:^(NSError *error) {
        if (result) {
            result(_user);
        }
    }];
}

- (void)getProfile:(NSString *)profile_id success:(void (^)(WPProfileModel *profile))result{
    [WPNetInterface getProfileWithId:profile_id success:^(NSDictionary *profileDic) {
        WPProfileModel *profile = nil;
        if (profileDic) {
            kDefaultSetObjectForKey(profileDic, USER_DEFAULT_PROFILE);
            profile = [[WPProfileModel alloc] init];
            [profile loadDataFromkeyValues:profileDic];
            WPEventModel *event = [[WPEventModel alloc] init];
            event.date = profile.lastperiod ;
            event.pid = event.date;
            [event insertOrupdateToDBDependsOn:nil];
        }else{
            kDefaultRemoveForKey(USER_DEFAULT_PROFILE);
        }
        if (result) {
            result(profile);
        }
    } failure:^(NSError *error) {
        if (result) {
            result(nil);
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
