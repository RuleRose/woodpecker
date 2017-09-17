//
//  WPCalendarCell.h
//  woodpecker
//
//  Created by QiWL on 2017/9/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "FSCalendarCell.h"

@interface WPCalendarCell : FSCalendarCell
@property (weak, nonatomic) CALayer *markLayer;
@property(nonatomic, assign) PeriodType period;
@property(nonatomic, assign) PeriodShapeType shape;
@end
