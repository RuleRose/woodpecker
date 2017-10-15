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

@interface WPThermometerRemoveViewController ()
@property (nonatomic, strong) WPThermometerRemoveViewModel *viewModel;
@property (nonatomic ,strong) UILabel *detailLabel;
@property (nonatomic ,strong) UIImageView *iconView;
@property(nonatomic ,strong)UIButton *removeBtn;
@end

@implementation WPThermometerRemoveViewController

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
    _detailLabel.text = @"尚未连接体温计\n无法获得体温计相关数据";
    _detailLabel.numberOfLines = 2;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_detailLabel];
    _removeBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 300)/2, _detailLabel.bottom + 16, 300, 45)];
    _removeBtn.backgroundColor = [UIColor clearColor];
    _removeBtn.layer.borderColor = kColor_8_With_Alpha(0.5).CGColor;
    _removeBtn.layer.borderWidth = 0.5;
    _removeBtn.titleLabel.font = kFont_1(15);
    [_removeBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [_removeBtn setTitleColor:kColor_8 forState:UIControlStateNormal];
    [_removeBtn addTarget:self action:@selector(removeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeBtn];
}

- (void)removeBtnPressed{
    WPAlertPopupView *popView = [[WPAlertPopupView alloc] init];
    popView.title = @"确定解除体温计绑定？";
    popView.cancelBlock = ^(MMPopupView *popupView) {
        
    };
    popView.confirmBlock = ^(MMPopupView *popupView, BOOL finished) {
        [_viewModel unBindDeviceSuccess:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
