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
        _isBindNewDevice = NO;
    }
    return self;
}

- (void)bindDevice{
    //去绑定
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    NSString *softwareRev = [MMCDeviceManager defaultInstance].currentDevice.softwareRev;
    NSString *hardwareRev = [MMCDeviceManager defaultInstance].currentDevice.hardwareRev;
    NSString *modelNum = [MMCDeviceManager defaultInstance].currentDevice.modelNum;
    NSString *MacAddr = [MMCDeviceManager defaultInstance].currentDevice.MacAddr;
    [WPNetInterface registerDevice:MacAddr num:modelNum software_rev:softwareRev hardware_rev:hardwareRev success:^(NSString *device_id) {
        @weakify(self);
        [WPNetInterface bindDevice:user.user_id device_id:device_id start_dindex:@"0" success:^(BOOL bind) {
            @strongify(self);
            self.isBindNewDevice = YES;
            WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
            temp.device = @"1";
            NSArray *arr = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:NO];
            temp = arr.firstObject;
            if (temp) {
                self.syncFromTime = temp.time;
            }else{
                self.syncFromTime = nil;
            }
            
            user.device_id = device_id;
            kDefaultSetObjectForKey([user transToDictionary], USER_DEFAULT_ACCOUNT_USER);
            WPDeviceModel *device = [[WPDeviceModel alloc] init];
            device.device_id = device_id;
            device.mac_addr = softwareRev;
            device.hardware_rev = hardwareRev;
            device.model_num = modelNum;
            kDefaultSetObjectForKey([device transToDictionary], USER_DEFAULT_DEVICE);
            [self syncTempDataFromIndex:0];
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

- (void)syncTempDataFromIndex:(NSInteger)index{
    //连接成功后，马上同步数据会失败，需要时间发现服务和属性
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MMCDeviceManager defaultInstance] syncDataFromIndex:index callback:^(NSInteger sendState) {
            
        }];
    });
}

- (void)syncTempData{
    //获取该设备最后一条本地温度信息dindex
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (![NSString leie_isBlankString:user.device_id]) {
        WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
        temp.device_id = user.device_id;
        NSArray *arr = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:NO];
        temp = arr.firstObject;
        if (temp) {
            [self syncTempDataFromIndex:[temp.dindex integerValue]];
        }else{
            [self syncTempDataFromIndex:0];
        }
    }
}

- (void)syncTempDataToService{
    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
    temp.sync = @"0";
    NSArray *temps = [XJFDBManager searchModelsWithCondition:temp andpage:-1 andOrderby:nil isAscend:YES];
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    [WPNetInterface postTemps:temps user_id:user.user_id success:^(BOOL finished) {
        for (WPTemperatureModel *temperature in temps) {
            temperature.sync = @"1";
            [temperature updateToDBDependsOn:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (NSDate *)getStartDate{
    WPTemperatureModel *temp = [[WPTemperatureModel alloc] init];
    NSArray *temps = [XJFDBManager searchModelsWithCondition:temp andpage:0 andOrderby:@"time" isAscend:YES];
    WPTemperatureModel *startTemp = temps.firstObject;
    if (startTemp) {
        return [NSDate dateWithTimeIntervalSince2000:[startTemp.time longLongValue]];
    }
    return nil;
}
@end
