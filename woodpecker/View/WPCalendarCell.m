//
//  WPCalendarCell.m
//  woodpecker
//
//  Created by QiWL on 2017/9/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarCell.h"
#import "FSCalendarExtensions.h"

@implementation WPCalendarCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *markLayer = [[CALayer alloc] init];
        self.markLayer.backgroundColor = [UIColor clearColor].CGColor;
        markLayer.backgroundColor = [UIColor clearColor].CGColor;
        markLayer.cornerRadius = 11.5;
        markLayer.borderColor = [UIColor clearColor].CGColor;
        markLayer.borderWidth = 0.5;
        markLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:markLayer below:self.shapeLayer];
        markLayer.masksToBounds = YES;
        self.markLayer = markLayer;
        self.markLayer.hidden = YES;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.shapeLayer.hidden = NO;
    self.markLayer.hidden = NO;
    switch (_period) {
        case kPeriodTypeOfMenstrual:
            self.markLayer.backgroundColor = kColor_13.CGColor;
            self.markLayer.borderColor = kColor_13.CGColor;
            break;
        case kPeriodTypeOfPregnancy:
            self.markLayer.backgroundColor = kColor_14_With_Alpha(0.1).CGColor;
            self.markLayer.borderColor = kColor_14_With_Alpha(0.1).CGColor;
            break;
        case kPeriodTypeOfForecast:
            self.markLayer.backgroundColor = [UIColor clearColor].CGColor;
            self.markLayer.borderColor = kColor_15.CGColor;
            break;
        case kPeriodTypeOfOviposit:
            self.markLayer.backgroundColor = kColor_15.CGColor;
            self.markLayer.borderColor = kColor_15.CGColor;
            break;
    }
    CGFloat top = self.shapeLayer.frame.origin.y + (self.shapeLayer.frame.size.height - 23)/2;
    switch (_shape) {
        case kPeriodShapeOfRight:
            self.markLayer.frame = CGRectMake(-12, top, self.width + 12, 23);
            break;
        case kPeriodShapeOfLeft:
            self.markLayer.frame = CGRectMake(0, top, self.width + 12, 23);
            break;
        case kPeriodShapeOfSingle:
            self.markLayer.frame = CGRectMake(0, top, self.width, 23);
            break;
        case kPeriodShapeOfMiddle:
            self.markLayer.frame = CGRectMake(-12, top, self.width + 24, 23);
            break;
        case kPeriodShapeOfCircle:
            self.markLayer.frame = CGRectMake((self.width - 23)/2, top, 23, 23);
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
