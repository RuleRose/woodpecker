//
//  WPInfoSettingCell.m
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPInfoSettingCell.h"
@interface WPInfoSettingCell () <UITextFieldDelegate>
@end

@implementation WPInfoSettingCell
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
    _titleLabel.textColor = kColor_7_With_Alpha(0.5);
    _titleLabel.font = kFont_1(12);
    [self.contentView addSubview:_titleLabel];
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textColor = kColor_7;
    _textField.font = kFont_1(12);
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_textField];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = kColor_9_With_Alpha(0.1);
    [self.contentView addSubview:_line];
}

- (void)drawCellWithSize:(CGSize)size{
    _titleLabel.frame = CGRectMake(15, 0, (size.width - 30)/2 , size.height);
    _textField.frame = CGRectMake(_titleLabel.right, 0, _titleLabel.width, size.height);
    _line.frame = CGRectMake(14, 0, size.width - 28, 0.5);

}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidBeginEditing:cell:)]) {
        [_delegate textFieldDidBeginEditing:textField cell:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(textFieldDidEndEditing:cell:)]) {
        [_delegate textFieldDidEndEditing:textField cell:self];
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
