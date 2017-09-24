//
//  WPInfoSettingCell.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPInfoSettingCellDelegate;
@interface WPInfoSettingCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) id<WPInfoSettingCellDelegate> delegate;
- (void)drawCellWithSize:(CGSize)size;
@end

@protocol WPInfoSettingCellDelegate <NSObject>
@optional
- (void)textFieldDidBeginEditing:(UITextField*)textField cell:(WPInfoSettingCell*)cell;
- (void)textFieldDidEndEditing:(UITextField*)textField cell:(WPInfoSettingCell*)cell;
@end
