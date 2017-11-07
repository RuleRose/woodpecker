//
//  WPBasicInfoViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPBasicInfoViewController.h"
#import "WPBasicInfoViewModel.h"
#import "WPInfoSettingCell.h"
#import "WPHeightPopupView.h"
#import "WPWeightPopupView.h"
#import "WPBirthdayPopupView.h"
#import "WPPeriodViewController.h"
#import "NSDate+Extension.h"

@interface WPBasicInfoViewController ()<UITableViewDelegate, UITableViewDataSource, WPInfoSettingCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* nextBtn;
@property (nonatomic, strong) WPBasicInfoViewModel *viewModel;
@property (nonatomic, strong) UITextField *activeTextField;

@end

@implementation WPBasicInfoViewController

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kNavigationHeight + kStatusHeight + 14, kScreen_Width - 30, 164)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 6;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] init];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"基本信息";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    if (_isLogin) {
        self.navigationItem.rightBarButtonItems = @[];
    }else{
        [self setMoreBarButtonWithTitle:@"保存" color: kColor_7_With_Alpha(0.8)];
    }
    
}

- (void)setupData{
    _viewModel = [[WPBasicInfoViewModel alloc] init];
    if (!_userinfo) {
       _userinfo = [[WPUserModel alloc] init];
        _userinfo.user_id = kDefaultObjectForKey(USER_DEFAULT_USER_ID);
    }
}

- (void)setupViews{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor clearColor];
    _nextBtn.layer.borderColor = kColor_8_With_Alpha(0.8).CGColor;
    _nextBtn.layer.borderWidth = 0.5;
    _nextBtn.titleLabel.font = kFont_1(15);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    [self.view addSubview:self.tableView];
    _nextBtn.frame = CGRectMake((kScreen_Width - 300)/2, _tableView.bottom + 69, 300, 45);
    _nextBtn.hidden = !_isLogin;
}

- (void)moreBarButtonPressed:(UIButton *)sender{
    [_activeTextField resignFirstResponder];
    if (![NSString leie_isBlankString:_userinfo.nick_name] && ![NSString leie_isBlankString:_userinfo.birthday]) {
        [_viewModel updateUserinfo:_userinfo reuslt:^(BOOL success) {
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }

}

- (void)nextBtnPressed{
    if (_activeTextField) {
        [_activeTextField resignFirstResponder];
        _userinfo.nick_name = _activeTextField.text;
    }
    if (![NSString leie_isBlankString:_userinfo.birthday] && ![NSString leie_isBlankString:_userinfo.nick_name]) {
        WPPeriodViewController *periodVC = [[WPPeriodViewController alloc] init];
        periodVC.userinfo = _userinfo;
        periodVC.isLogin = _isLogin;
        [self.navigationController pushViewController:periodVC animated:YES];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"BasicInfoCell";
    WPInfoSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPInfoSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(WPInfoSettingCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"昵称";
        cell.textField.text = _userinfo.nick_name;
        cell.line.hidden = YES;
        cell.textField.enabled = YES;
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"出生日期";
        cell.textField.text = _userinfo.birthday;
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"身高";
        cell.textField.text = _userinfo.height;
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 3){
        cell.titleLabel.text = @"体重";
        cell.textField.text = _userinfo.weight;
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }
    cell.delegate = self;
    [cell drawCellWithSize:CGSizeMake(kScreen_Width - 30, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        WPInfoSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
    }else if (indexPath.row == 1){
        if (_activeTextField) {
            [_activeTextField resignFirstResponder];
        }
        WPBirthdayPopupView *popView = [[WPBirthdayPopupView alloc] init];
        popView.birthdayBlock = ^(MMPopupView *popupView, NSDate *birthday) {
            _userinfo.birthday = [NSDate stringFromDate:birthday];
            [_tableView reloadData];
        };
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }else if (indexPath.row == 2){
        if (_activeTextField) {
            [_activeTextField resignFirstResponder];
        }
        WPHeightPopupView *popView = [[WPHeightPopupView alloc] init];
        popView.heightBlock = ^(MMPopupView *popupView, NSInteger height) {
            _userinfo.height = [NSString stringWithFormat:@"%ldcm",(long)height];
            [_tableView reloadData];
        };
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }else if (indexPath.row == 3){
        if (_activeTextField) {
            [_activeTextField resignFirstResponder];
        }
        WPWeightPopupView *popView = [[WPWeightPopupView alloc] init];
        popView.weightBlock = ^(MMPopupView *popupView, NSInteger weight1, NSInteger weight2) {
            _userinfo.weight = [NSString stringWithFormat:@"%ld.%ldkg",(long)weight1,(long)weight2];
            [_tableView reloadData];
        };
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }
}

#pragma mark WPInfoSettingCellDelegate

- (void)textFieldDidBeginEditing:(UITextField*)textField cell:(WPInfoSettingCell*)cell{
    _activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField*)textField cell:(WPInfoSettingCell*)cell{
    _userinfo.nick_name = _activeTextField.text;
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
