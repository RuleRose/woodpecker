//
//  WPTemperatureInfoViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/11/11.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureInfoViewController.h"

@interface WPTemperatureInfoViewController ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSArray *imageArr;
@end

@implementation WPTemperatureInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"体温曲线图例";
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
}

- (void)setupViews{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + kStatusHeight, kScreen_Width, kScreen_Height - (kNavigationHeight + kStatusHeight))];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    _imageArr = @[@"ima-curve"];
    CGFloat y = 0;
    UIView *tempView = nil;
    for (NSString *imageStr in _imageArr) {
        UIImage *image = kImage(imageStr);
        CGSize imageSize = image.size;
        CGFloat height = 0;
        if (imageSize.width != 0) {
            height = kScreen_Width*imageSize.height/imageSize.width;
        }
        UIImageView *measurement = [[UIImageView alloc] init];
        measurement.backgroundColor = [UIColor clearColor];
        measurement.image = image;
        [_scrollView addSubview:measurement];
        if (tempView) {
            [measurement mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.width.equalTo(@(kScreen_Width));
                make.top.equalTo(tempView.mas_bottom);
                make.height.equalTo(@(height));
            }];
        }else{
            [measurement mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@0);
                make.top.equalTo(@0);
                make.width.equalTo(@(kScreen_Width));
                make.height.equalTo(@(height));
            }];
        }
        tempView = measurement;
        y += height;
    }
    _scrollView.contentSize = CGSizeMake(kScreen_Width, y);
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
