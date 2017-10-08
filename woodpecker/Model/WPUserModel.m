//
//  WPUserModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPUserModel.h"

@implementation WPUserModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"pid":@"user_id"};
}
@end
