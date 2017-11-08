//
//  WPMyHeaderView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPMyHeaderView.h"

@implementation WPMyHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, self.width, 58)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7_With_Alpha(0.8);
    _titleLabel.font = kFont_1(14);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = kLocalization(@"me_title");
    [self addSubview:_titleLabel];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, kScreen_Width, 82)];
    _contentView.backgroundColor = kColor_10;
    [self addSubview:_contentView];
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 51, 51)];
    _avatar.backgroundColor = [UIColor clearColor];
    _avatar.image = kImage(@"btn-me-avatar");
    [_contentView addSubview:_avatar];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 15, 7, self.width, 38)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = kColor_7_With_Alpha(0.8);
    _nameLabel.font = kFont_3(16);
    _nameLabel.text = @"";
    [_contentView addSubview:_nameLabel];
    _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 15, _nameLabel.bottom, self.width, 32)];
    _accountLabel.backgroundColor = [UIColor clearColor];
    _accountLabel.textColor = kColor_7_With_Alpha(0.8);
    _accountLabel.font = kFont_1(12);
    _accountLabel.text = @"账号: ";
    [_contentView addSubview:_accountLabel];
    _triIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 32,  35, 7, 13)];
    _triIcon.backgroundColor = [UIColor clearColor];
    _triIcon.image = kImage(@"arrow-me");
    [_contentView addSubview:_triIcon];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_contentView addGestureRecognizer:tap];
}

- (void)setUserinfo:(WPUserModel *)userinfo{
    _userinfo = userinfo;
    _nameLabel.text = _userinfo.nick_name;
    NSString *account_id = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_ID);
    if (!account_id) {
        _accountLabel.text = @"账号: ";
    }else{
        _accountLabel.text = [NSString stringWithFormat:@"账号：%@",account_id];
    }
    [_avatar leie_imageWithUrlStr:_userinfo.avatar phImage:kImage(@"btn-me-avatar")];
}

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer{
//    CGPoint pos = [gestureRecognizer locationInView:_contentView];
//    if (CGRectContainsPoint(CGRectMake(0, 0, _avatar.width + 30, _contentView.height), pos)) {
//        if (_delegate && [_delegate respondsToSelector:@selector(selectedAvatar)]) {
//            [_delegate selectedAvatar];
//        }
//    }else{
//        if (_delegate && [_delegate respondsToSelector:@selector(selectedAccount)]) {
//            [_delegate selectedAccount];
//        }
//    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAccount)]) {
        [_delegate selectedAccount];
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
