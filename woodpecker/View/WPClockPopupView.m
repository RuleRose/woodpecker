//
//  WPClockPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/12.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPClockPopupView.h"

@interface WPClockPopupView()
@property (nonatomic, strong) UIDatePicker *timePicker;
@end

@implementation WPClockPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        self.titleView.backgroundColor = kColor_1;
        self.titleLabel.text = kLocalization(@"clock_wakeup_time");
        self.titleLabel.font = kFont_1(12);
        self.titleLabel.textColor = kColor_7;
        self.contentView.backgroundColor = kColor_9_With_Alpha(0.1);
    }
    return self;
}

- (void)setupViews{
    [super setupViews];
    _timePicker = [[UIDatePicker alloc] init];
    _timePicker.backgroundColor = kColor_1;
    _timePicker.datePickerMode = UIDatePickerModeCountDownTimer;
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
    if (_clockBlock) {
        _clockBlock(self, _timePicker.date);
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
