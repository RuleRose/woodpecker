//
//  WPBasicInfoViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPBasicInfoViewModel.h"
#import "WPNetInterface.h"

@implementation WPBasicInfoViewModel
- (void)updateUserinfo:(WPUserModel *)userinfo reuslt:(void (^)(BOOL success))result{
    [WPNetInterface updateUserInfoWithUserID:userinfo.user_id nickname:userinfo.nick_name birthday:userinfo.birthday height:userinfo.height weight:userinfo.weight success:^(BOOL success) {
        kDefaultSetObjectForKey([userinfo transToDictionary], USER_DEFAULT_ACCOUNT_USER);
        if (result) {
            result(success);
        }
    } failure:^(NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}
@end
