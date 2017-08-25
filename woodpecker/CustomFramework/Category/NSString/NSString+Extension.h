//
//  NSString+Extension.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (leie_Characters)

#pragma mark - Category(leie_Characters)
- (CGSize)sizeWithFont:(UIFont *)font;

//汉字转换为拼音
- (NSString *)leie_pinyinOfName;

//汉字转换为拼音后，返回大写的首字母
- (NSString *)leie_firstCharacterOfName;

// 是否包含中文字符
- (BOOL)leie_containChinese;

@end

@interface NSString (leie_Kit)

#pragma mark - Category(leie_Kit)
/*
 忽略大小写
 */
/**
 *  @brief  转换成MD5字符串
 *
 *  @return MD5字符串
 */
- (NSString *)leie_MD5;

/**
 *  @brief  生成UUID
 *
 *  @return UUID字符串
 */
+ (NSString *)leie_UUID;

/**
 *  @brief  去除两端空格和回车
 *
 *  @return 去除后的字符串
 */
- (NSString *)leie_trim;

/**
 *  @brief  仅去除两端空格
 *
 *  @return 去除后的字符串
 */
- (NSString *)leie_trimOnlyWhitespace;

/**
 *  @brief  是否包含中文
 *
 *  @return YES/NO
 */
- (BOOL)leie_isIncludeChinese;

/**
 *  @brief  是否为空字符串
 *
 *  @return YES/NO
 */
+ (BOOL)leie_isBlankString:(NSString *)string;

/**
 *  如果为nil，返回""
 *
 *  @return ""
 */
+ (NSString *)leie_nilCheck:(NSString *)string;

/**
 *  @brief  空格分割字符串
 *
 *  @return 字符串数据
 */
- (NSArray *)leie_splitUsingWhitespace;

/**
 *  @brief  是否是合法的手机号码
 *
 *  @return 如果是合法的手机号码则返回YES；否则返回NO
 */
- (BOOL)leie_isVaildPhoneNumber;

/**
 *  @brief  判断是否是合法的QQ号码
 *
 *  @return 如果是合法的QQ号码，则返回YES；否则返回NO
 */
- (BOOL)leie_isVaildQQ;

@end

@interface NSString (leie_Size)

#pragma mark - Category(leie_Size)

/**
 *  @brief  获取要显示该文本的所需要的size
 *
 *  @param font 字体
 *
 *  @return 要显示文本所需size
 */
- (CGSize)leie_sizeWithFont:(UIFont *)font;

/**
 *  @brief 获取要显示该文本的所需要的size
 *
 *  @param size 限定大小，即返回的size不会超过这个所限定的大小
 *  @param font 字体
 *
 *  @return 要显示文本所需size
 */
- (CGSize)leie_sizeWithLimitSize:(CGSize)size font:(UIFont *)font;

/**
 *  @brief  获取要显示文本的所需的高度
 *
 *  @param width 限定的宽度
 *  @param font  字体
 *
 *  @return 文本所需高度
 */
- (CGFloat)leie_heightWithWidth:(CGFloat)width font:(UIFont *)font;

@end

#pragma mark - Category(leie_AutoUTF8Data)
@interface NSString (leie_AutoUTF8Data)
/**
 *  获取string的utf8编码的nsdata
 *
 *  @return data
 */
- (NSData *)leie_UTF8Data;
@end

#pragma mark - Category(leie_Assic)
@interface NSString (leie_Assic)
/**
 *  获取string的assic之和
 *
 *  @return data
 */
- (NSInteger)leie_sumOfAscii;
@end
