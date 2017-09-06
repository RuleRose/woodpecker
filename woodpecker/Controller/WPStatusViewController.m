//
//  WPStatusViewController.m
//  woodpecker
//
//  Created by yongche on 17/9/3.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusViewController.h"
#import "WPAccountManager.h"

@interface WPStatusViewController ()
@property(nonatomic, strong) XJFUIButton *button1;
@property(nonatomic, strong) XJFUIButton *button2;
@property(nonatomic, strong) XJFUIButton *button3;
@end

@implementation WPStatusViewController

- (XJFUIButton *)button1 {
    if (!_button1) {
        _button1 = [[XJFUIButton alloc] init];
        [_button1 setTitle:@"1" forState:UIControlStateNormal];
        [_button1 setBackgroundColor:kRandom_Color];
        _button1.tag = 1;
    }
    return _button1;
}

- (XJFUIButton *)button2 {
    if (!_button2) {
        _button2 = [[XJFUIButton alloc] init];
        [_button2 setTitle:@"2" forState:UIControlStateNormal];
        [_button2 setBackgroundColor:kRandom_Color];
        _button2.tag = 2;
    }
    return _button2;
}

- (XJFUIButton *)button3 {
    if (!_button3) {
        _button3 = [[XJFUIButton alloc] init];
        [_button3 setTitle:@"3" forState:UIControlStateNormal];
        [_button3 setBackgroundColor:kRandom_Color];
        _button3.tag = 3;
    }
    return _button3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData {
    [self.button1 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(buttonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupView {
    self.navigationController.navigationBar.translucent = NO;

    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    @weakify(self);
    [self.button1 mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.top.right.left.equalTo(self.view);
      make.height.mas_equalTo(20);
    }];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.top.equalTo(self.button1.mas_bottom);
      make.right.left.equalTo(self.view);
      make.height.mas_equalTo(20);
    }];
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.top.equalTo(self.button2.mas_bottom);
      make.right.left.equalTo(self.view);
      make.height.mas_equalTo(20);
    }];
}

- (void)buttonClickHandler:(UIButton *)sender {
    switch (sender.tag) {
        case 1: {
            [[WPAccountManager defaultInstance] login];
            break;
        }
        case 2: {
            if ([[WPAccountManager defaultInstance] isLogin]) {
                DDLogDebug(@"is login");
            } else {
                DDLogDebug(@"not login");
            }
            break;
        }
        case 3: {
            [[WPAccountManager defaultInstance] logout];
            break;
        }
        default:
            break;
    }
}

@end
