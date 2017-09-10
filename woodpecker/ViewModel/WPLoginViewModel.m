//
//  WPLoginViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLoginViewModel.h"
#import "WPAccountManager.h"

@implementation WPLoginViewModel
- (void)login{
    [[WPAccountManager defaultInstance] login];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
