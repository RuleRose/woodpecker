//
//  UIColor+Hex.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (leie_Hex)

//根据16进制颜色值和alpha值生成UIColor
+ (UIColor *)leie_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

//根据16进制颜色值和alpha为1生成UIColor
+ (UIColor *)leie_colorWithHex:(UInt32)hex;

//根据16进制颜色字符串生成UIColor
// hexString 支持格式为 OxAARRGGBB / 0xRRGGBB / #AARRGGBB / #RRGGBB / AARRGGBB / RRGGBB
+ (UIColor *)leie_colorWithHexString:(NSString *)hexString;
+ (UIColor *)leie_colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;

//返回当前对象的16进制颜色值
- (UInt32)leie_hexValue;

@end
