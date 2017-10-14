//
//  WPStatusView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPStatusItemView.h"
#import "WPStatusWheelView.h"

@protocol WPStatusViewDelegate;
@interface WPStatusView : UIView<WPStatusWheelViewDelegate>
@property (nonatomic, strong) UIButton *calendarBtn;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *tempEditBtn;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *tempUnitLabel;
@property (nonatomic, strong) WPStatusItemView *indexView;
@property (nonatomic, strong) WPStatusItemView *timeView;
@property (nonatomic, strong) WPStatusItemView *recordView;
@property (nonatomic, strong) WPStatusWheelView *wheelView;
@property (nonatomic, assign) id<WPStatusViewDelegate> delegate;

@end
@protocol WPStatusViewDelegate <NSObject>
@optional
- (void)showCalendar;
- (void)showTemperature;
- (void)editTemperature;
- (void)showRecord;
@end
