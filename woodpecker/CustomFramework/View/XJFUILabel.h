//
//  CustUILabel.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFUILabel : UILabel
+ (XJFUILabel *)custCreateLabel;
+ (XJFUILabel *)custCreateLabelWithText:(NSString *)text;
+ (XJFUILabel *)custCreateLabel:(CGRect)frame andText:(NSString *)text;
@end
