//
//  WPSelectionPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"

@implementation WPSelectionPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        self.backgroundColor = kColor_10;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(392);
        }];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = kColor_1;
    [self addSubview:_titleView];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7;
    _titleLabel.font = kFont_1(12);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_titleLabel];
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = kColor_1;
    [self addSubview:_contentView];
    _handleView = [[UIView alloc] init];
    _handleView.backgroundColor = kColor_1;
    [self addSubview:_handleView];
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderColor = kColor_9_With_Alpha(0.15).CGColor;
    _cancelBtn.layer.borderWidth = 0.5;
    _cancelBtn.backgroundColor = kColor_10;
    [_cancelBtn setTitle:kLocalization(@"common_cancel") forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = kFont_1(12);
    [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_handleView addSubview:_cancelBtn];
    
    _confirmBtn = [[UIButton alloc] init];
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.layer.borderColor = kColor_9_With_Alpha(0.15).CGColor;
    _confirmBtn.layer.borderWidth = 0.5;
    _confirmBtn.backgroundColor = kColor_10;
    [_confirmBtn setTitle:kLocalization(@"common_confirm") forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = kFont_1(12);
    [_confirmBtn addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_handleView addSubview:_confirmBtn];
    MJWeakSelf;
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@64);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.handleView.mas_top);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    [_handleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@92);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@23);
        make.left.equalTo(@24);
        make.right.equalTo(weakSelf.confirmBtn.mas_left).offset(0.5);
        make.width.equalTo(weakSelf.confirmBtn.mas_width);
        make.height.equalTo(@40);
    }];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@23);
        make.right.equalTo(@(-24));
        make.left.equalTo(weakSelf.confirmBtn.mas_left).offset(0.5);
        make.width.equalTo(weakSelf.confirmBtn.mas_width);
        make.height.equalTo(@40);
    }];
}

- (MMPopupBlock)sheetShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        if ( !self.superview )
        {
            [self.attachedView.mm_dimBackgroundView addSubview:self];
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.attachedView);
                make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
            }];
            [self.superview layoutIfNeeded];
        }
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(0);
                             }];
                             
                             [self.superview layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)sheetHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
                             }];
                             
                             [self.superview layoutIfNeeded];

                         }
                         completion:^(BOOL finished) {
                             
                             if ( finished )
                             {
                                 [self removeFromSuperview];
                             }
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self, finished);
                             }
                             
                         }];
    };
    
    return block;
}

- (void)cancelBtnPressed{
    [self hide];
}

- (void)confirmBtnPressed{
    [self hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
