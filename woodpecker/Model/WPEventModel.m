//
//  WPEventModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPEventModel.h"

@implementation WPEventModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"pid":@"event_id", @"detail":@"description"};
}
@end
