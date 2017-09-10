//
//  WPStatusView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusView.h"
@implementation WPStatusView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 33, 33)];
    _calendarBtn.backgroundColor = [UIColor clearColor];
    [_calendarBtn setImage:kImage(@"btn-navi-status-cale") forState:UIControlStateNormal];
    [_calendarBtn addTarget:self action:@selector(calendarBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_calendarBtn];
    _tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 53, 20, 33, 33)];
    _tempBtn.backgroundColor = [UIColor clearColor];
    [_tempBtn setImage:kImage(@"btn-navi-device-con") forState:UIControlStateNormal];
    [_tempBtn addTarget:self action:@selector(tempBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tempBtn];
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 320, self.width - 50, 33)];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = kColor_7;
    _dateLabel.font = kFont_2(23);
    _dateLabel.text = @"6月7日";
    [self addSubview:_dateLabel];
    _periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, _dateLabel.bottom, self.width - 50, 35)];
    _periodLabel.backgroundColor = [UIColor clearColor];
    _periodLabel.textColor = kColor_7;
    _periodLabel.font = kFont_2(23);
    _periodLabel.text = @"安全期";
    [self addSubview:_periodLabel];
    _tempLabel = [[UILabel alloc] init];
    _tempLabel.backgroundColor = [UIColor clearColor];
    _tempLabel.textColor = kColor_7;
    _tempLabel.font = kFont_4(84);
    _tempLabel.text = @"36.50";
    [self addSubview:_tempLabel];
    _tempUnitLabel = [[UILabel alloc] init];
    _tempUnitLabel.backgroundColor = [UIColor clearColor];
    _tempUnitLabel.textColor = kColor_7;
    _tempUnitLabel.font = kFont_2(23);
    _tempUnitLabel.text = @"°C";
    [self addSubview:_tempUnitLabel];
    _tempEditBtn = [[UIButton alloc] init];
    _tempEditBtn.backgroundColor = [UIColor clearColor];
    [_tempEditBtn setImage:kImage(@"icon-status-edit") forState:UIControlStateNormal];
    [_tempEditBtn addTarget:self action:@selector(tempEditBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tempEditBtn];
    
    CGSize size = [@"36.50" sizeWithFont:kFont_4(84)];
    _tempLabel.frame = CGRectMake(25, _periodLabel.bottom, size.width, 106);
    _tempUnitLabel.frame = CGRectMake(_tempLabel.right + 12, _tempLabel.top + 14, 40, 38);
    _tempEditBtn.frame = CGRectMake(_tempLabel.right + 12, _tempUnitLabel.bottom, 33, 33);
    _indexView = [[WPStatusItemView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 170, (kScreen_Width - 125)/2, 80)];
    _indexView.backgroundColor = [UIColor clearColor];
    [self addSubview:_indexView];
    _timeView = [[WPStatusItemView alloc] initWithFrame:CGRectMake(_indexView.right, kScreen_Height - 170, 125, 80)];
    _timeView.backgroundColor = [UIColor clearColor];
    [self addSubview:_timeView];
    _recordView = [[WPStatusItemView alloc] initWithFrame:CGRectMake(_timeView.right, kScreen_Height - 170, (kScreen_Width - 125)/2, 80)];
    _recordView.backgroundColor = [UIColor clearColor];
    [self addSubview:_recordView];
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(_indexView.right, _indexView.top + 16, 0.5, 47)];
    leftLine.backgroundColor = kColor_9_With_Alpha(0.1);
    [self addSubview:leftLine];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(_timeView.right, _indexView.top + 16, 0.5, 47)];
    rightLine.backgroundColor = kColor_9_With_Alpha(0.1);
    [self addSubview:rightLine];
    
    [_indexView setTitle:@"受孕指数" detail:@"4" unit:@"%"];
    [_timeView setTitle:@"距离易孕期" detail:@"2" unit:@"天"];
    [_recordView setTitle:@"记录" detail:@"3" unit:@"项"];

}

- (void)calendarBtnPressed{

}

- (void)tempBtnPressed{

}

- (void)tempEditBtnPressed{

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
