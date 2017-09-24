//
//  WPSelectionPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>
@interface WPSelectionPopupView : MMPopupView
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
- (void)setupViews;
- (void)cancelBtnPressed;
- (void)confirmBtnPressed;
@end
