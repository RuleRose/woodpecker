//
//  WPTemperatureModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPTemperatureModel.h"

@implementation WPTemperatureModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _sync = @"0"; //0未上传 1已上传
    }
    return self;
}

+ (NSMutableArray *)mj_ignoredPropertyNames{
    return [[NSMutableArray alloc] initWithObjects:@"period_type", nil];
}
@end
