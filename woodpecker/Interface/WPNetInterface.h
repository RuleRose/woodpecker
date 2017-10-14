//
//  WPNetInterface.h
//  woodpecker
//
//  Created by QiWL on 2017/10/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNetInterface : NSObject
+ (void)registerWithAccountID:(NSString*)account_id type:(NSString*)account_type nickname:(NSString*)nikename avatar:(NSString *)avatar success:(void (^)(NSString* user_id))success failure:(void (^)(NSError* error))failure;
+ (void)getUserinfoWithUserId:(NSString*)user_id password:(NSString *)pwd success:(void (^)(NSDictionary* userDic))success failure:(void (^)(NSError* error))failure;
+ (void)getProfileWithId:(NSString*)profile_id success:(void (^)(NSDictionary* profileDic))success failure:(void (^)(NSError* error))failure;
+ (void)getDeviceWithId:(NSString*)device_id success:(void (^)(NSDictionary* deviceDic))success failure:(void (^)(NSError* error))failure;

+ (void)updateUserInfoWithUserID:(NSString*)user_id nickname:(NSString*)nick_name birthday:(NSString*)birthday height:(NSString *)height weight:(NSString *)weight success:(void (^)(BOOL success))success failure:(void (^)(NSError* error))failure;

+ (void)registerProfileWithUserID:(NSString*)user_id menstruation:(NSString*)menstruation period:(NSString*)period lastperiod:(NSString *)lastperiod extra_data:(NSString *)extra_data success:(void (^)(NSString *profile_id))success failure:(void (^)(NSError* error))failure;
+ (void)updateProfileWithProfileID:(NSString*)profile_id menstruation:(NSString*)menstruation period:(NSString*)period lastperiod:(NSString *)lastperiod extra_data:(NSString *)extra_data success:(void (^)(BOOL success))success failure:(void (^)(NSError* error))failure;

+ (void)registerDevice:(NSString*)mac_addr num:(NSString*)model_num software_rev:(NSString*)software_rev hardware_rev:(NSString *)hardware_rev success:(void (^)(NSString* device_id))success failure:(void (^)(NSError* error))failure;

+ (void)bindDevice:(NSString*)user_id device_id:(NSString*)device_id start_dindex:(NSString*)start_dindex success:(void (^)(BOOL bind))success failure:(void (^)(NSError* error))failure;
+ (void)unbindDevice:(NSString*)user_id success:(void (^)(BOOL unbind))success failure:(void (^)(NSError* error))failure;

+ (void)postTemps:(NSArray*)temps user_id:(NSString *)user_id success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure;

@end
