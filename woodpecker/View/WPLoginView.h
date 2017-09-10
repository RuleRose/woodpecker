//
//  WPLoginView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@protocol WPLoginViewDelegate;
@interface WPLoginView : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) TTTAttributedLabel* agreementLabel;
@property (nonatomic, assign) id<WPLoginViewDelegate> delegate;

@end
@protocol WPLoginViewDelegate <NSObject>
@optional
- (void)login;
@end
