//
//  WPThermometerBindViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerBindViewController.h"

@interface WPThermometerBindViewController ()
@property(nonatomic ,strong)UIImageView *iconView;
@property(nonatomic ,strong)UIButton *bindBtn;
@property(nonatomic ,strong)UIButton *cancelBtn;
@end

@implementation WPThermometerBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupViews{
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)]
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
