//
//  WPLoginView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginView.h"
@interface WPLoginView () <TTTAttributedLabelDelegate>

@end
@implementation WPLoginView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _iconView = [[UIImageView  alloc] initWithFrame:CGRectMake((kScreen_Width - 81)/2, kScreen_Height/2 - 121, 81, 81)];
    _iconView.backgroundColor = [UIColor clearColor];
    _iconView.image = kImage(@"ima-logon");
    [self addSubview:_iconView];
    _agreementLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom + 36, kScreen_Width, 20)];
    _agreementLabel.backgroundColor = [UIColor clearColor];
    _agreementLabel.textColor = kColor_7_With_Alpha(0.8);
    _agreementLabel.font = kFont_1(12);
    _agreementLabel.textAlignment = NSTextAlignmentCenter;
    _agreementLabel.delegate = self;
    _agreementLabel.extendsLinkTouchArea = YES;
    NSDictionary* linkAttributes = @{ (NSString*)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:YES], (__bridge NSString*)kCTForegroundColorAttributeName : (__bridge id)[kColor_11 CGColor] };
    _agreementLabel.linkAttributes = linkAttributes;
    _agreementLabel.activeLinkAttributes = linkAttributes;
    _agreementLabel.inactiveLinkAttributes = linkAttributes;
    _agreementLabel.text = kLocalization(@"login_agreement");
    NSRange linkRange = NSMakeRange([_agreementLabel.text length] - 9, 9);
    [_agreementLabel addLinkToURL:nil withRange:linkRange];
    [_agreementLabel addLinkToTransitInformation:nil withRange:linkRange];
    [self addSubview:_agreementLabel];

    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 300)/2, kScreen_Height - 99, 300, 45)];
    _loginBtn.backgroundColor = kColor_5;
    _loginBtn.layer.borderColor = kColor_8.CGColor;
    _loginBtn.layer.borderWidth = 0.5;
    _loginBtn.titleLabel.font = kFont_1(15);
    [_loginBtn setTitle:kLocalization(@"login_btn") forState:UIControlStateNormal];
    [_loginBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
}

- (void)loginBtnPressed{
    if (_delegate && [_delegate respondsToSelector:@selector(login)]) {
        [_delegate login];
    }
}

- (void)attributedLabel:(TTTAttributedLabel*)label didSelectLinkWithTransitInformation:(NSDictionary*)components{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
