//
//  CustUITextField.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFUITextField.h"

@implementation XJFUITextField
+ (XJFUITextField *)custCreateTxtField
{
    return [XJFUITextField custCreateTxtField:CGRectZero placeHolder:nil];
}

+ (XJFUITextField *)custCreateTxtField:(CGRect)frame placeHolder:(NSString *)placeHolder
{
    XJFUITextField *textField = [[XJFUITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    return textField;
}

/**
 *  设置统一属性
 */
- (void)setDefaultAttributes
{
    self.font = kFont15;
    self.backgroundColor = kClear;
    self.textAlignment = NSTextAlignmentLeft;
}

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        [self setDefaultAttributes];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setDefaultAttributes];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setDefaultAttributes];
        
    }
    
    return self;
}
@end
