//
//  WPRecordDetailCell.m
//  woodpecker
//
//  Created by QiWL on 2017/9/20.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordDetailCell.h"
#import "WPRecordSelectionButton.h"

@implementation WPRecordDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _column = 3;
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _selectionView = [[UIView alloc] init];
    _selectionView.backgroundColor = [UIColor clearColor];
    _selectionView.layer.masksToBounds = YES;
    [self.contentView addSubview:_selectionView];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7_With_Alpha(0.8);
    _titleLabel.font = kFont_1(12);
    [self.contentView addSubview:_titleLabel];
    _line = [[UIView alloc] initWithFrame:CGRectMake(53, 0, kScreen_Width - 75, 0.5)];
    _line.backgroundColor = kColor_9_With_Alpha(0.1);
    [self.contentView addSubview:_line];
}

- (void)setTheme:(NSString *)theme{
    _theme = theme;
    _titleLabel.text = theme;
}

- (void)drawCellWithSize:(CGSize)size{
    for (UIView *subView in _selectionView.subviews) {
        [subView removeFromSuperview];
    }
    if (_titles.count < _column) {
        _column = _titles.count;
    }
    if (_column <= 0) {
        return;
    }
    CGFloat originX = size.width - _column * 75 - 7;;
    CGFloat originY = 8;
    for (NSInteger i = 0; i < _titles.count; i ++) {
        NSString *title = [_titles objectAtIndex:i];
        CGFloat x = originX + (i%_column) * 75;
        CGFloat y = originY +  41*((NSInteger)(i/_column));
        WPRecordSelectionButton *selectionBtn = [[WPRecordSelectionButton alloc] initWithFrame:CGRectMake(x, y, 60, 25)];
        selectionBtn.layer.masksToBounds = YES;
        selectionBtn.layer.borderColor = kColor_7_With_Alpha(0.8).CGColor;
        selectionBtn.layer.borderWidth = 0.5;
        selectionBtn.titleLabel.font = kFont_1(12);
        [selectionBtn setTitle:title forState:UIControlStateNormal];
        [selectionBtn setTitle:title forState:UIControlStateNormal];
        if ([title isEqualToString:_selectedTitle]) {
            [selectionBtn setTitleColor:kColor_10 forState:UIControlStateNormal];
            selectionBtn.backgroundColor = kColor_7_With_Alpha(0.8);
            
        }else{
            [selectionBtn setTitleColor:kColor_7_With_Alpha(0.8) forState:UIControlStateNormal];
            selectionBtn.backgroundColor = [UIColor clearColor];
        }
        [selectionBtn addTarget:self action:@selector(selectionBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_selectionView addSubview:selectionBtn];
    }
    _titleLabel.frame = CGRectMake(53, 0, size.width - _column*75 - 60, 41);
    _selectionView.frame = CGRectMake(0, 0, size.width, size.height);

}

- (void)selectionBtnPressed:(WPRecordSelectionButton *)sender{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
