//
//  WPThermometerBindViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerBindViewController.h"
#import "WPThermometerBindingViewController.h"

@interface WPThermometerBindViewController ()
@property(nonatomic ,strong)UIImageView *iconView;
@property(nonatomic ,strong)UIButton *bindBtn;
@property(nonatomic ,strong)UIButton *cancelBtn;
@property(nonatomic ,strong)UILabel *titleLabel;
@end

@implementation WPThermometerBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_4;
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, kScreen_Width, 24)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7_With_Alpha(0.8);
    _titleLabel.font = kFont_1(14);
    _titleLabel.text = kLocalization(@"thermometer_bind");
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];

    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 184)/2, 131, 184, 315)];
    _iconView.backgroundColor = [UIColor clearColor];
    _iconView.image = kImage(@"bind-ima");
    [self.view addSubview:_iconView];
    _bindBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 300)/2, _iconView.bottom + 49, 300, 45)];
    _bindBtn.backgroundColor = [UIColor clearColor];
    _bindBtn.layer.borderColor = kColor_8_With_Alpha(0.8).CGColor;
    _bindBtn.layer.borderWidth = 0.5;
    _bindBtn.titleLabel.font = kFont_1(12);
    [_bindBtn setTitle:kLocalization(@"thermometer_bind_start") forState:UIControlStateNormal];
    [_bindBtn setTitleColor:kColor_9_With_Alpha(0.8) forState:UIControlStateNormal];
    [_bindBtn addTarget:self action:@selector(bindBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindBtn];
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 100)/2, _bindBtn.bottom + 12, 100, 32)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    _cancelBtn.titleLabel.font = kFont_1(12);
    [_cancelBtn setTitle:kLocalization(@"thermometer_bind_no") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kColor_9_With_Alpha(0.8) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
}

- (void)bindBtnPressed{
    WPThermometerBindingViewController *bindgingVC = [[WPThermometerBindingViewController alloc] init];
    [self.navigationController pushViewController:bindgingVC animated:YES];
}

- (void)cancelBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
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
