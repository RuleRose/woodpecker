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
#import "WPUserModel.h"
#import "WPStatusViewModel.h"

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
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) WPStatusViewModel *viewModel;
- (void)updateState;
@end
@protocol WPStatusViewDelegate <NSObject>
@optional
- (void)showCalendar;
- (void)showTemperature;
- (void)editTemperature;
- (void)showEventWithDate:(NSDate *)date;
@end
