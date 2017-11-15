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
        label.font = kFont_2(18);
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
        case kPeriodTypeOfForecastStart:
        case kPeriodTypeOfForecastEnd:
            self.backgroundColor = kColor_10;
            self.layer.borderColor = kColor_15.CGColor;
            _textLabel.backgroundColor = kColor_10;

            break;
        case kPeriodTypeOfOviposit:
            self.backgroundColor = kColor_15;
            self.layer.borderColor = kColor_15.CGColor;
            _textLabel.backgroundColor = kColor_10;

            break;
        case kPeriodTypeOfMenstrual:
        case kPeriodTypeOfMenstrualStart:
        case kPeriodTypeOfMenstrualEnd:
            self.backgroundColor = kColor_10;
            self.layer.borderColor = kColor_13.CGColor;
            _textLabel.backgroundColor = kColor_13;

            break;
        case kPeriodTypeOfPregnancy:
        case kPeriodTypeOfPregnancyStart:
        case kPeriodTypeOfPregnancyEnd:
            self.backgroundColor = kColor_10;
            self.layer.borderColor = kColor_14_With_Alpha(0.1).CGColor;
            _textLabel.backgroundColor = kColor_14_With_Alpha(0.1);

            break;
        case kPeriodTypeOfSafe:
            self.backgroundColor = kColor_10;
            self.layer.borderColor = kColor_17.CGColor;
            _textLabel.backgroundColor = kColor_17;

            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = self.frame.size.width/10;

    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _textLabel.font = kFont_2(18*self.frame.size.width/56.0);
}
@end
