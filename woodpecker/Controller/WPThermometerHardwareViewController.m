//
//  WPThermometerHardwareViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerHardwareViewController.h"
#import "WPThermometerHardwareView.h"
#import "WPThermometerHardwareViewModel.h"

@interface WPThermometerHardwareViewController ()<WPThermometerHardwareViewDelegate>
@property(nonatomic, strong) WPThermometerHardwareView *thermometerView;
@property(nonatomic, strong) WPThermometerHardwareViewModel *viewModel;
@end

@implementation WPThermometerHardwareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"硬件信息";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showStatusBar];
    [self setBackBarButton];
    [self showNavigationBar];
    
}

- (void)setupData{
    _viewModel = [[WPThermometerHardwareViewModel alloc] init];
}

- (void)setupViews{
    _thermometerView = [[WPThermometerHardwareView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _thermometerView.backgroundColor = [UIColor clearColor];
    _thermometerView.delegate = self;
    [self.view addSubview:_thermometerView];
}

#pragma mark WPThermometerHardwareViewDelegate


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
