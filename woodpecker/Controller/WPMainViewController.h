//
//  MMCMainViewController.h
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPMainViewModel.h"
@interface WPMainViewController : UITabBarController
@property (nonatomic,strong) WPMainViewModel *viewModel;
@end
