//
//  WPBasicInfoViewController.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseViewController.h"
#import "WPUserModel.h"

@interface WPBasicInfoViewController : XJFBaseViewController
@property(nonatomic, strong) WPUserModel *userinfo;
@property(nonatomic, assign) BOOL isLogin;

@end
