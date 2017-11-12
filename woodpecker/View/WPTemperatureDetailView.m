//
//  WPTemperatureDetailView.m
//  woodpecker
//
//  Created by QiWL on 2017/10/9.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureDetailView.h"

@implementation WPTemperatureDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - self.height)/2, (self.height - self.width)/2, self.height, self.width)];
    _contentView.backgroundColor = kColor_2;
    [self addSubview:_contentView];
    _lineView = [[WPLineView alloc] initWithFrame:CGRectMake(30, 20, _contentView.width - 40, _contentView.height - 40)];
    _lineView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_lineView];
    _switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.width - 64, 18, 64, 44)];
    _switchBtn.backgroundColor = [UIColor clearColor];
    [_switchBtn setImage:kImage(@"btn-navi-landscape") forState:UIControlStateNormal];
    [_switchBtn addTarget:self action:@selector(switchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_switchBtn];
    _contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)switchBtnPressed{
    self.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
