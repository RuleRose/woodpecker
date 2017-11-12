//
//  WPThermometerClockViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerClockViewController.h"
#import "WPThermometerClockViewModel.h"
#import "WPTableViewCell.h"
#import "WPClockPopupView.h"
#import "MMCDeviceManager.h"
#import "NSDate+ext.h"
#import "NSDate+Extension.h"

@interface WPThermometerClockViewController ()<UITableViewDataSource,UITableViewDelegate,WPTableViewCellDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) WPThermometerClockViewModel *viewModel;
@end

@implementation WPThermometerClockViewController
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
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 260)];
        headerView.backgroundColor = [UIColor clearColor];
        UIImageView *clockIcon = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 168)/2, 24, 147, 168)];
        clockIcon.backgroundColor = [UIColor clearColor];
        clockIcon.image = kImage(@"ima-alarm");
        [headerView addSubview:clockIcon];
        UILabel *clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, clockIcon.bottom  +15, kScreen_Width, 38)];
        clockLabel.backgroundColor = [UIColor clearColor];
        clockLabel.textColor = kColor_7;
        clockLabel.font = kFont_1(12);
        clockLabel.numberOfLines = 2;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:kLocalization(@"clock_prompt") attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        clockLabel.attributedText = attributeStr;
        [headerView addSubview:clockLabel];
        _tableView.tableHeaderView = headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = kLocalization(@"thermometer_clock");
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmUpdated) name:MMCNotificationKeyAlarmUpdated object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMCNotificationKeyAlarmUpdated object:nil];
}


- (void)setupData{
    _viewModel = [[WPThermometerClockViewModel alloc] init];
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
        cell.rightModel = kCellRightModelSwitch;
        cell.titleLabel.text = kLocalization(@"clock_measurement");
        cell.switchView.on = [[MMCDeviceManager defaultInstance] alarmIsOn];
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNext;
        cell.titleLabel.text = kLocalization(@"clock_wakeup_time");
        NSNumber *timeNumber = kDefaultObjectForKey(TEMPERATURE_DEFAULT_CLOCK_TIME);
        NSTimeInterval alarmTimeInterval = [[MMCDeviceManager defaultInstance] alarmTimeInterval];
        if (timeNumber && ![MMCDeviceManager defaultInstance].alarmIsOn) {
            alarmTimeInterval = timeNumber.integerValue;
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince2000:alarmTimeInterval];
        if (date) {
            cell.detailLabel.text = [NSDate stringFromDate:date format:@"HH:mm"];
        }else{
            cell.detailLabel.text = kLocalization(@"common_no_setting");
        }
        cell.line.hidden = NO;
    }
    cell.delegate = self;
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
    if (indexPath.row == 1) {
        WPClockPopupView *popView = [[WPClockPopupView alloc] init];
        popView.clockBlock = ^(MMPopupView *popupView, NSDate *clock) {
            NSTimeInterval timeInterval = [clock timeIntervalSince2000];
            kDefaultSetObjectForKey([NSNumber numberWithFloat:timeInterval], TEMPERATURE_DEFAULT_CLOCK_TIME);
            if ([[MMCDeviceManager defaultInstance] alarmIsOn]) {
                [MMCDeviceManager defaultInstance].alarmTimeInterval = timeInterval;
                [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
                    
                }];
                [[MMCDeviceManager defaultInstance] writeAlarm:timeInterval timeZone:[NSTimeZone timeZoneDiffwithUTC] callback:^(NSInteger sendState) {
                }];
            }
            [_tableView reloadData];
        };
        popView.attachedView = self.navigationController.view;
        [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
            
        }];
    }
}

- (void)switchAction:(UISwitch*)sender cell:(WPTableViewCell*)cell{
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
    if (sender.on) {
        [[MMCDeviceManager defaultInstance] turnOffAlarm:^(NSInteger sendState) {
            
        }];
    }else{
        [[MMCDeviceManager defaultInstance] writeAlarm:[MMCDeviceManager defaultInstance].alarmTimeInterval timeZone:[NSTimeZone timeZoneDiffwithUTC] callback:^(NSInteger sendState) {
        }];

    }
}

- (void)alarmUpdated{
    [[XJFHUDManager defaultInstance] hideLoading];
    [_tableView reloadData];
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
