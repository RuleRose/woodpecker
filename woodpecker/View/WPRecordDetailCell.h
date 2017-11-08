//
//  WPRecordDetailCell.h
//  woodpecker
//
//  Created by QiWL on 2017/9/20.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPRecordViewModel.h"

@protocol WPRecordDetailCellDelegate;
@interface WPRecordDetailCell : UITableViewCell
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSArray *details;
@property(nonatomic, strong) NSArray *detailTitles;
@property(nonatomic, assign) WPRecordTheme theme;
@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UIView *selectionView;
@property(nonatomic, assign) NSInteger column;
@property(nonatomic, assign) BOOL mixselection;
@property(nonatomic, strong) NSIndexPath* indexPath;
@property(nonatomic, strong) WPRecordViewModel *viewModel;
@property(nonatomic, assign) id<WPRecordDetailCellDelegate> delegate;

- (void)drawCellWithSize:(CGSize)size;
- (void)resetDetails;
@end
@protocol WPRecordDetailCellDelegate <NSObject>
@optional
- (void)selectTheme:(WPRecordTheme)theme detail:(NSString *)detail cell:(WPRecordDetailCell *)cell;
@end
