//
//  MMCMainViewModel.m
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "WPMainViewModel.h"
#import "WPStatusViewController.h"
#import "WPTemperatureRecordViewController.h"
#import "WPMyInfoViewController.h"

@implementation WPMainViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _controllerList = [NSMutableArray array];
        WPStatusViewController *statusVC = [[WPStatusViewController alloc] init];
        [statusVC.tabBarItem setImage:[[UIImage imageNamed:@"btn-tab-status-u"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [statusVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btn-tab-status-s"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_controllerList addObject:statusVC];
        
        WPTemperatureRecordViewController *temperatureRecord = [[WPTemperatureRecordViewController alloc] init];
        [temperatureRecord.tabBarItem setImage:[[UIImage imageNamed:@"btn-tab-curve-u"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [temperatureRecord.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btn-tab-curve-p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_controllerList addObject:temperatureRecord];

        WPMyInfoViewController *myInfo = [[WPMyInfoViewController alloc] init];
        [myInfo.tabBarItem setImage:[[UIImage imageNamed:@"btn-tab-me-u"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [myInfo.tabBarItem setSelectedImage:[[UIImage imageNamed:@"btn-tab-me-p"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [_controllerList addObject:myInfo];
    }
    return self;
}
@end
