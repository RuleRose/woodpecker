//
//  WPAlertPopupView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPAlertPopupView.h"
@interface WPAlertPopupView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation WPAlertPopupView
- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        self.backgroundColor = kColor_1;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kColor_7;
        _titleLabel.font = kFont_1(12);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        _confirmBtn = [[UIButton alloc] init];
        _confirmBtn.backgroundColor = kColor_10;
        [_confirmBtn setTitle:@"是" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = kFont_1(12);
        [_confirmBtn addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
        
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = kColor_10;
        [_cancelBtn setTitle:@"否" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColor_9 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = kFont_1(12);
        [_cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];

        MJWeakSelf;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(128);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@64);
        }];
        [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom);
            make.left.equalTo(@24);
            make.right.equalTo(weakSelf.cancelBtn.mas_left).offset(-0.5);
            make.height.equalTo(@40);

        }];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom);
            make.right.equalTo(@(-24));
            make.left.equalTo(weakSelf.confirmBtn.mas_right).offset(0.5);
            make.width.equalTo(weakSelf.confirmBtn.mas_width);
            make.height.equalTo(@40);
        }];

    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
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

- (void)cancelBtnPressed{
    if (_cancelBlock) {
        _cancelBlock(self);
    }
    [self hide];
}

- (void)confirmBtnPressed{
    if (_confirmBlock) {
        _confirmBlock(self,YES);
    }
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
