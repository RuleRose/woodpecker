//
//  WPLoginInterface.m
//  woodpecker
//
//  Created by QiWL on 2017/10/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginInterface.h"

@implementation WPLoginInterface
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
@end
