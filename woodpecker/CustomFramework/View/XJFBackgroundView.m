//
//  CustBackgroundView.m
//  unicorn
//
//  Created by 肖君 on 16/12/2.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "XJFBackgroundView.h"

@implementation XJFBackgroundView

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
        [self setBackgroundColor:kColor_4];
        [self.layer setCornerRadius:kCorner_radio];
        [self.layer setMasksToBounds:YES];
    }
    return self;
}
@end
