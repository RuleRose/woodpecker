//
//  CustUITextField.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJFUITextField : UITextField
+ (XJFUITextField *)custCreateTxtField;
+ (XJFUITextField *)custCreateTxtField:(CGRect)frame placeHolder:(NSString *)placeHolder;
@end
