//
//  WPStatusWheelView.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPStatusViewModel.h"
#import "WPDayInfoInPeriod.h"

@protocol WPStatusWheelViewDelegate;
@interface WPStatusWheelView : UIControl
@property(nonatomic, strong)NSDate *startDate;
//@property(nonatomic, strong)WPStatusViewModel *viewModel;

@property(nonatomic, assign) id<WPStatusWheelViewDelegate> delegate;
- (void)updateData;
- (void)scrollToBottom;
@end
@protocol WPStatusWheelViewDelegate <NSObject>
@optional
- (void)showDetailDate:(NSDate *)date period:(WPDayInfoInPeriod *)period_day;
@end
