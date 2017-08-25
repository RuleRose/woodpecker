//
//  UITableViewCell+roundCorner.m
//  unicorn
//
//  Created by 肖君 on 16/12/17.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "UITableViewCell+roundCorner.h"

/**
 *  同一个section是一个圆角背景，并且section中的cell有分界线。
 */

@implementation UITableViewCell (roundCorner)
- (void)addRoundCornerOfIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.f;

        self.backgroundColor = UIColor.clearColor;

        CAShapeLayer *layer = [[CAShapeLayer alloc] init];

        CGMutablePathRef pathRef = CGPathCreateMutable();

        CGRect bounds = CGRectInset(self.bounds, 6, 0);

        BOOL addLine = NO;

        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);

        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));

            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);

            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);

            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));

            addLine = YES;

        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));

            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);

            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);

            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));

        } else {
            CGPathAddRect(pathRef, nil, bounds);

            addLine = YES;
        }

        layer.path = pathRef;

        CFRelease(pathRef);

        //颜色修改

        layer.fillColor = [UIColor whiteColor].CGColor;

        layer.strokeColor = [UIColor whiteColor].CGColor;

        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];

            CGFloat lineHeight = 1.f;  //(1.f / [UIScreen mainScreen].scale);

            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds) + 10, bounds.size.height - lineHeight, bounds.size.width - 10 - 10, lineHeight);

            lineLayer.backgroundColor = kColor_2_With_Alpha(0.3).CGColor;

            [layer addSublayer:lineLayer];
        }

        UIView *testView = [[UIView alloc] initWithFrame:bounds];

        [testView.layer insertSublayer:layer atIndex:0];

        testView.backgroundColor = UIColor.clearColor;

        self.backgroundView = testView;
    }
}
@end
