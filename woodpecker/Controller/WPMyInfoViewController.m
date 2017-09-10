//
//  WPMyInfoViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMyInfoViewController.h"
#import "WPMyInfoView.h"
#import "WPMyInfoViewModel.h"

@interface WPMyInfoViewController ()<WPMyInfoViewDelegate>
@property(nonatomic, strong) WPMyInfoView *infoView;
@property(nonatomic, strong) WPMyInfoViewModel *viewModel;

@end

@implementation WPMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideNavigationBar];
}

- (void)setupData{
    _viewModel = [[WPMyInfoViewModel alloc] init];
}

- (void)setupViews{
    _infoView = [[WPMyInfoView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _infoView.backgroundColor = [UIColor clearColor];
    _infoView.delegate = self;
    [self.view addSubview:_infoView];
}

#pragma mark WPMyInfoViewDelegate
- (void)selectedAvatar{
    NSLog(@"selectedAvatar");
}

- (void)selectedAccount{
    NSLog(@"selectedAccount");

}

- (void)selectedBasic{
    NSLog(@"selectedBasic");

}

- (void)selectedCycle{
    NSLog(@"selectedCycle");

}

- (void)selectedShop{
    NSLog(@"selectedShop");

}

- (void)selectedAbout{
    NSLog(@"selectedAbout");

}

- (void)selectedHelp{
    NSLog(@"selectedHelp");

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
