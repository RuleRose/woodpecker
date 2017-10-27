//
//  WPThermometerEditViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerEditViewModel.h"
#import "WPNetInterface.h"
#import "XJFHUDManager.h"
#import "WPUserModel.h"
#import "WPDeviceModel.h"

@implementation WPThermometerEditViewModel
- (void)syncTemp:(WPTemperatureModel *)temp success:(void (^)(BOOL success))success{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    [WPNetInterface postTemps:@[temp] user_id:user.user_id success:^(NSArray *temperatures) {
        [[XJFHUDManager defaultInstance] showTextHUD:@"保存成功"];
        for (NSDictionary *tempDic in temperatures) {
            WPTemperatureModel *temperature = [[WPTemperatureModel alloc] init];
            [temperature loadDataFromkeyValues:tempDic];
            temperature.sync = @"1";
            [self insertTemperature:temperature];
        }
        if (success) {
            success(YES);
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)insertTemperature:(WPTemperatureModel *)temp{
    NSDate *date = [NSDate dateFromUTCString:temp.time format:@"yyyy MM dd HH:mm:ss"];
    if (date) {
        NSTimeInterval time = [date timeIntervalSince2000];
        if (time >= 0) {
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
@end
