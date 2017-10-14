//
//  WPThermometerRemoveViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerRemoveViewModel.h"
#import "WPUserModel.h"
#import "WPNetInterface.h"

@implementation WPThermometerRemoveViewModel
- (void)unBindDeviceSuccess:(void (^)(BOOL finished))result{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    [WPNetInterface unbindDevice:user.pid success:^(BOOL unbind) {
        user.device_id = nil;
        kDefaultSetObjectForKey([user transToDictionary], USER_DEFAULT_ACCOUNT_USER);
        kDefaultRemoveForKey(USER_DEFAULT_DEVICE);
        if (result) {
            result(YES);
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
