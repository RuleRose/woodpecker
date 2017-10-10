//
//  WPPeriodViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPeriodViewController.h"
#import "WPPeriodViewModel.h"
#import "WPInfoSettingCell.h"
#import "WPPeriodPopupView.h"
#import "WPPeriodInfoViewController.h"
#import "WPMenstrualPopupView.h"
#import "WPMenstrualInfoViewController.h"
#import "WPMenstrualRegularPopupView.h"
#import "WPMenstrualLastperiodPopupView.h"
#import "NSDate+Extension.h"
#import "WPMainViewController.h"

@interface WPPeriodViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* finishBtn;
@property (nonatomic, strong) WPPeriodViewModel *viewModel;
@end

@implementation WPPeriodViewController
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, kNavigationHeight + kStatusHeight + 14, kScreen_Width - 30, 123)];
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
    self.title = @"周期信息";
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
    _viewModel = [[WPPeriodViewModel alloc] init];
    if (!_profile) {
        _profile = [[WPProfileModel alloc] init];
    }
}

- (void)setupViews{
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.backgroundColor = [UIColor clearColor];
    _finishBtn.layer.borderColor = kColor_8_With_Alpha(0.8).CGColor;
    _finishBtn.layer.borderWidth = 0.5;
    _finishBtn.titleLabel.font = kFont_1(15);
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
    [_finishBtn addTarget:self action:@selector(finishBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];
    [self.view addSubview:self.tableView];
    _finishBtn.frame = CGRectMake((kScreen_Width - 300)/2, _tableView.bottom + 69, 300, 45);
    _finishBtn.hidden = !_isLogin;

}

- (void)moreBarButtonPressed:(UIButton *)sender{
    [_viewModel updateProfile:_profile reuslt:^(BOOL success) {
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)finishBtnPressed{
    //上传userinfo 和 profile
    if (![NSString leie_isBlankString:_profile.menstruation] && ![NSString leie_isBlankString:_profile.period] && ![NSString leie_isBlankString:_profile.lastperiod]) {
        [_viewModel updateUserinfo:_userinfo reuslt:^(BOOL success) {
            if (success) {
                [_viewModel registerProfile:_profile reuslt:^(BOOL success) {
                    if (success) {
                        kDefaultSetObjectForKey([_userinfo transToDictionary], USER_DEFAULT_ACCOUNT_USER);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
    }
    WPMainViewController *mainVC = [[WPMainViewController alloc] init];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [viewControllers removeAllObjects];
    [viewControllers addObject:mainVC];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"PeriodCell";
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
        cell.titleLabel.text = @"周期长度";
        cell.textField.text = _profile.period;
        cell.line.hidden = YES;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"经期长度";
        cell.textField.text = _profile.menstruation;
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"末次经期首日";
        cell.textField.text = _profile.lastperiod;
        cell.line.hidden = NO;
        cell.textField.enabled = NO;
    }
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
        WPPeriodPopupView *popView = [[WPPeriodPopupView alloc] init];
        popView.periodBlock = ^(MMPopupView *popupView, NSInteger period) {
            _profile.period = [NSString stringWithFormat:@"%ld",(long)period];
            [_tableView reloadData];
        };
        popView.showInfoBlock = ^(MMPopupView *popupView) {
            WPPeriodInfoViewController *infoVC = [[WPPeriodInfoViewController alloc] init];
            [self.navigationController pushViewController:infoVC animated:YES];
        };
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }else if (indexPath.row == 1){
        WPMenstrualPopupView *popView = [[WPMenstrualPopupView alloc] init];
        popView.menstrualBlock = ^(MMPopupView *popupView, NSInteger menstrual) {
            _profile.menstruation = [NSString stringWithFormat:@"%ld",(long)menstrual];
            [_tableView reloadData];
        };
        popView.showInfoBlock = ^(MMPopupView *popupView) {
            WPMenstrualInfoViewController *infoVC = [[WPMenstrualInfoViewController alloc] init];
            [self.navigationController pushViewController:infoVC animated:YES];
        };
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }else if (indexPath.row == 2){
        WPMenstrualLastperiodPopupView *popView = [[WPMenstrualLastperiodPopupView alloc] init];
        popView.lastperiodBlock = ^(MMPopupView *popupView, NSDate *lastperiod) {
            _profile.lastperiod = [NSDate stringFromDate:lastperiod];
            [_tableView reloadData];
        };
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
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
