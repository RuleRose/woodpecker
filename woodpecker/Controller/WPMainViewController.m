//
//  MMCMainViewController.m
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "WPMainViewController.h"
#import "UIImage+Extension.h"

@interface WPMainViewController ()

@end

@implementation WPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self.tabBar setBackgroundImage:[UIImage drawImageWithSize:CGSizeMake(kScreen_Width, 45) color:kColor_4]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setupData {
    self.viewModel = [[WPMainViewModel alloc] init];
    self.viewControllers = self.viewModel.controllerList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
