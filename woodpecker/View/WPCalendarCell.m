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
        
//        CALayer *selectionLayer = [[CALayer alloc] init];
//        selectionLayer.backgroundColor = [UIColor orangeColor].CGColor;
//        selectionLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
//        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
//        self.selectionLayer = selectionLayer;
//        
//        CALayer *middleLayer = [[CALayer alloc] init];
//        middleLayer.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3].CGColor;
//        middleLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
//        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
//        self.middleLayer = middleLayer;
//        
//        // Hide the default selection layer
//        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.titleLabel.frame = self.contentView.bounds;
//}
//
//- (void)layoutSublayersOfLayer:(CALayer *)layer
//{
//    [super layoutSublayersOfLayer:layer];
//    self.selectionLayer.frame = self.contentView.bounds;
//    self.middleLayer.frame = self.contentView.bounds;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
