//
//  WPTableViewCell.h
//  woodpecker
//
//  Created by QiWL on 2017/9/11.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TableViewCellLeftModel) {
    kCellLeftModelNone = 0,
    kCellLeftModelIcon
};

typedef NS_ENUM(NSUInteger, TableViewCellRightModel) {
    kCellRightModelNone = 0,
    kCellRightModelNext,
    kCellRightModelImage,
    kCellRightModelImageNext,
    kCellRightModelSwitch
};

@protocol WPTableViewCellDelegate;
@interface WPTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UIImageView *triIcon;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, assign) TableViewCellLeftModel leftModel;
@property (nonatomic, assign) TableViewCellRightModel rightModel;
@property (nonatomic, assign) id<WPTableViewCellDelegate> delegate;
@property (nonatomic, assign) CGSize imageSize;

- (void)drawCellWithSize:(CGSize)size;
@end

@protocol WPTableViewCellDelegate <NSObject>
@optional
- (void)switchAction:(UISwitch*)sender cell:(WPTableViewCell*)cell;

@end
