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
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kFont_2(20);
        [self.contentView addSubview:label];
        self.textLabel = label;
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setPeriod_type:(PeriodType)period_type{
    _period_type = period_type;
    switch (_period_type) {
        case kPeriodTypeOfForecast:
            self.backgroundColor = kColor_10;
            self.layer.borderColor = kColor_15.CGColor;

            break;
        case kPeriodTypeOfOviposit:
            self.backgroundColor = kColor_15;
            self.layer.borderColor = kColor_15.CGColor;
            break;
        case kPeriodTypeOfMenstrual:
            self.backgroundColor = kColor_13;
            self.layer.borderColor = kColor_13.CGColor;
            break;
        case kPeriodTypeOfPregnancy:
            self.backgroundColor = kColor_14_With_Alpha(0.1);
            self.layer.borderColor = kColor_14_With_Alpha(0.1).CGColor;
            break;
        case kPeriodTypeOfSafe:
            self.backgroundColor = kColor_10;
            self.layer.borderColor = kColor_10.CGColor;
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = self.frame.size.width/10;

    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _textLabel.font = kFont_2(20*self.frame.size.width/56.0);
}
@end
