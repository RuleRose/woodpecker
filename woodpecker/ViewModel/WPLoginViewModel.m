//
//  WPLoginViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginViewModel.h"
#import "WPAccountManager.h"

@implementation WPLoginViewModel
- (void)login{
    [[WPAccountManager defaultInstance] login];
}

+ (void)registerWithAccountID:(NSString*)account_id type:(NSString*)account_type nickname:(NSString*)nikename avatar:(NSString *)avatar success:(void (^)(NSString* user_id))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (account_id) {
        [params setObject:account_id forKey:@"account_id"];
    }
    if (account_type) {
        [params setObject:account_type forKey:@"account_type"];
    }
    if (nikename) {
        [params setObject:nikename forKey:@"account_nickname"];
    }
    if (avatar) {
        [params setObject:avatar forKey:@"account_avatar"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:@"user/register/" requestParams:params networkMethod:POST autoShowError:YES callback:^(id data, NSError *error) {
        
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
