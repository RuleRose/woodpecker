//
//  WPNetInterface.h
//  woodpecker
//
//  Created by QiWL on 2017/10/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProfileModel.h"
#import "WPPeriodModel.h"

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


+ (void)postEvents:(NSArray *)eventsStr user_id:(NSString*)user_id  success:(void (^)(NSArray *events))success failure:(void (^)(NSError* error))failure;

+ (void)updateEvent:(NSString *)event_id user_id:(NSString*)user_id description:(NSString *)description extra_data:(NSString *)extra_data success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure;

+ (void)getTemperaturesWithUserId:(NSString*)user_id startTime:(NSString *)start_update_time end_update_time:(NSString *)end_update_time success:(void (^)(NSArray* temperatures))success failure:(void (^)(NSError* error))failure;

+ (void)updateTemperatureWithUserId:(NSString*)user_id gindex:(NSString *)gindex temp:(NSString *)temp success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure;

+ (void)uploadAvatar:(UIImage *)vavtar user_id:(NSString *)user_id success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure;


+ (void)postPeriod:(NSString *)user_id period_start:(NSString*)period_start period_end:(NSString*)period_end  success:(void (^)(NSString *period_id))success failure:(void (^)(NSError* error))failure;
+ (void)updatePeriod:(NSString *)period_id period_start:(NSString*)period_start period_end:(NSString*)period_end  success:(void (^)(NSString *period_id))success failure:(void (^)(NSError* error))failure;
+ (void)deletePeriod:(NSString *)period_id success:(void (^)(BOOL finished))success failure:(void (^)(NSError* error))failure;

+ (void)getPeriod:(NSString *)period_id start_update_time:(NSString*)start_update_time end_update_time:(NSString*)end_update_time  success:(void (^)(NSArray *periods))success failure:(void (^)(NSError* error))failure;

@end
