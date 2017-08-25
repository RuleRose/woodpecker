//
//  CustUIButton.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFUIButton.h"

@implementation XJFUIButton

+ (XJFUIButton *)custCreateButton
{
    return [XJFUIButton custCreateButtonWithTitle:nil];
}

+ (XJFUIButton *)custCreateButtonWithTitle:(NSString *)title
{
    return [XJFUIButton custCreateButton:CGRectZero andTitle:title];
}

+ (XJFUIButton *)custCreateButton:(CGRect)frame andTitle:(NSString *)title
{
    return [XJFUIButton custCreateButton:frame andTitle:title andNormalImg:nil andHighlitedImg:nil];
}

+ (XJFUIButton *)custCreateButton:(CGRect)frame andTitle:(NSString *)title andNormalImg:(NSString *)normalImg andHighlitedImg:(NSString *)highlitedImg
{
    XJFUIButton *button = [[XJFUIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    if (nil != normalImg) {
        [button setImage:kImage(normalImg) forState:UIControlStateNormal];
    }
    if (nil != highlitedImg) {
        [button setImage:kImage(highlitedImg) forState:UIControlStateHighlighted];
    }
    
    return button;
}

/**
 *  设置统一属性
 */
- (void)setDefaultAttributes
{
    
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
