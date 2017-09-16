//
//  WPCalendarNote.h
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPCalendarNote : UIView
@property(nonatomic, strong) UIView *colorNote;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) PeriodType period;
@end
