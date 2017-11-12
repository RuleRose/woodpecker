//
//  WPThermometerRemoveViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerRemoveViewController.h"
#import "WPThermometerRemoveViewModel.h"
#import "WPAlertPopupView.h"
#import "WPConnectDeviceManager.h"
#import "MMCDeviceManager.h"

@interface WPThermometerRemoveViewController ()
@property (nonatomic, strong) WPThermometerRemoveViewModel *viewModel;
@property (nonatomic ,strong) UILabel *detailLabel;
@property (nonatomic ,strong) UIImageView *iconView;
@property(nonatomic ,strong)UIButton *removeBtn;
@property (nonatomic, assign) BOOL removing;

@end

@implementation WPThermometerRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = kLocalization(@"thermometer_title");
    _removing = YES;
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState)  name:MMCNotificationKeyDeviceState object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionState)  name:MMCNotificationKeyDeviceConnectionState object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMCNotificationKeyDeviceState object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMCNotificationKeyDeviceConnectionState object:nil];
}


- (void)setupData{
    _viewModel = [[WPThermometerRemoveViewModel alloc] init];
}

- (void)setupViews{
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 124)/2, kNavigationHeight + kStatusHeight + 50, 124, 285)];
    _iconView.backgroundColor = [UIColor clearColor];
    _iconView.image = kImage(@"remove-bind-ima");
    [self.view addSubview:_iconView];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom + 36, kScreen_Width, 37)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = kColor_7_With_Alpha(0.8);
    _detailLabel.font = kFont_1(12);
    _detailLabel.text = kLocalization(@"noti_thermometer_noconnect");
    _detailLabel.numberOfLines = 2;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detailLabel];
    _removeBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 300)/2, _detailLabel.bottom + 16, 300, 45)];
    _removeBtn.backgroundColor = [UIColor clearColor];
    _removeBtn.layer.borderColor = kColor_8_With_Alpha(0.5).CGColor;
    _removeBtn.layer.borderWidth = 0.5;
    _removeBtn.titleLabel.font = kFont_1(15);
    [_removeBtn setTitle:kLocalization(@"thermometer_remove_bind") forState:UIControlStateNormal];
    [_removeBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
    [_removeBtn addTarget:self action:@selector(removeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeBtn];
}

- (void)removeBtnPressed{
    MJWeakSelf;
    WPAlertPopupView *popView = [[WPAlertPopupView alloc] init];
    popView.title = kLocalization(@"noti_remove_thermometer");
    popView.cancelBlock = ^(MMPopupView *popupView) {
        
    };
    popView.confirmBlock = ^(MMPopupView *popupView, BOOL finished) {
        [weakSelf unbind];
    };
    popView.attachedView = self.navigationController.view;
    [popView showWithBlock:^(MMPopupView *popupView, BOOL finished) {
        
    }];
}

- (void)unbind{
    _removing = YES;
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
    [_viewModel unBindDeviceSuccess:^(BOOL finished) {
        if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE) {
            [[XJFHUDManager defaultInstance] hideLoading];
            if (finished) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)updateState{
    if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE && _removing) {
        [[XJFHUDManager defaultInstance] hideLoading];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)updateConnectionState{
    if ([MMCDeviceManager defaultInstance].deviceConnectionState == STATE_DEVICE_NONE && _removing) {
        [[XJFHUDManager defaultInstance] hideLoading];
        [self.navigationController popViewControllerAnimated:YES];
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
