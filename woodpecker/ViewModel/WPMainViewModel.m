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
        UIViewController *statusVC = [[WPStatusViewController alloc] init];
        UIViewController *temperatureRecord = [[WPTemperatureRecordViewController alloc] init];
        UIViewController *myInfo = [[WPMyInfoViewController alloc] init];

        [_controllerList addObject:[self setupNaviController:statusVC
                                                       image:kImage(@"btn-tab-status-u")
                                               selectedImage:kImage(@"btn-tab-status-s")
                                                       title:nil
                                                         tag:1]];
        [_controllerList addObject:[self setupNaviController:temperatureRecord
                                                       image:kImage(@"btn-tab-curve-u")
                                               selectedImage:kImage(@"btn-tab-curve-p")
                                                       title:nil
                                                         tag:2]];
        [_controllerList addObject:[self setupNaviController:myInfo
                                                       image:kImage(@"btn-tab-me-u")
                                               selectedImage:kImage(@"btn-tab-me-p")
                                                       title:nil
                                                         tag:3]];
    }
    return self;
}

- (UIViewController *)setupNaviController:(UIViewController *)childVC
                                    image:(UIImage *)image
                            selectedImage:(UIImage *)selectedImage
                                    title:(NSString *)title
                                      tag:(NSInteger)tag {
    XJFBaseNavigationController *naviVC = [[XJFBaseNavigationController alloc] initWithRootViewController:childVC];
    
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    naviVC.tabBarItem.tag = tag;

    return naviVC;
}
@end
