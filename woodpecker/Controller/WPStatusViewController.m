//
//  WPStatusViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusViewController.h"
#import "WPStatusView.h"
#import "WPStatusViewModel.h"
#import "WPThermometerViewController.h"
#import "WPRecordViewController.h"
#import "WPCalendarViewController.h"
#import "CATransition+PageTransition.h"
#import "WPThermometerBindViewController.h"
#import "WPThermometerRemoveViewController.h"
#import "WPThermometerEditViewController.h"
#import "WPConnectDeviceManager.h"
#import "MMCDeviceManager.h"
#import "WPTemperatureModel.h"
#import "XJFDBManager.h"
#import "WPThermometerRemoveViewController.h"
#import "WPThermometerViewController.h"

@interface WPStatusViewController ()<WPStatusViewDelegate>
@property(nonatomic, strong) WPStatusView *statusView;
@property(nonatomic, strong) WPStatusViewModel *viewModel;

@end

@implementation WPStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_10;
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionState)  name:MMCNotificationKeyDeviceConnectionState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState)  name:MMCNotificationKeyDeviceState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTemperature:)  name:MMCNotificationKeyTemperature object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTemperature)  name:WPNotificationKeyGetTemp object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPeriod)  name:WPNotificationKeyGetPeriod object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_statusView updateState];
    _statusView.startDate = [_viewModel getStartDate];
}

- (void)setupData{
    _viewModel = [[WPStatusViewModel alloc] init];
}

- (void)setupViews{
    _statusView = [[WPStatusView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _statusView.backgroundColor = [UIColor clearColor];
    _statusView.delegate = self;
    _statusView.viewModel = _viewModel;
    [self.view addSubview:_statusView];
}

- (void)updateConnectionState{
    [_statusView updateState];
    if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_CONNECTED) {
        [[WPConnectDeviceManager defaultInstance] stopTimer];
        WPUserModel *user = [[WPUserModel alloc] init];
        [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        self.viewModel.isBindNewDevice = NO;
        if ([NSString leie_isBlankString:user.device_id]) {
            [_viewModel bindDevice];
        }else{
            [_viewModel syncTempData];
        }
    }else if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE){
        [[WPConnectDeviceManager defaultInstance] startTimer];
    }
}

- (void)updateState{
    if (([MMCDeviceManager defaultInstance].deviceState == MMC_STATE_IDLE) && ([MMCDeviceManager defaultInstance].preDeviceState == MMC_STATE_SYNC)) {
        //上传
        [_viewModel syncTempDataToService];
    }
}

- (void)receiveTemperature:(NSNotification *)notification{
    NSDictionary *userinfo = [notification userInfo];
    NSNumber *index = [userinfo objectForKey:NOTIFY_KEY_TEMPERATURE_INDEX];
    NSNumber *time = [userinfo objectForKey:NOTIFY_KEY_TEMPERATURE_TIME];
    NSNumber *temp = [userinfo objectForKey:NOTIFY_KEY_TEMPERATURE_VALUE];
    if (self.viewModel.isBindNewDevice && self.viewModel.syncFromTime) {
        if ([time longLongValue] < [self.viewModel.syncFromTime longLongValue]) {
            return;
        }
    }
    [_viewModel insertTemperature:temp index:index time:time];
}

- (void)getTemperature{
    [_viewModel syncTempData];
}
- (void)getPeriod{
    [_statusView updateState];
    _statusView.startDate = [_viewModel getStartDate];
}

#pragma mark WPStatusViewDelegate
- (void)showCalendar{
    WPCalendarViewController *calendarVC = [[WPCalendarViewController alloc] init];
    CATransition *transition = [CATransition moveInFromLeft:nil];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:calendarVC animated:NO];
}

- (void)showTemperature{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    switch ([MMCDeviceManager defaultInstance].deviceConnectionState) {
        case STATE_DEVICE_SCANNING:
        case STATE_DEVICE_CONNECTING:
        case STATE_DEVICE_DISCONNECTING:
            
            break;
        case STATE_DEVICE_CONNECTED:
        {
            WPThermometerViewController *removeVC = [[WPThermometerViewController alloc] init];
            [self.navigationController pushViewController:removeVC animated:YES];
        }
            break;
        default:
            if ([NSString leie_isBlankString:user.device_id] ) {
                WPThermometerBindViewController *bindVC = [[WPThermometerBindViewController alloc] init];
                [self.navigationController pushViewController:bindVC animated:YES];
            }else{
                WPThermometerRemoveViewController *removeVC = [[WPThermometerRemoveViewController alloc] init];
                [self.navigationController pushViewController:removeVC animated:YES];
            }
            break;
    }
//    WPThermometerViewController *removeVC = [[WPThermometerViewController alloc] init];
//    [self.navigationController pushViewController:removeVC animated:YES];

}

- (void)editTemperature{
    WPThermometerEditViewController *editVC = [[WPThermometerEditViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)showEventWithDate:(NSDate *)date{
    WPRecordViewController *recordVC = [[WPRecordViewController alloc] init];
    recordVC.eventDate = date;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
