//
//  CustUIImageView.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFUIImageView.h"

@implementation XJFUIImageView
+ (XJFUIImageView *)custCreateImageView
{
    return [XJFUIImageView custCreateImageView:CGRectZero];
}

+ (XJFUIImageView *)custCreateImageView:(CGRect)frame
{
    XJFUIImageView *imageView = [[XJFUIImageView alloc] initWithFrame:frame];
    return imageView;
}

/**
 *  设置统一属性
 */
- (void)setDefaultAttributes
{
    self.contentMode = UIViewContentModeScaleToFill;
    self.backgroundColor = kClear;
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

-(instancetype)initWithImage:(UIImage *)image
{
    self=[super initWithImage:image];
    if (self)
    {
        [self setDefaultAttributes];
        
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self=[super initWithImage:image highlightedImage:highlightedImage];
    if (self)
    {
        [self setDefaultAttributes];
        
    }
    return self;
}
@end
