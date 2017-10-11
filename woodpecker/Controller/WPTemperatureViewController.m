//
//  WPTemperatureRecordViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureViewController.h"
#import "WPTemperatureViewModel.h"
#import "WPLineView.h"
#import "WPTemperatureDetailView.h"

@interface WPTemperatureViewController ()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *switchBtn;
@property(nonatomic, strong) WPLineView *lineView;
@property(nonatomic, strong) WPTemperatureViewModel *viewModel;
@property(nonatomic, strong) WPTemperatureDetailView *lineDetailView;
@end

@implementation WPTemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    [self setupData];
    [self setupViews];
    [_lineView updateChartData];
    [_lineDetailView.lineView updateChartData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_lineView updateChartData];
    [_lineDetailView.lineView updateChartData];
}

- (void)setupData{
    _viewModel = [[WPTemperatureViewModel alloc] init];
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreen_Width, 44)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7;
    _titleLabel.font = kFont_1(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"体温曲线";
    [self.view addSubview:_titleLabel];
    _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 64, 18, 64, 44)];
    _switchBtn.backgroundColor = [UIColor clearColor];
    [_switchBtn setImage:kImage(@"btn-navi-landscape") forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(switchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchBtn];
    _lineView = [[WPLineView alloc] initWithFrame:CGRectMake(32, 111, kScreen_Width - 64, kScreen_Width - 64)];
    _lineView.backgroundColor = [UIColor clearColor];
    _lineView.showCount = 7;
    [self.view addSubview:_lineView];
    _lineDetailView = [[WPTemperatureDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _lineDetailView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:_lineDetailView];
    _lineDetailView.hidden = YES;
}

- (void)switchBtnPressed{
    _lineDetailView.hidden = !_lineDetailView.hidden;
    if (!_lineDetailView.hidden) {
        [_lineDetailView.lineView updateChartData:_viewModel.temps];
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
