//
//  MMCMainViewController.m
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "WPMainViewController.h"
#import "UIImage+Extension.h"
#import "WPNetInterface.h"

@interface WPMainViewController ()

@end

@implementation WPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self.tabBar setBackgroundImage:[UIImage drawImageWithSize:CGSizeMake(kScreen_Width, 45) color:kColor_4]];
    // Do any additional setup after loading the view.
    [self updateUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkVersion) name:WPNotificationKeyVersion object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self checkVersion];
}

- (void)setupData {
    self.viewModel = [[WPMainViewModel alloc] init];
    self.viewControllers = self.viewModel.controllerList;
}

- (void)updateUserInfo{
    [_viewModel updateData];
}

- (void)checkVersion{
//    NSString *newestVersion = kDefaultObjectForKey(USER_DEFAULT_NEWEST_VERSION);
    NSString *lowestVersion = kDefaultObjectForKey(USER_DEFAULT_LOWEST_VERSION);
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (![NSString leie_isBlankString:lowestVersion] && ![currentVersion isEqualToString:lowestVersion]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:kLocalization(@"noti_version") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:kLocalization(@"common_version") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *link = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kStoreAppId];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
        }];
        [alertController addAction:confirmAction];
        if (!self.navigationController.presentedViewController) {
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
    }
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
