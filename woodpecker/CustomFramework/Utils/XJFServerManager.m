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
#ifdef DEBUG
    _serverURL = @"wp.mmc-data.com";
    _APP_ID = @"mmc_wp";
    _APP_SECRET = @"mmc";
#else
    _serverURL = @"mmc-wp.mmc-data.com";
    _APP_ID = @"mmc_wp_prod";
    _APP_SECRET = @"2I4eOXyMf5izGtuUIexu5bin1tq6ZG";
#endif
}
@end
