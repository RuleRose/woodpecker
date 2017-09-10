//
//  WPMyInfoView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPMyInfoViewDelegate;
@interface WPMyInfoView : UIView
@property(nonatomic, assign) id<WPMyInfoViewDelegate> delegate;

@end
@protocol WPMyInfoViewDelegate <NSObject>
@optional
- (void)selectedAvatar;
- (void)selectedAccount;
- (void)selectedBasic;
- (void)selectedCycle;
- (void)selectedShop;
- (void)selectedAbout;
- (void)selectedHelp;
@end
