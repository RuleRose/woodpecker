 //
//  WPThermometerHardwareViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerHardwareViewController.h"
#import "WPThermometerHardwareViewModel.h"
#import "WPTableViewCell.h"
#import "MMCDeviceManager.h"
#import "WPDeviceModel.h"

@interface WPThermometerHardwareViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property(nonatomic, strong) WPThermometerHardwareViewModel *viewModel;
@end

@implementation WPThermometerHardwareViewController
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
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 14)];
        headerView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = kLocalization(@"hardware_info");
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
    _viewModel = [[WPThermometerHardwareViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    BleDeviceBroadcast *currentDevice = [MMCDeviceManager defaultInstance].currentDevice;
    WPDeviceModel *device = [[WPDeviceModel alloc] init];
    [device loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_DEVICE)];
    if (indexPath.row == 0) {
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"hardware_mmcid");
//        cell.detailLabel.text = device.device_id;
        cell.detailLabel.text = [NSString stringWithFormat:@"%ld",([device.device_id integerValue] + 500000000)];
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"hardware_battery");
        cell.detailLabel.text = [NSString stringWithFormat:@"%ld%%",(long)currentDevice.batteryLevelRaw];
        cell.line.hidden = NO;
    }else if (indexPath.row == 2){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"hardware_firmware");
        cell.detailLabel.text = currentDevice.firmwareRev;
    }else if (indexPath.row == 3){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"hardware_mac");
        cell.detailLabel.text = currentDevice.MacAddr;
        cell.line.hidden = NO;
    }else if (indexPath.row == 4){
        cell.rightModel = kCellRightModelImage;
        cell.titleLabel.text = kLocalization(@"hardware_rssi");
        cell.imageIcon.image = [_viewModel mapRssi:currentDevice.RSSI];
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
    if (indexPath.row == 1) {
        return 0;
    }
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
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
