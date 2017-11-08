//
//  WPStatusItemView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPStatusItemView : UIView
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@property(nonatomic, strong)UIImageView *nextIcon;
- (void)setTitle:(NSString *)title detail:(NSString *)detail unit:(NSString *)unit showNext:(BOOL)showNext;
@end
