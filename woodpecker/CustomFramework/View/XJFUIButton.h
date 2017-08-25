//
//  CustUIButton.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFUIButton : UIButton
+ (XJFUIButton *)custCreateButton;
+ (XJFUIButton *)custCreateButtonWithTitle:(NSString *)title;
+ (XJFUIButton *)custCreateButton:(CGRect)frame andTitle:(NSString *)title;
+ (XJFUIButton *)custCreateButton:(CGRect)frame andTitle:(NSString *)title andNormalImg:(NSString *)normalImg andHighlitedImg:(NSString *)highlitedImg;
@end
