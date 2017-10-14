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
    [self setupViews];
    [self setupData];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionState)  name:MMCNotificationKeyDeviceConnectionState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState)  name:MMCNotificationKeyDeviceState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTemperature:)  name:MMCNotificationKeyTemperature object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_statusView updateState];
}

- (void)setupData{
    _viewModel = [[WPStatusViewModel alloc] init];
}

- (void)setupViews{
    _statusView = [[WPStatusView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _statusView.backgroundColor = [UIColor clearColor];
    _statusView.delegate = self;
    [self.view addSubview:_statusView];
}

- (void)updateConnectionState{
    [_statusView updateState];
    if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_CONNECTED) {
        [[WPConnectDeviceManager defaultInstance] stopTimer];
        [_viewModel.user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
        if ([NSString leie_isBlankString:_viewModel.user.device_id]) {
            [_viewModel bindDevice];
        }else{
            //获取该设备最后一条本地温度信息dindex
            [_viewModel syncTempDataFromIndex:0];
        }
    }else if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE){
        [[WPConnectDeviceManager defaultInstance] startTimer];
    }
}

- (void)updateState{
    if (([MMCDeviceManager defaultInstance].deviceState == MMC_STATE_IDLE) && ([MMCDeviceManager defaultInstance].preDeviceState == MMC_STATE_SYNC)) {
        //上传
        [_viewModel syncTempData];
    }
}

- (void)receiveTemperature:(NSNotification *)notification{
    NSDictionary *userinfo = [notification userInfo];
    NSNumber *index = [userinfo objectForKey:NOTIFY_KEY_TEMPERATURE_INDEX];
    NSNumber *timestamp = [userinfo objectForKey:NOTIFY_KEY_TEMPERATURE_TIME];
    NSNumber *temp = [userinfo objectForKey:NOTIFY_KEY_TEMPERATURE_VALUE];
    WPTemperatureModel *temperature =[[WPTemperatureModel alloc] init];
    temperature.dindex = [index stringValue];
    temperature.device_id = _viewModel.device.pid;
    temperature.time = [timestamp stringValue];
    temperature.temp = [temp stringValue];
    [temperature insertToDB];
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
    



//    WPThermometerViewController *thermometerVC = [[WPThermometerViewController alloc] init];
//    [self.navigationController pushViewController:thermometerVC animated:YES];

}

- (void)editTemperature{
    WPThermometerEditViewController *editVC = [[WPThermometerEditViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)showRecord{
    WPRecordViewController *recordVC = [[WPRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
