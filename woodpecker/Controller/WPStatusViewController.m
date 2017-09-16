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

@interface WPStatusViewController ()<WPStatusViewDelegate>
@property(nonatomic, strong) WPStatusView *statusView;
@property(nonatomic, strong) WPStatusViewModel *viewModel;

@end

@implementation WPStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self setupData];
    // Do any additional setup after loading the view.
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

#pragma mark WPStatusViewDelegate
- (void)showCalendar{
    WPCalendarViewController *calendarVC = [[WPCalendarViewController alloc] init];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

- (void)showTemperature{
    WPThermometerViewController *thermometerVC = [[WPThermometerViewController alloc] init];
    [self.navigationController pushViewController:thermometerVC animated:YES];
}

- (void)editTemperature{
    
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
