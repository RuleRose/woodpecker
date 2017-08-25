//
//  CustSeperatorLineView.m
//  unicorn
//
//  Created by 肖君 on 16/12/2.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "XJFSeperatorLineView.h"

@implementation XJFSeperatorLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setBackgroundColor:kColor_2_With_Alpha(0.3)];
    }
    return self;
}
@end
