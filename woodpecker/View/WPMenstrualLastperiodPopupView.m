//
//  WPMenstrualLastperiodPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/10/9.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMenstrualLastperiodPopupView.h"
@interface WPMenstrualLastperiodPopupView()
@property (nonatomic, strong) UIDatePicker *timePicker;

@end
@implementation WPMenstrualLastperiodPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.titleView.backgroundColor = kColor_5;
        self.titleLabel.text = @"经期是否规律？";
        self.titleLabel.font = kFont_1(14);
        self.titleLabel.textColor = kColor_10;
        self.contentView.backgroundColor = kColor_9_With_Alpha(0.1);
    }
    
    return self;
}

- (void)setupViews{
    [super setupViews];
    _timePicker = [[UIDatePicker alloc] init];
    _timePicker.backgroundColor = kColor_1;
    _timePicker.datePickerMode = UIDatePickerModeDate;
    [self.contentView addSubview:_timePicker];
    [_timePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0.5);
        make.bottom.equalTo(@(-0.5));
        make.left.equalTo(@6);
        make.right.equalTo(@0);
    }];
}

- (void)cancelBtnPressed{
    [super cancelBtnPressed];
}

- (void)confirmBtnPressed{
    [super confirmBtnPressed];
    if (_lastperiodBlock) {
        _lastperiodBlock(self, _timePicker.date);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
