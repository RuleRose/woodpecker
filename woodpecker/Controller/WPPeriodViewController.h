//
//  WPPeriodViewController.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseViewController.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"

@interface WPPeriodViewController : XJFBaseViewController
@property(nonatomic, strong) WPUserModel *userinfo;
@property(nonatomic, strong) WPProfileModel *profile;
@property(nonatomic, assign) BOOL isLogin;
@end
