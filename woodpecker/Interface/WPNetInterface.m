//
//  WPNetInterface.m
//  woodpecker
//
//  Created by QiWL on 2017/10/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPNetInterface.h"

@implementation WPNetInterface
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
    [[XJFNetworkManager shareManager] requestWithPath:USER_REGISTER requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            NSString *user_id = [NSString stringWithFormat:@"%@",[data objectForKey:@"user_id"]];
            if (success) {
                success(user_id);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)getUserinfoWithUserId:(NSString*)user_id password:(NSString *)pwd success:(void (^)(NSDictionary* userDic))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (pwd) {
        [params setObject:pwd forKey:@"password"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:USER_LOGIN requestParams:params networkMethod:GET callback:^(id data, NSError *error) {
        if (!error) {
            if (success) {
                success(data);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)updateUserInfoWithUserID:(NSString*)user_id nickname:(NSString*)nick_name birthday:(NSString*)birthday height:(NSString *)height weight:(NSString *)weight success:(void (^)(BOOL success))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (nick_name) {
        [params setObject:nick_name forKey:@"nick_name"];
    }
    if (birthday) {
        [params setObject:birthday forKey:@"birthday"];
    }
    if (height) {
        [params setObject:height forKey:@"height"];
    }
    if (weight) {
        [params setObject:weight forKey:@"weight"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:USER_UPDATE requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            if (success) {
                success(YES);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)registerProfileWithUserID:(NSString*)user_id menstruation:(NSString*)menstruation period:(NSString*)period lastperiod:(NSString *)lastperiod extra_data:(NSString *)extra_data success:(void (^)(NSString *profile_id))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (menstruation) {
        [params setObject:[NSNumber numberWithInteger:[menstruation integerValue]] forKey:@"menstruation"];
    }
    if (period) {
        [params setObject:[NSNumber numberWithInteger:[period integerValue]] forKey:@"period"];
    }
    if (lastperiod) {
        [params setObject:lastperiod forKey:@"lastperiod"];
    }
    if (extra_data) {
        [params setObject:extra_data forKey:@"extra_data"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:PROFILE_REGISTER requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            NSString *profile_id = [NSString stringWithFormat:@"%@",[data objectForKey:@"profile_id"]];
            if (success) {
                success(profile_id);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)updateProfileWithProfileID:(NSString*)profile_id menstruation:(NSString*)menstruation period:(NSString*)period lastperiod:(NSString *)lastperiod extra_data:(NSString *)extra_data success:(void (^)(BOOL success))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (profile_id) {
        [params setObject:profile_id forKey:@"profile_id"];
    }
    if (menstruation) {
        [params setObject:[NSNumber numberWithInteger:[menstruation integerValue]] forKey:@"menstruation"];
    }
    if (period) {
        [params setObject:[NSNumber numberWithInteger:[period integerValue]] forKey:@"period"];
    }
    if (lastperiod) {
        [params setObject:lastperiod forKey:@"lastperiod"];
    }
    if (extra_data) {
        [params setObject:extra_data forKey:@"extra_data"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:PROFILE_UPDATE requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            if (success) {
                success(YES);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}
@end
