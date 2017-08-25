//
//  CustUITextView.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import "XJFUITextView.h"

@implementation XJFUITextView
+ (XJFUITextView *)custCreateTextView
{
    return [XJFUITextView custCreateTextView:CGRectZero];
}

+ (XJFUITextView *)custCreateTextView:(CGRect)frame
{
    XJFUITextView *textView = [[XJFUITextView alloc] initWithFrame:frame];
    return textView;
}
/**
 *  设置统一属性
 */
- (void)setDefaultAttributes {
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultAttributes];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setDefaultAttributes];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setDefaultAttributes];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self setDefaultAttributes];
    }
    return self;
}

@end
