//
//  WPPeriodModel.m
//  woodpecker
//
//  Created by QiWL on 2017/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPPeriodModel.h"

@implementation WPPeriodModel
+ (NSMutableArray *)mj_ignoredPropertyNames{
    return [[NSMutableArray alloc] initWithObjects:@"speculate",@"menstruation_lenth",@"period_lenth",@"oviposit",@"pregnancy_start",@"pregnancy_end", nil];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"breif":@"description"};
}
@end
