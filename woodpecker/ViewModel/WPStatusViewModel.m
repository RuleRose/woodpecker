//
//  WPStatusViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusViewModel.h"
#import "WPNetInterface.h"
#import "MMCDeviceManager.h"
#import "WPDeviceModel.h"
#import "XJFDBManager.h"
#import "WPTemperatureModel.h"

@implementation WPStatusViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _temps = [[NSMutableArray alloc] init];
        _profile = [[WPProfileModel alloc] init];
        [_profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
        _user = [[WPUserModel alloc] init];
        [_user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        _device = [[WPDeviceModel alloc] init];
        [_device loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_DEVICE)];
    }
    return self;
}

- (void)bindDevice{
    //去绑定
    NSString *softwareRev = [MMCDeviceManager defaultInstance].currentDevice.softwareRev;
    NSString *hardwareRev = [MMCDeviceManager defaultInstance].currentDevice.hardwareRev;
    NSString *modelNum = [MMCDeviceManager defaultInstance].currentDevice.modelNum;
    NSString *MacAddr = [MMCDeviceManager defaultInstance].currentDevice.MacAddr;
    [WPNetInterface registerDevice:MacAddr num:modelNum software_rev:softwareRev hardware_rev:hardwareRev success:^(NSString *device_id) {
        [WPNetInterface bindDevice:_user.pid device_id:device_id start_dindex:@"0" success:^(BOOL bind) {
            _user.device_id = device_id;
            kDefaultSetObjectForKey([_user transToDictionary], USER_DEFAULT_ACCOUNT_USER);
            _device.pid = device_id;
            _device.mac_addr = softwareRev;
            _device.hardware_rev = hardwareRev;
            _device.model_num = modelNum;
            kDefaultSetObjectForKey([_device transToDictionary], USER_DEFAULT_DEVICE);
            [self syncTempDataFromIndex:0];
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

- (void)syncTempDataFromIndex:(NSInteger)index{
    [[MMCDeviceManager defaultInstance] syncDataFromIndex:index callback:^(NSInteger sendState) {
        
    }];
}

- (void)syncTempData{
    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
    temp.sync = @"0";
    NSArray *temps = [XJFDBManager searchModelsWithCondition:temp andpage:-1 andOrderby:nil isAscend:YES];
    [WPNetInterface postTemps:temps user_id:_user.pid success:^(BOOL finished) {
        for (WPTemperatureModel *temperature in temps) {
            temperature.sync = @"1";
            [temperature updateToDBDependsOn:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
