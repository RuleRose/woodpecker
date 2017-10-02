//
//  WPStatusWheelCell.m
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusWheelCell.h"

@implementation WPStatusWheelCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColor_10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        self.textLabel = label;
        self.contentView.backgroundColor = kColor_13;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = kColor_13.CGColor;
        self.contentView.layer.borderWidth = 2.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width/2;
    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
