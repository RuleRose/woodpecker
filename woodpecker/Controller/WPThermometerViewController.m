//
//  WPThermometerViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerViewController.h"
#import "WPThermometerView.h"
#import "WPThermometerViewModel.h"
#import "WPThermometerClockViewController.h"
#import "WPThermometerUnitViewController.h"
#import "WPThermometerHardwareViewController.h"

@interface WPThermometerViewController ()<WPThermometerViewDelegate>
@property(nonatomic, strong) WPThermometerView *thermometerView;
@property(nonatomic, strong) WPThermometerViewModel *viewModel;
@end

@implementation WPThermometerViewController

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
    [self showStatusBar];
    [self setBackBarButton];
    [self showNavigationBar];

}

- (void)setupData{
    _viewModel = [[WPThermometerViewModel alloc] init];
}

- (void)setupViews{
    _thermometerView = [[WPThermometerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _thermometerView.backgroundColor = [UIColor clearColor];
    _thermometerView.delegate = self;
    [self.view addSubview:_thermometerView];
}

#pragma mark WPThermometerViewDelegate
- (void)removeBinding{

}

- (void)showThermometerClock{
    WPThermometerClockViewController *clockVC = [[WPThermometerClockViewController alloc] init];
    [self.navigationController pushViewController:clockVC animated:YES];
}

- (void)showThermometerUnit{
    WPThermometerUnitViewController *unitVC = [[WPThermometerUnitViewController alloc] init];
    [self.navigationController pushViewController:unitVC animated:YES];
}

- (void)showThermometerHardware{
    WPThermometerHardwareViewController *hardwareVC = [[WPThermometerHardwareViewController alloc] init];
    [self.navigationController pushViewController:hardwareVC animated:YES];
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
