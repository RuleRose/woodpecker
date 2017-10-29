//
//  WPCalendarDetailViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarDetailViewModel.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "NSDate+Extension.h"
#import "XJFDBManager.h"
#import "WPPeriodModel.h"

@interface WPCalendarDetailViewModel ()


@end
@implementation WPCalendarDetailViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _user = [[WPUserModel alloc] init];
        [_user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        _profile = [[WPProfileModel alloc] init];
        [_profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
        _periodDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
