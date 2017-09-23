//
//  WPThermometerBindingViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerBindingViewController.h"
#import "WPThermometerBindingViewModel.h"

@interface WPThermometerBindingViewController ()
@property (nonatomic, strong) WPThermometerBindingViewModel *viewModel;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIImageView *iconView;

@end

@implementation WPThermometerBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_4;
    self.title = @"正在绑定";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
}

- (void)setupData{
    _viewModel = [[WPThermometerBindingViewModel alloc] init];
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 156, kScreen_Width, 20)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7;
    _titleLabel.font = kFont_1(12);
    _titleLabel.text = @"请打开体温计并靠近手机";
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
