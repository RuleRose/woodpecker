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
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7_With_Alpha(0.8);
    _titleLabel.font = kFont_1(12);
    [self.contentView addSubview:_titleLabel];
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
    [self.contentView addSubview:_selectionView];
    _line = [[UIView alloc] initWithFrame:CGRectMake(53, 0, kScreen_Width - 75, 0.5)];
    _line.backgroundColor = kColor_9_With_Alpha(0.1);
    [self.contentView addSubview:_line];
}

- (void)setTheme:(NSString *)theme{
    _theme = theme;
    _titleLabel.text = theme;
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    for (NSInteger i = 1; i <= titles.count; i ++) {
        NSString *title = [_titles objectAtIndex:(i - 1)];
        WPRecordSelectionButton *selectionBtn = [[WPRecordSelectionButton alloc] initWithFrame:CGRectMake(kScreen_Width - i*75 - 7, 8, 60, 25)];
        selectionBtn.layer.masksToBounds = YES;
        selectionBtn.layer.borderColor = kColor_7_With_Alpha(0.8).CGColor;
        selectionBtn.layer.borderWidth = 0.5;
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
        [self.contentView addSubview:selectionBtn];
    }
    _titleLabel.frame = CGRectMake(53, 0, kScreen_Width - _titles.count*75 - 7, 41);
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
