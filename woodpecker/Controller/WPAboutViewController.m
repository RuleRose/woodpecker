//
//  WPAboutViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/10/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPAboutViewController.h"
#import "WPTableViewCell.h"
#import "WPPrivacyViewController.h"
#import "WPSafetyViewController.h"

@interface WPAboutViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation WPAboutViewController
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, kScreen_Height - (kNavigationHeight + kStatusHeight))];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat height = (kScreen_Height - (82 + kNavigationHeight + kStatusHeight))/2;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width,height)];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 81)/2, (height - 81)/2, 81, 81)];
        iconView.backgroundColor = [UIColor clearColor];
        iconView.image = kImage(@"ima-logon");
        [headerView addSubview:iconView];
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconView.bottom  +15, kScreen_Width, 38)];
        versionLabel.backgroundColor = [UIColor clearColor];
        versionLabel.textColor = kColor_7;
        versionLabel.font = kFont_1(12);
        NSString *strVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        versionLabel.text = [NSString stringWithFormat:@"版本号:%@",strVersion];
        versionLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:versionLabel];
        _tableView.tableHeaderView = headerView;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
        footerView.backgroundColor = [UIColor clearColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.5)];
        lineView.backgroundColor = kColor_9_With_Alpha(0.1);
        [footerView addSubview:lineView];
        UILabel *notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 64, kScreen_Width, 64)];
        notiLabel.backgroundColor = [UIColor clearColor];
        notiLabel.textColor = kColor_7;
        notiLabel.font = kFont_1(12);
        notiLabel.text = @"Copyright 2017 Miaomiaoce";
        notiLabel.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:notiLabel];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"关于";
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"ClockCell";
    WPTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(WPTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    if (indexPath.row == 0) {
        cell.rightModel = kCellRightModelNext;
        cell.titleLabel.text = @"用户协议与隐私政策";
        cell.line.hidden = NO;
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNext;
        cell.titleLabel.text = @"安全要求及注意事项";
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
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        WPPrivacyViewController *privacyVC = [[WPPrivacyViewController alloc] init];
        [self.navigationController pushViewController:privacyVC animated:YES];
    }else{
        WPSafetyViewController *safetyVC = [[WPSafetyViewController alloc] init];
        [self.navigationController pushViewController:safetyVC animated:YES];
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
