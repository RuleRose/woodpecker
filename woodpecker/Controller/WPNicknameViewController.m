//
//  WPNicknameViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/10/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPNicknameViewController.h"
#import "WPNetInterface.h"

@interface WPNicknameViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation WPNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"昵称";
    [self setupViews];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    
}

- (void)setupViews{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, kNavigationHeight + kStatusHeight + 12, kScreen_Width - 40, 40)];
    _textField.backgroundColor = kColor_10;
    _textField.textColor = kColor_7;
    _textField.font = kFont_1(12);
    _textField.placeholder = @"请输入昵称";
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftView;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    _textField.rightView = rightView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(56, _textField.bottom + 100, (kScreen_Width - 120)/2, 48)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = kColor_9_With_Alpha(0.15).CGColor;
    _cancelBtn.layer.borderWidth = 0.5;
    [_cancelBtn setTitle:kLocalization(@"common_cancel") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = kFont_1(12);
    [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cancelBtn.right + 8, _textField.bottom + 100, (kScreen_Width - 120)/2, 48)];
    _saveBtn.backgroundColor = [UIColor clearColor];
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.borderColor = kColor_9_With_Alpha(0.15).CGColor;
    _saveBtn.layer.borderWidth = 0.5;
    [_saveBtn setTitle:kLocalization(@"common_save") forState:UIControlStateNormal];
    [_saveBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = kFont_1(12);
    [_saveBtn addTarget:self action:@selector(saveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
}

- (void)loadData{
    _textField.text = _userinfo.nick_name;
}

- (void)cancelBtnPressed{
    [_textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnPressed{
    [_textField resignFirstResponder];
    _userinfo.nick_name = _textField.text;
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
    [WPNetInterface updateUserInfoWithUserID:kDefaultObjectForKey(USER_DEFAULT_USER_ID) nickname:_userinfo.nick_name birthday:nil height:nil weight:nil success:^(BOOL success) {
        [[XJFHUDManager defaultInstance] hideLoading];
        kDefaultSetObjectForKey([_userinfo transToDictionary], USER_DEFAULT_ACCOUNT_USER);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [[XJFHUDManager defaultInstance] hideLoading];
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
