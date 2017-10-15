//
//  WPRecordHeaderView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/20.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPRecordStatusModel.h"

@protocol WPRecordHeaderViewDelegate;
@interface WPRecordHeaderView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *triIcon;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, assign) BOOL showDetail;
@property (nonatomic, strong) WPRecordStatusModel *status;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id<WPRecordHeaderViewDelegate> delegate;

@end
@protocol WPRecordHeaderViewDelegate <NSObject>
@optional
- (void)showRecordHeader:(WPRecordHeaderView *)headerView;
- (void)swithBtnChanged:(WPRecordHeaderView *)headerView on:(BOOL)isOn;
@end
