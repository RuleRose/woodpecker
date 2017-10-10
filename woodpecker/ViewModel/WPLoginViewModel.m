//
//  WPLoginViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginViewModel.h"
#import "WPAccountManager.h"
#import "WPLoginInterface.h"

@implementation WPLoginViewModel
- (void)login{
    [[WPAccountManager defaultInstance] login];
}

- (void)registerAccount:(void (^)(BOOL success))result{
    [WPLoginInterface registerWithAccountID:kDefaultValueForKey(USER_DEFAULT_ACCOUNT_USER_ID) type:@"M" nickname:kDefaultValueForKey(USER_DEFAULT_ACCOUNT_USER_NICKNAME) avatar:kDefaultValueForKey(USER_DEFAULT_ACCOUNT_USER_AVATAR) success:^(NSString *user_id) {
        if (![NSString leie_isBlankString:user_id]) {
            kDefaultSetValueForKey(user_id, USER_DEFAULT_USER_ID);
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
