//
//  LeieServerManager.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/8.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFServerManager.h"

static XJFServerManager *_shareManager = nil;

@implementation XJFServerManager

+ (XJFServerManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _shareManager = [[XJFServerManager alloc] init];
    });
    return _shareManager;
}

- (void)loadSettingsConfig {
    _serverURL = @"iotpilot.miaomiaoce.com";
}
@end
