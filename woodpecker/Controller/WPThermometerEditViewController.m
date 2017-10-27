//
//  WPThermometerEditViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPThermometerEditViewController.h"
#import "WPThermometerEditViewModel.h"
#import "WPNetInterface.h"
#import "NSDate+ext.h"

@interface WPThermometerEditViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) WPThermometerEditViewModel *viewModel;
@end

@implementation WPThermometerEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    self.title = @"添加基础体温";
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    
}

- (void)setupData{
    if (!_temperature) {
        _temperature = [[WPTemperatureModel alloc] init];
    }
    if (!_date) {
        _date = [NSDate date];
    }
    _viewModel = [[WPThermometerEditViewModel alloc] init];
}

- (void)setupViews{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, kNavigationHeight + kStatusHeight + 12, kScreen_Width - 40, 40)];
    _textField.backgroundColor = kColor_10;
    _textField.textColor = kColor_7;
    _textField.font = kFont_1(12);
    _textField.placeholder = @"请输入基础体温";
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    _textField.leftView = leftView;
    UILabel *rightView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    rightView.text = @"°C";
    rightView.textAlignment = NSTextAlignmentCenter;
    rightView.textColor = kColor_7;
    rightView.font = kFont_1(12);
    _textField.rightView = rightView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_textField];
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(56, _textField.bottom + 100, (kScreen_Width - 120)/2, 48)];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = kColor_9_With_Alpha(0.15).CGColor;
    _cancelBtn.layer.borderWidth = 0.5;
    [_cancelBtn setTitle:kLocalization(@"common_cancel") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = kFont_1(12);
    [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(_cancelBtn.right + 8, _textField.bottom + 100, (kScreen_Width - 120)/2, 48)];
    _saveBtn.backgroundColor = [UIColor clearColor];
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.borderColor = kColor_9_With_Alpha(0.15).CGColor;
    _saveBtn.layer.borderWidth = 0.5;
    [_saveBtn setTitle:kLocalization(@"common_save") forState:UIControlStateNormal];
    [_saveBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = kFont_1(12);
    [_saveBtn addTarget:self action:@selector(saveBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBtn];
    
    
}

- (void)cancelBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveBtnPressed{
    NSString *temp = _textField.text;
    if (![NSString leie_isBlankString:temp]) {
        _temperature.sync = @"1";
        _temperature.temp = temp;
        NSString *dateStr = [NSString stringWithFormat:@"%@ 23:59:59",[NSDate stringFromDate:_date]];
        NSDate *date = [NSDate dateFromString:dateStr format:@"yyyy MM dd HH:mm:ss"];
        _temperature.time = [NSString stringWithFormat:@"%f",[date timeIntervalSince2000]];
        [_viewModel syncTemp:_temperature success:^(BOOL success) {
            [self.navigationController popViewControllerAnimated:YES];

        }];
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
