//
//  WPMyHeaderView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPUserModel.h"

@protocol MyInfoHeaderViewDelegate;
@interface WPMyHeaderView : UIView
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIImageView *avatar;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *accountLabel;
@property(nonatomic, strong) UIImageView *triIcon;
@property(nonatomic, strong) WPUserModel *userinfo;

@property(nonatomic, assign) id<MyInfoHeaderViewDelegate> delegate;

@end
@protocol MyInfoHeaderViewDelegate <NSObject>
@optional
- (void)selectedAvatar;
- (void)selectedAccount;
@end
