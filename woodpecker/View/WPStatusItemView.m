//
//  WPStatusItemView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusItemView.h"

@implementation WPStatusItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 22)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7;
    _titleLabel.font = kFont_3(12);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, self.width, 57)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = kColor_7;
    _detailLabel.font = kFont_4(47);
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_detailLabel];
    _nextIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 15)];
    _nextIcon.image = kImage(@"arrow-status");
    [self addSubview:_nextIcon];
    _nextIcon.hidden = YES;
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail unit:(NSString *)unit showNext:(BOOL)showNext{
    _titleLabel.text = title;
    NSString *text = [NSString stringWithFormat:@"%@%@",detail,unit];
    if ([NSString leie_isBlankString:text]) {
        text = @"";
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedStr setAttributes:@{NSForegroundColorAttributeName: kColor_7, NSFontAttributeName: kFont_2(23)} range:NSMakeRange(detail.length, unit.length)];
    _detailLabel.attributedText = attributedStr;
    if (showNext) {
        CGSize size = [text sizeWithAttributes:@{NSForegroundColorAttributeName: kColor_7, NSFontAttributeName: kFont_4(47)}];
        _nextIcon.frame = CGRectMake((self.width + size.width)/2 - 6, _titleLabel.bottom + 28, 9, 15);
        _nextIcon.hidden = NO;
    }else{
        _nextIcon.hidden = YES;
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
