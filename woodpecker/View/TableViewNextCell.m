//
//  TableViewNextCell.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "TableViewNextCell.h"

@implementation TableViewNextCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 8, 25, 25)];
    _icon.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_icon];
    _triIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 32,  14, 7, 13)];
    _triIcon.backgroundColor = [UIColor clearColor];
    _triIcon.image = kImage(@"arrow-me");
    [self.contentView addSubview:_triIcon];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.right + 13, 0, (_triIcon.left - _icon.right - 30)/2, 41)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = kColor_7_With_Alpha(0.8);
    _titleLabel.font = kFont_1(12);
    [self.contentView addSubview:_titleLabel];
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 7, 0, (_triIcon.left - _icon.right - 30)/2, 41)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = kColor_7;
    _detailLabel.font = kFont_1(12);
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detailLabel];
    _line = [[UIView alloc] initWithFrame:CGRectMake(23, 0, kScreen_Width - 45, 0.5)];
    _line.backgroundColor = kColor_9_With_Alpha(0.1);
    [self.contentView addSubview:_line];
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
