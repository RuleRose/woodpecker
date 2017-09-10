//
//  WPTemperatureRecordViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureRecordViewController.h"
#import "WPTemperatureRecordView.h"
#import "WPTemperatureRecordViewModel.h"

@interface WPTemperatureRecordViewController ()<WPTemperatureRecordViewDelegate>
@property(nonatomic, strong) WPTemperatureRecordView *recordView;
@property(nonatomic, strong) WPTemperatureRecordViewModel *viewModel;
@end

@implementation WPTemperatureRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)setupData{
    _viewModel = [[WPTemperatureRecordViewModel alloc] init];
}

- (void)setupViews{
    _recordView = [[WPTemperatureRecordView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _recordView.backgroundColor = [UIColor clearColor];
    _recordView.delegate = self;
    [self.view addSubview:_recordView];
}

#pragma mark WPTemperatureRecordViewDelegate


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
