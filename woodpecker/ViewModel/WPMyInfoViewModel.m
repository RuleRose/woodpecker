//
//  WPMyInfoViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMyInfoViewModel.h"
#import "WPNetInterface.h"
#import "WPUserModel.h"

@implementation WPMyInfoViewModel
- (void)uploadAvatar:(UIImage *)avatar success:(void (^)(BOOL finished))result{
    WPUserModel *userinfo = [[WPUserModel alloc] init];
    [userinfo loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    [WPNetInterface uploadAvatar:avatar user_id:userinfo.user_id success:^(BOOL finished) {
        if (result) {
            result(YES);
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
