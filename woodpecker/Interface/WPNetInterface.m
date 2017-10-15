//
//  WPNetInterface.m
//  woodpecker
//
//  Created by QiWL on 2017/10/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPNetInterface.h"
#import "WPTemperatureModel.h"
#import "NSDate+ext.h"
#import "NSDate+Extension.h"

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
            NSDictionary *userDic = [data objectForKey:@"user"];
            if (success) {
                success(userDic);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)getProfileWithId:(NSString*)profile_id success:(void (^)(NSDictionary* profileDic))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (profile_id) {
        [params setObject:profile_id forKey:@"profile_id"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:PROFILE_GET requestParams:params networkMethod:GET callback:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *profileDic = [data objectForKey:@"profile"];
            if (success) {
                success(profileDic);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)getDeviceWithId:(NSString*)device_id success:(void (^)(NSDictionary* deviceDic))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (device_id) {
        [params setObject:device_id forKey:@"device_id"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:DEVICE_GET requestParams:params networkMethod:GET callback:^(id data, NSError *error) {
        if (!error) {
            NSDictionary *deviceDic = [data objectForKey:@"device"];
            if (success) {
                success(deviceDic);
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

+ (void)registerDevice:(NSString*)mac_addr num:(NSString*)model_num software_rev:(NSString*)software_rev hardware_rev:(NSString *)hardware_rev success:(void (^)(NSString* device_id))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (mac_addr) {
        [params setObject:mac_addr forKey:@"mac_addr"];
    }
    if (model_num) {
        [params setObject:model_num forKey:@"model_num"];
    }
    if (software_rev) {
        [params setObject:software_rev forKey:@"software_rev"];
    }
    if (hardware_rev) {
        [params setObject:hardware_rev forKey:@"hardware_rev"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:DEVICE_REGISTER requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            NSString *device_id = [NSString stringWithFormat:@"%@",[data objectForKey:@"device_id"]];
            if (success) {
                success(device_id);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)bindDevice:(NSString*)user_id device_id:(NSString*)device_id start_dindex:(NSString*)start_dindex success:(void (^)(BOOL bind))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (device_id) {
        [params setObject:device_id forKey:@"device_id"];
    }
    if (start_dindex) {
        [params setObject:start_dindex forKey:@"start_dindex"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:BINGDING_BIND requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
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

+ (void)unbindDevice:(NSString*)user_id success:(void (^)(BOOL unbind))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:BINGDING_UNBIND requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
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

+ (void)postTemps:(NSArray*)temps user_id:(NSString *)user_id success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableArray *temperatures = [[NSMutableArray alloc] init];
    for (WPTemperatureModel *temp in temps) {
        WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
        [temperature loadDataFromkeyValues:[temp transToDictionary]];
        NSDate *date = [NSDate dateWithTimeIntervalSince2000:[temperature.time integerValue]];
        temperature.time = [NSDate UTCStringFromDate:date format:@"yyyy MM dd HH:mm:ss"];
        [temperatures addObject:temperature];
    }
    [params setObject:[WPTemperatureModel mj_keyValuesArrayWithObjectArray:temperatures ignoredKeys:@[ @"sync", @"pid" ]] forKey:@"temperatures"];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:TEMPERATURE_POST requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
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

+ (void)postEvents:(NSArray *)eventsStr user_id:(NSString*)user_id  success:(void (^)(NSArray *events))success failure:(void (^)(NSError* error))failure{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (eventsStr) {
        [params setObject:eventsStr forKey:@"events"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:EVENT_POST requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            NSArray *events = [data objectForKey:@"events"];
            if (success) {
                success(events);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)updateEvent:(NSString *)event_id user_id:(NSString*)user_id description:(NSString *)description extra_data:(NSString *)extra_data success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (event_id) {
        [params setObject:event_id forKey:@"event_id"];
    }
    if (description) {
        [params setObject:description forKey:@"description"];
    }
    if (extra_data) {
        [params setObject:extra_data forKey:@"extra_data"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:EVENT_UPDATE requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
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

+ (void)getTemperaturesWithUserId:(NSString*)user_id startTime:(NSString *)start_update_time end_update_time:(NSString *)end_update_time success:(void (^)(NSArray* temperatures))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (start_update_time) {
        [params setObject:start_update_time forKey:@"start_update_time"];
    }
    if (end_update_time) {
        [params setObject:end_update_time forKey:@"end_update_time"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:TEMPERATURE_GET requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            NSArray *temperatures = [data objectForKey:@"temperatures"];
            if (success) {
                success(temperatures);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)updateTemperatureWithUserId:(NSString*)user_id gindex:(NSString *)gindex temp:(NSString *)temp success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    if (gindex) {
        [params setObject:gindex forKey:@"gindex"];
    }
    if (temp) {
        [params setObject:temp forKey:@"temp"];
    }
    [[XJFNetworkManager shareManager] requestWithPath:TEMPERATURE_UPDATE requestParams:params networkMethod:POST callback:^(id data, NSError *error) {
        if (!error) {
            NSArray *temperatures = [data objectForKey:@"temperatures"];
            if (success) {
                success(temperatures);
            }
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)uploadAvatar:(UIImage *)vavtar user_id:(NSString *)user_id success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (user_id) {
        [params setObject:user_id forKey:@"user_id"];
    }
    NSData *data  = UIImageJPEGRepresentation(vavtar, 1.0);
    [[XJFNetworkManager shareManager] requestWithMethod:POST url:AVATAR_POST parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",[NSString leie_UUID]] mimeType:@"image/jpeg"];

    } progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
