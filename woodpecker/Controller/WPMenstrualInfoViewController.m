//
//  WPMenstrualInfoViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMenstrualInfoViewController.h"

@interface WPMenstrualInfoViewController ()
@property (nonatomic ,strong) UILabel *detailLabel;
@property (nonatomic ,strong) UIImageView *iconView;
@end

@implementation WPMenstrualInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_10;
    self.title = @"周期长度";
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
}

- (void)setupViews{
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, 225*kScreen_Width/375.0)];
    _iconView.backgroundColor = [UIColor clearColor];
    _iconView.image = kImage(@"ima-info-menstrual");
    [self.view addSubview:_iconView];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _iconView.bottom + 68, kScreen_Width - 30, 80)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = kColor_7_With_Alpha(0.8);
    _detailLabel.font = kFont_1(12);
    _detailLabel.text = @"月经期指：从月经第一天到月经最后一天为止，通常为2-7天。";
    _detailLabel.numberOfLines = 0;
    [self.view addSubview:_detailLabel];
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
