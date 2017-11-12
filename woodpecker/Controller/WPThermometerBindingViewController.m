//
//  WPThermometerBindingViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerBindingViewController.h"
#import "WPThermometerBindingViewModel.h"
#import "MMCDeviceManager.h"
#import "XJFHUDManager.h"

@interface WPThermometerBindingViewController ()
@property (nonatomic, strong) WPThermometerBindingViewModel *viewModel;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIImageView *iconView;

@end

@implementation WPThermometerBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_4;
    self.title = kLocalization(@"thermometer_binding");
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionState)  name:MMCNotificationKeyDeviceConnectionState object:nil];
    [[MMCDeviceManager defaultInstance] startScanAndConnect:^(NSInteger sendState) {
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMCNotificationKeyDeviceState object:nil];
}

- (void)setupData{
    _viewModel = [[WPThermometerBindingViewModel alloc] init];
}

- (void)updateConnectionState{
    if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_CONNECTED) {
        [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_connect_success")];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE){
        [[XJFHUDManager defaultInstance] showTextHUD:kLocalization(@"noti_connect_failure")];
        [self.navigationController popViewControllerAnimated:YES];
   }
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, kScreen_Width, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7;
    _titleLabel.font = kFont_1(12);
    _titleLabel.text = kLocalization(@"noti_thermometer_binding");
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 283)/2, 200, 283, 336)];
    _iconView.backgroundColor = [UIColor clearColor];
    _iconView.image = kImage(@"binding-ima");
    [self.view addSubview:_iconView];
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
