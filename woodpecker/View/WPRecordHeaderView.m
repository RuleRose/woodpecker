//
//  WPRecordHeaderView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/20.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordHeaderView.h"

@implementation WPRecordHeaderView
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _icon.backgroundColor = [UIColor clearColor];
    }
    return _icon;
}

- (UIImageView *)triIcon{
    if (!_triIcon) {
        _triIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 13)];
        _triIcon.backgroundColor = [UIColor clearColor];
        _triIcon.image = kImage(@"arrow-me");
    }
    return _triIcon;
}

- (UISwitch*)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 31, 18)];
        _switchView.backgroundColor = [UIColor clearColor];
        _switchView.onTintColor = kColorFromRGB(0x60b0e3);
        _switchView.tintColor = kColorFromRGB(0xdcdcdc);
    }
    return _switchView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showDetail = NO;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7_With_Alpha(0.8);
    _titleLabel.font = kFont_1(12);
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = kColor_7;
    _detailLabel.font = kFont_1(12);
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_detailLabel];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = kColor_9_With_Alpha(0.1);
    [self addSubview:_line];
    [self addSubview:self.icon];
    [self addSubview:self.switchView];
    [self addSubview:self.triIcon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
}

- (void)tap{
    if (_status.showDetailEnable && _delegate && [_delegate respondsToSelector:@selector(showRecordHeader:)]) {
        _status.showDetail = !_showDetail;
        self.showDetail = _status.showDetail;
        [_delegate showRecordHeader:self];
    }
}

- (void)setShowSwitch:(BOOL)showSwitch{
    _showSwitch = showSwitch;
    _icon.frame = CGRectMake(25, (self.height - 22)/2, 22, 22);
    if (showSwitch) {
        _triIcon.hidden = YES;
        _switchView.hidden = NO;
        _switchView.frame = CGRectMake(self.width - 56, (self.height - 31)/2, 51, 31);
        _switchView.transform = CGAffineTransformMakeScale(18/31.0, 31/51.0);
        _titleLabel.frame = CGRectMake(_icon.right + 12, 0, (_switchView.left - _icon.right - 30)/2, self.height);
        _detailLabel.frame = CGRectMake(_titleLabel.right + 8, 0, _titleLabel.width, self.height);
    }else{
        _triIcon.hidden = NO;
        _switchView.hidden = YES;
        _triIcon.frame = CGRectMake(self.width - 32, (self.height - 13)/2, 7, 13);
        _titleLabel.frame = CGRectMake(_icon.right + 12, 0, (_triIcon.left - _icon.right - 30)/2, self.height);
        _detailLabel.frame = CGRectMake(_titleLabel.right + 8, 0, _titleLabel.width, self.height);
        
    }
    _line.frame = CGRectMake(23, 0, self.width - 45, 0.5);
}

- (void)setShowDetail:(BOOL)showDetail{
    if (_showDetail != showDetail) {
        _showDetail = showDetail;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (_showDetail) {
                                 _triIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
                             }else{
                                 _triIcon.transform = CGAffineTransformIdentity;
                             }
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        if (_showDetail) {
            _triIcon.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            _triIcon.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)setStatus:(WPRecordStatusModel *)status{
    _status = status;
    self.showSwitch = _status.showSwitch;
    self.showDetail = _status.showDetail;
    self.titleLabel.text = _status.title;
    self.detailLabel.text = _status.detail;
    self.icon.image= kImage(_status.icon);
    _line.hidden = !_status.showLine;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
