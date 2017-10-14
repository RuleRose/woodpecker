//
//  WPTemperatureViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureViewModel.h"

@implementation WPTemperatureViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _temps = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
