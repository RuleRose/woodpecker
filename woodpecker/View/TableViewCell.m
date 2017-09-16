//
//  TableViewCell.m
//  woodpecker
//
//  Created by QiWL on 2017/9/11.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _icon.backgroundColor = [UIColor clearColor];
    }
    return _icon;
}

- (UIImageView *)triIcon{
    if (!_triIcon) {
        _triIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 13)];
        _triIcon.backgroundColor = [UIColor clearColor];
        _triIcon.image = kImage(@"arrow-me");
    }
    return _triIcon;
}

- (UISwitch*)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 31, 18)];
        _switchView.backgroundColor = [UIColor clearColor];
        _switchView.onTintColor = kColorFromRGB(0x60b0e3);
        _switchView.tintColor = kColorFromRGB(0xdcdcdc);
    }
    return _switchView;
}

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
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = kColor_7;
    _detailLabel.font = kFont_1(12);
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_detailLabel];

    _line = [[UIView alloc] init];
    _line.backgroundColor = kColor_9_With_Alpha(0.1);
    [self.contentView addSubview:_line];
    self.leftModel = kCellLeftModelNone;
    self.rightModel = kCellRightModelNone;

}

- (void)setLeftModel:(TableViewCellLeftModel)leftModel{
    _leftModel = leftModel;
    switch (leftModel) {
        case kCellLeftModelNone:
            if (_icon) {
                _icon.hidden = YES;
            }
            break;
        case kCellLeftModelIcon:
            [self.contentView addSubview:self.icon];
            self.icon.hidden = NO;
            break;
    }
}

- (void)setRightModel:(TableViewCellRightModel)rightModel{
    _rightModel = rightModel;
    switch (_rightModel) {
        case kCellRightModelNone:
            if (_triIcon) {
                _triIcon.hidden = YES;
            }
            if (_switchView) {
                _switchView.hidden = YES;
            }
            break;
        case kCellRightModelNext:
            [self.contentView addSubview:self.triIcon];
            self.triIcon.hidden = NO;
            break;
        case kCellRightModelSwitch:
            [self.contentView addSubview:self.switchView];
            self.switchView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)drawCellWithSize:(CGSize)size{
    CGFloat left = 0;
    CGFloat right = size.width;
    switch (_leftModel) {
        case kCellLeftModelNone:
            left = 25;
            break;
        case kCellLeftModelIcon:
            _icon.frame = CGRectMake(14, 8, 25, 25);
            left = _icon.right + 14;
            break;
        default:
            break;
    }
    switch (_rightModel) {
        case kCellRightModelNone:
            left = size.width - 25;
            break;
        case kCellRightModelNext:
            _triIcon.frame = CGRectMake(size.width - 32, (size.height - 13)/2, 7, 13);
            right = _triIcon.left - 10;
            break;
        case kCellRightModelSwitch:
            _switchView.frame = CGRectMake(size.width - 56, (size.height - 31)/2, 51, 31);
            _switchView.transform = CGAffineTransformMakeScale(18/31.0, 31/51.0);
            right = _switchView.left - 10;
            break;
        default:
            break;
    }
    _titleLabel.frame = CGRectMake(left, 0, (right - left - 8)/2, size.height);
    _detailLabel.frame = CGRectMake(_titleLabel.right + 8, 0, (right - left - 8)/2, size.height);
    _line.frame = CGRectMake(23, 0, size.width - 45, 0.5);
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
