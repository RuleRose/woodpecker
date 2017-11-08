//
//  WPStatusWheelCell.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPStatusWheelCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *textLabel;
@property(nonatomic, assign) PeriodType period_type;
@property(nonatomic, strong) NSDate *date;

@end

