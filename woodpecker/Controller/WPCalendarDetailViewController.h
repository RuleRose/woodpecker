//
//  WPCalendarDetailViewController.h
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseViewController.h"

@protocol WPCalendarDetailDelegate;
@interface WPCalendarDetailViewController : XJFBaseViewController
@property(nonatomic,strong)NSDate *selectedDate;
@property(nonatomic, assign) id<WPCalendarDetailDelegate> delegate;

@end
@protocol WPCalendarDetailDelegate <NSObject>
@optional
- (void)updateSelectedDate:(NSDate *)date;
@end
