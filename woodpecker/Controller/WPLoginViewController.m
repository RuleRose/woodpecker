//
//  WPLoginViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/9.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPLoginView.h"
#import "WPLoginViewModel.h"
#import "WPMainViewController.h"
#import "WPAccountManager.h"
#import "WPBasicInfoViewController.h"
#import "WPAgreementViewController.h"

@interface WPLoginViewController ()<WPLoginViewDelegate>
@property(nonatomic, strong) WPLoginView *loginView;
@property(nonatomic, strong) WPLoginViewModel *viewModel;

@end

@implementation WPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_10;
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:WPNotificationKeyLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:WPNotificationKeyLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancel) name:WPNotificationKeyLoginCancel object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenExpire) name:WPNotificationKeyTokenExpire object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WPNotificationKeyLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WPNotificationKeyLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WPNotificationKeyLoginCancel object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WPNotificationKeyTokenExpire object:nil];

}

- (void)setupData{
    _viewModel = [[WPLoginViewModel alloc] init];
}

- (void)setupViews{
    _loginView = [[WPLoginView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _loginView.backgroundColor = [UIColor clearColor];
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
}

#pragma mark - WPLoginViewDelegate
- (void)login{
    if ([[WPAccountManager defaultInstance] isLogin]) {
        [self registerAccount];
    }else{
        [_viewModel login];
    }
}

- (void)showAgreement{
    WPAgreementViewController *agreementVC = [[WPAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

#pragma mark - MI account login callback
- (void)loginSuccess{
    [self registerAccount];
}

- (void)loginFailed{
    
}

- (void)loginCancel{

}

- (void)tokenExpire{

}

- (void)registerAccount{
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
    NSString *user_id = kDefaultObjectForKey(USER_DEFAULT_USER_ID);
    if ([NSString leie_isBlankString:user_id]) {
        [_viewModel registerAccount:^(BOOL success) {
            if (success) {
                [self updateUserData];
            }
        }];
    }else{
        [self updateUserData];
    }
}

- (void)updateUserData{
    [_viewModel getAccount:^(WPUserModel *user) {
        if (user && ![NSString leie_isBlankString:user.profile_id]) {
            [_viewModel getProfile:user.profile_id success:^(WPProfileModel *profile) {
                [[XJFHUDManager defaultInstance] hideLoading];
                if (profile) {
                    WPMainViewController *mainVC = [[WPMainViewController alloc] init];
                    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                    [viewControllers removeAllObjects];
                    [viewControllers addObject:mainVC];
                    [self.navigationController setViewControllers:viewControllers animated:YES];
                }else{
                    WPBasicInfoViewController *basicVC = [[WPBasicInfoViewController alloc] init];
                    basicVC.userinfo = user;
                    basicVC.isLogin = YES;
                    [self.navigationController pushViewController:basicVC animated:YES];
                }
            }];
        }else{
            [[XJFHUDManager defaultInstance] hideLoading];
            //补充信息
            WPBasicInfoViewController *basicVC = [[WPBasicInfoViewController alloc] init];
            basicVC.userinfo = user;
            basicVC.isLogin = YES;
            [self.navigationController pushViewController:basicVC animated:YES];
        }
    }];
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
