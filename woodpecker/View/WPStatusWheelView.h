//
//  WPStatusWheelView.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPStatusWheelViewDelegate;
@interface WPStatusWheelView : UIView
@property(nonatomic, strong)NSDate *startDate;
@property(nonatomic, assign) id<WPStatusWheelViewDelegate> delegate;

@end
@protocol WPStatusWheelViewDelegate <NSObject>
@optional
- (void)showDetailDate:(NSDate *)date;
@end
