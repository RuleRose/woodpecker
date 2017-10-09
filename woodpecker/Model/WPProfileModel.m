//
//  WPProfileModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPProfileModel.h"

@implementation WPProfileModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"pid":@"profile_id"};
}
@end
