//
//  MMCMainViewModel.h
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "WPDeviceModel.h"
#import "WPTemperatureModel.h"

@interface WPMainViewModel : NSObject
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;
@property(nonatomic, strong)WPDeviceModel *device;

@property (nonatomic,strong) NSMutableArray *controllerList;
- (void)updateData;
- (void)insertTemperature:(WPTemperatureModel *)temp;
@end
