//
//  NSString+JSON.h
//  woodpecker
//
//  Created by QiWL on 2017/11/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
/**
 *  转换成JSON串字符串（没有可读性）
 *
 *  @return JSON字符串
 */
+ (NSString *)getJSONString:(NSDictionary *)dic;

/**
 *  转换成JSON串字符串（有可读性）
 *
 *  @return JSON字符串
 */
+ (NSString *)getReadableJSONString:(NSDictionary *)dic;
/**
 *  转换成NSDictionary
 *
 *  @return NSDictionary数据
 */
+ (NSDictionary *)getDictionary:(NSString *)jsonStr;
@end
