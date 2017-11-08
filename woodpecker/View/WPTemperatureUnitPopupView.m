//
//  WPTemperatureUnitPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureUnitPopupView.h"
@interface WPTemperatureUnitPopupView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *markView;

@end

@implementation WPTemperatureUnitPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.titleView.backgroundColor = kColor_1;
        self.titleLabel.text = @"单位";
        self.titleLabel.font = kFont_1(12);
        self.titleLabel.textColor = kColor_7;
        self.contentView.backgroundColor = kColor_9_With_Alpha(0.1);
    }
    
    return self;
}

- (void)setupViews{
    [super setupViews];
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = kColor_1;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.contentView addSubview:_pickerView];
    _markView = [[UIView alloc] init];
    _markView.backgroundColor = kColor_5;
    [self.contentView addSubview:_markView];
    MJWeakSelf;
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        make.left.equalTo(@6);
        make.right.equalTo(@0);
    }];
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.equalTo(@6);
        make.height.equalTo(@55);
    }];
}


#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"华氏度°F";
    }else{
        return @"摄氏度°C";
    }
}

#pragma mark UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* titleLabel = (UILabel*)view;
    if (!titleLabel){
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kColor_9;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = kFont_3(18);
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return titleLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return pickerView.frame.size.width/2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 53;
}

- (void)cancelBtnPressed{
    [super cancelBtnPressed];
}

- (void)confirmBtnPressed{
    [self hideWithBlock:^(MMPopupView *popupView, BOOL finished) {
        NSInteger unit = [_pickerView selectedRowInComponent:0];
        if (_unitBlock) {
            _unitBlock(self, unit);
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
