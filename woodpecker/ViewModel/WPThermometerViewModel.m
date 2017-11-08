//
//  WPThermometerViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerViewModel.h"
#import "WPNetInterface.h"
#import "WPUserModel.h"
#import "MMCDeviceManager.h"
#import "WPConnectDeviceManager.h"

@implementation WPThermometerViewModel
- (void)unBindDeviceSuccess:(void (^)(BOOL finished))result{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    [WPNetInterface unbindDevice:user.user_id success:^(BOOL unbind) {
        user.device_id = nil;
        kDefaultSetObjectForKey([user transToDictionary], USER_DEFAULT_ACCOUNT_USER);
        kDefaultRemoveForKey(USER_DEFAULT_DEVICE);
        [[WPConnectDeviceManager defaultInstance] stopTimer];
        [[MMCDeviceManager defaultInstance] disconnect:^(NSInteger sendState) {
            if (result) {
                result(YES);
            }
        }];
    } failure:^(NSError *error) {
        if (result) {
            result(NO);
        }
    }];
}
@end
