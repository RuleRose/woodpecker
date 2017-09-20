//
//  WPRecordStatusModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/20.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordStatusModel.h"

@implementation WPRecordStatusModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _showDetail = NO;
        _showSwitch = NO;
        _onlyTitle = NO;
        _showLine = YES;
        _showDetailEnable = YES;
    }
    return self;
}
@end
