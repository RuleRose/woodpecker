//
//  WPMyViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMyViewController.h"
#import "WPTableViewCell.h"
#import "WPMyHeaderView.h"
#import "WPMyInfoViewController.h"
#import "WPBasicInfoViewController.h"
#import "WPPeriodViewController.h"
#import "WPHelpViewController.h"
#import "WPAboutViewController.h"
#import "WPShoppingViewController.h"
#import "WPUserModel.h"
#import "WPProfileModel.h"

@interface WPMyViewController ()<UITableViewDataSource,UITableViewDelegate,MyInfoHeaderViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) WPMyHeaderView* headerView;
@property (nonatomic, strong) WPUserModel *userinfo;
@property (nonatomic, strong) WPProfileModel *profile;
@end

@implementation WPMyViewController
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _headerView = [[WPMyHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 157)];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.delegate = self;
        _tableView.tableHeaderView = _headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
    [self loadData];

}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    _userinfo = [[WPUserModel alloc] init];
    [_userinfo loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    _profile = [[WPProfileModel alloc] init];
    [_profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
    _headerView.userinfo = _userinfo;
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 3) {
        NSString* identifier = @"SpaceCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        NSString* identifier = @"MyCell";
        WPTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}
- (void)configureCell:(WPTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    cell.rightModel = kCellRightModelNext;
    if (indexPath.row == 1) {
        cell.icon.image = kImage(@"icon-me-basic");
        cell.titleLabel.text = kLocalization(@"me_basic");
        cell.detailLabel.text = @"";
        cell.line.hidden = YES;
    }else if (indexPath.row == 2){
        cell.icon.image = kImage(@"icon-me-cycle");
        cell.titleLabel.text = kLocalization(@"me_period");
        if ([NSString leie_isBlankString:_profile.period]) {
             cell.detailLabel.text = @"";
        }else{
            cell.detailLabel.text = [NSString stringWithFormat:kLocalization(@"me_period_unit"),_profile.period];
        }
        cell.line.hidden = NO;
    }else if (indexPath.row == 4){
        cell.icon.image = kImage(@"icon-me-about");
        cell.titleLabel.text = kLocalization(@"me_about");
        cell.detailLabel.text = @"";
        cell.line.hidden = NO;
    }else if (indexPath.row == 5){
        cell.icon.image = kImage(@"icon-me-help");
        cell.titleLabel.text = kLocalization(@"me_help");
        cell.detailLabel.text = @"";
        cell.line.hidden = NO;
    }
    [cell drawCellWithSize:CGSizeMake(kScreen_Width, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 3) {
        return 20;
    }
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 1) {
        WPBasicInfoViewController *basicVC = [[WPBasicInfoViewController alloc] init];
        basicVC.userinfo = _userinfo;
        [self.navigationController pushViewController:basicVC animated:YES];
    }else if (indexPath.row == 2){
        WPPeriodViewController *periodVC = [[WPPeriodViewController alloc] init];
        periodVC.profile = _profile;
        [self.navigationController pushViewController:periodVC animated:YES];
    }else if (indexPath.row == 4){
        WPAboutViewController *aboutVC = [[WPAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (indexPath.row == 5){
        WPHelpViewController *helpVC = [[WPHelpViewController alloc] init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
}

#pragma mark MyInfoHeaderViewDelegate
- (void)selectedAvatar{

}

- (void)selectedAccount{
    WPMyInfoViewController *infoVC = [[WPMyInfoViewController alloc] init];
    infoVC.userinfo = _userinfo;
    [self.navigationController pushViewController:infoVC animated:YES];
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
