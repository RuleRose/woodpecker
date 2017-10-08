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

- (void)setTheme:(WPRecordTheme)theme{
    _theme = theme;
    _titleLabel.text = [_viewModel getThemeWithRecordTheme:theme];
    _selectedIndex = [_viewModel getDetailIndexWithRecordTheme:theme];
    _details = [_viewModel getTitlesWithRecordTheme:theme];
}

- (void)drawCellWithSize:(CGSize)size{
    for (UIView *subView in _selectionView.subviews) {
        [subView removeFromSuperview];
    }
    if (_details.count < _column) {
        _column = _details.count;
    }
    if (_column <= 0) {
        return;
    }
    CGFloat originX = size.width - _column * 75 - 7;;
    CGFloat originY = 8;
    for (NSInteger i = 0; i < _details.count; i ++) {
        NSString *title = [_details objectAtIndex:i];
        CGFloat x = originX + (i%_column) * 75;
        CGFloat y = originY +  41*((NSInteger)(i/_column));
        WPRecordSelectionButton *selectionBtn = [[WPRecordSelectionButton alloc] initWithFrame:CGRectMake(x, y, 60, 25)];
        selectionBtn.layer.masksToBounds = YES;
        selectionBtn.layer.borderColor = kColor_7_With_Alpha(0.8).CGColor;
        selectionBtn.layer.borderWidth = 0.5;
        selectionBtn.titleLabel.font = kFont_1(12);
        [selectionBtn setTitle:title forState:UIControlStateNormal];
        selectionBtn.index = i;
        if (_selectedIndex == i) {
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

- (void)resetDetails{
    for (UIView *subView in _selectionView.subviews) {
        if ([subView isKindOfClass:[WPRecordSelectionButton class]]) {
            WPRecordSelectionButton *selectionBtn = (WPRecordSelectionButton *)subView;
            if (_selectedIndex == selectionBtn.index) {
                [selectionBtn setTitleColor:kColor_10 forState:UIControlStateNormal];
                selectionBtn.backgroundColor = kColor_7_With_Alpha(0.8);
            }else{
                [selectionBtn setTitleColor:kColor_7_With_Alpha(0.8) forState:UIControlStateNormal];
                selectionBtn.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

- (void)selectionBtnPressed:(WPRecordSelectionButton *)sender{
    if (sender.index == _selectedIndex) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectTheme:index:cell:)]) {
            [_delegate selectTheme:_theme index:-1 cell:self];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(selectTheme:index:cell:)]) {
            [_delegate selectTheme:_theme index:sender.index cell:self];
        }
    }

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
