//
//  WPPickerItemView.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPickerItemView.h"

@implementation WPPickerItemView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = kColor_9;
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.font = kFont_3(18);
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
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
