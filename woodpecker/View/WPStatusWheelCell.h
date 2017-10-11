//
//  WPStatusWheelCell.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPStatusWheelCellDelegate;
@interface WPStatusWheelCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *textLabel;
@property(nonatomic, assign) PeriodType period_type;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, assign) id<WPStatusWheelCellDelegate> delegate;

@end
@protocol WPStatusWheelCellDelegate <NSObject>
@optional
- (void)showStatusCell:(WPStatusWheelCell *)cell;
@end
