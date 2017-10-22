//
//  MMCMainViewModel.m
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "WPMainViewModel.h"
#import "WPStatusViewController.h"
#import "WPTemperatureViewController.h"
#import "WPMyViewController.h"
#import "WPNetInterface.h"
#import "WPConnectDeviceManager.h"
#import "WPEventModel.h"
#import "NSDate+Extension.h"
#import "WPTemperatureModel.h"
#import "MMCDeviceManager.h"
#import "NSDate+ext.h"

@implementation WPMainViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _controllerList = [NSMutableArray array];
        WPStatusViewController *statusVC = [[WPStatusViewController alloc] init];
        [statusVC.tabBarItem setImage:[[UIImage imageNamed:@"btn-tab-status-u"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [statusVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btn-tab-status-s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_controllerList addObject:statusVC];
        
        WPTemperatureViewController *temperatureRecord = [[WPTemperatureViewController alloc] init];
        [temperatureRecord.tabBarItem setImage:[[UIImage imageNamed:@"btn-tab-curve-u"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [temperatureRecord.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btn-tab-curve-p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_controllerList addObject:temperatureRecord];

        WPMyViewController *myVC= [[WPMyViewController alloc] init];
        [myVC.tabBarItem setImage:[[UIImage imageNamed:@"btn-tab-me-u"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [myVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btn-tab-me-p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_controllerList addObject:myVC];
    }
    return self;
}

- (void)updateData{
    [WPNetInterface getUserinfoWithUserId:kDefaultObjectForKey(USER_DEFAULT_USER_ID) password:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_TOKEN) success:^(NSDictionary* userDic) {
        if (userDic) {
            kDefaultSetObjectForKey(userDic, USER_DEFAULT_ACCOUNT_USER);
            [self getProfile];
            [self getDevice];
            [self getPeriods];
        }else{
            kDefaultRemoveForKey(USER_DEFAULT_ACCOUNT_USER);
        }
    } failure:^(NSError *error) {
        
    }];
    [self getTemperatures];
}

- (void)getProfile{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (![NSString leie_isBlankString:user.profile_id]) {
        [WPNetInterface getProfileWithId:user.profile_id success:^(NSDictionary *profileDic) {
            if (profileDic) {
                kDefaultSetObjectForKey(profileDic, USER_DEFAULT_PROFILE);
                WPProfileModel *profile = [[WPProfileModel alloc] init];
                [profile loadDataFromkeyValues:profileDic];
                WPEventModel *event = [[WPEventModel alloc] init];
                event.date = profile.lastperiod;
                event.pid = event.date;
                [event insertOrupdateToDBDependsOn:nil];
            }else{
                kDefaultRemoveForKey(USER_DEFAULT_PROFILE);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyUpdateProfile object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)getDevice{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (![NSString leie_isBlankString:user.device_id]) {
        [WPNetInterface getDeviceWithId:user.device_id success:^(NSDictionary *deviceDic) {
            if (deviceDic) {
                kDefaultSetObjectForKey(deviceDic, USER_DEFAULT_DEVICE);
                [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyUpdateDevice object:nil];
                [[WPConnectDeviceManager defaultInstance] startTimer];
            }else{
                kDefaultRemoveForKey(USER_DEFAULT_DEVICE);
            }
        } failure:^(NSError *error) {
            [[WPConnectDeviceManager defaultInstance] startTimer];
        }];
    }
}

- (void)getTemperatures{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (![NSString leie_isBlankString:user.device_id]) {
        //    NSString *temp_updatetime = kDefaultObjectForKey(TEMPERATURE_DEFAULT_UPDATETIME);
        //开始时间当前设备最后一条温度的时间
        WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
        NSArray *tempsArr = [XJFDBManager searchModelsWithCondition:temperature andpage:0 andOrderby:@"lastupdate" isAscend:NO];
        WPTemperatureModel *localTemp = tempsArr.firstObject;
        NSString *temp_updatetime = nil;
        if (localTemp) {
            temp_updatetime = localTemp.lastupdate;
        }
        [WPNetInterface getTemperaturesWithUserId:user.user_id startTime:temp_updatetime end_update_time:nil success:^(NSArray *temperatures) {
            for (NSDictionary *tempDic in temperatures) {
                WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
                [temp loadDataFromkeyValues:tempDic];
                [self insertTemperature:temp];
            }
            kDefaultSetObjectForKey([NSNumber numberWithBool:YES], TEMPERATURE_DEFAULT_GETTEMP);
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyGetTemp object:nil];
        } failure:^(NSError *error) {
            kDefaultSetObjectForKey([NSNumber numberWithBool:YES], TEMPERATURE_DEFAULT_GETTEMP);
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyGetTemp object:nil];
        }];
    }
}

- (void)insertTemperature:(WPTemperatureModel *)temp{
    NSDate *date = [NSDate dateFromUTCString:temp.time format:@"yyyy MM dd HH:mm:ss"];
    if (date) {
        NSTimeInterval time = [date timeIntervalSince2000];
        if (time >= 0) {
            WPDeviceModel *device = [[WPDeviceModel alloc] init];
            [device loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_DEVICE)];
            WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
            temperature.date = [NSDate stringFromDate:date format:@"yyyy MM dd"];
            NSArray *tempsArr = [XJFDBManager searchModelsWithCondition:temperature andpage:-1 andOrderby:@"time" isAscend:NO];
            WPTemperatureModel *localTemp = tempsArr.firstObject;
            temp.date = temperature.date;
            temp.time = [NSString stringWithFormat:@"%f",time] ;
            if (localTemp) {
                if ([temp.time longLongValue] >= [localTemp.time longLongValue]) {
                    //替换当前记录
                    [XJFDBManager deleteModel:localTemp dependOnKeys:nil];
                    [temp insertToDB];
                }
            }else{
                //插入当前时间
                [temp insertToDB];
            }
        }
    }
}

- (void)getPeriods{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (![NSString leie_isBlankString:user.user_id]) {
        WPPeriodModel *period = [[WPPeriodModel alloc] init];
        NSArray *periodsArr = [XJFDBManager searchModelsWithCondition:period andpage:0 andOrderby:@"lastupdate" isAscend:NO];
        WPPeriodModel *localPeriod= periodsArr.firstObject;
        NSString *updatetime = nil;
        if (localPeriod) {
            updatetime = localPeriod.lastupdate;
        }
        [WPNetInterface getPeriod:nil start_update_time:updatetime end_update_time:nil success:^(NSArray *periods) {
            for (NSDictionary *periodDic in periods) {
                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                [period loadDataFromkeyValues:periodDic];
                [period insertToDB];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyGetPeriod object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
}
@end
