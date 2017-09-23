//
//  WPThermometerViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerViewController.h"
#import "WPThermometerViewModel.h"
#import "WPThermometerClockViewController.h"
#import "WPThermometerUnitViewController.h"
#import "WPThermometerHardwareViewController.h"
#import "WPTableViewCell.h"
#import "WPAlertPopupView.h"

@interface WPThermometerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton *removeBtn;
@property (nonatomic, strong) WPThermometerViewModel *viewModel;
@end

@implementation WPThermometerViewController
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
        _tableView.tableHeaderView = [[UIView alloc] init];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 90)];
        footerView.backgroundColor = [UIColor clearColor];
        _removeBtn = [[UIButton alloc] initWithFrame:CGRectMake(37, 42, kScreen_Width - 74, 45)];
        _removeBtn.backgroundColor = [UIColor clearColor];
        _removeBtn.layer.borderColor = kColor_8.CGColor;
        _removeBtn.layer.borderWidth = 0.5;
        [_removeBtn setTitle:kLocalization(@"thermometer_remove_binding") forState:UIControlStateNormal];
        [_removeBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
        _removeBtn.titleLabel.font = kFont_1(15);
        [_removeBtn addTarget:self action:@selector(removeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_removeBtn];
        _tableView.tableFooterView = footerView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"体温计";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    
}

- (void)setupData{
    _viewModel = [[WPThermometerViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"ThermometerCell";
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
    cell.leftModel = kCellLeftModelIcon;
    cell.rightModel = kCellRightModelNext;
    if (indexPath.row == 0) {
        cell.icon.image = kImage(@"icon-device-alarm");
        cell.titleLabel.text = kLocalization(@"thermometer_clock");
        cell.detailLabel.text = @"05:30";
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.icon.image = kImage(@"icon-device-unit");
        cell.titleLabel.text = kLocalization(@"thermometer_unit");
        cell.detailLabel.text = @"摄氏度°C";
        cell.line.hidden = NO;
    }else if (indexPath.row == 2){
        cell.icon.image = kImage(@"icon-device-settings");
        cell.titleLabel.text = kLocalization(@"thermometer_hardware");
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
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        WPThermometerClockViewController *clockVC = [[WPThermometerClockViewController alloc] init];
        [self.navigationController pushViewController:clockVC animated:YES];
    }else if (indexPath.row == 1){
        WPThermometerUnitViewController *unitVC = [[WPThermometerUnitViewController alloc] init];
        [self.navigationController pushViewController:unitVC animated:YES];
    }else if (indexPath.row == 2){
        WPThermometerHardwareViewController *hardwareVC = [[WPThermometerHardwareViewController alloc] init];
        [self.navigationController pushViewController:hardwareVC animated:YES];
    }
}

- (void)removeBtnPressed{
    WPAlertPopupView *popView = [[WPAlertPopupView alloc] init];
    popView.title = @"确定解除体温计绑定？";
    popView.cancelBlock = ^(MMPopupView *popupView) {
        
    };
    popView.confirmBlock = ^(MMPopupView *popupView, BOOL finished) {
        
    };
    [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
        
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
