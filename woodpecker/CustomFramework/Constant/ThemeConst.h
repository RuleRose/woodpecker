//
//  ThemeConst.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/6.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#ifndef ThemeConst_h
#define ThemeConst_h
#import "UIColor+Hex.h"

/*****************************************************************************************/
#pragma mark - 颜色宏
#define kClear [UIColor clearColor]
#define kBlack [UIColor blackColor]
#define kWhite [UIColor whiteColor]
#define kRed [UIColor redColor]
#define kOrange [UIColor orangeColor]
#define kRGB_Color(r, g, b) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:1.f]
#define kRGBA_Color(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define kRandom_Color (kRGB_Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256)))

/**************************颜色**************************************/
#define kColor_1 kColor_1_With_Alpha(1.0)
#define kColor_1_With_Alpha(alpha) [UIColor leie_colorWithHex:0xf8f8f8 andAlpha:alpha]
#define kColor_2 kColor_2_With_Alpha(1.0)
#define kColor_2_With_Alpha(alpha) [UIColor leie_colorWithHex:0xf7f7f7 andAlpha:alpha]
#define kColor_3 kColor_3_With_Alpha(1.0)
#define kColor_3_With_Alpha(alpha) [UIColor leie_colorWithHex:0xefefef andAlpha:alpha]
#define kColor_4 kColor_4_With_Alpha(1.0)
#define kColor_4_With_Alpha(alpha) [UIColor leie_colorWithHex:0xffe9e7 andAlpha:alpha]
#define kColor_5 kColor_5_With_Alpha(1.0)
#define kColor_5_With_Alpha(alpha) [UIColor leie_colorWithHex:0xfb948c andAlpha:alpha]
#define kColor_6 kColor_6_With_Alpha(1.0)
#define kColor_6_With_Alpha(alpha) [UIColor leie_colorWithHex:0xbfbfc0 andAlpha:alpha]
#define kColor_7 kColor_7_With_Alpha(1.0)
#define kColor_7_With_Alpha(alpha) [UIColor leie_colorWithHex:0x6f6568 andAlpha:alpha]
#define kColor_8 kColor_8_With_Alpha(1.0)
#define kColor_8_With_Alpha(alpha) [UIColor leie_colorWithHex:0x343535 andAlpha:alpha]
#define kColor_9 kColor_9_With_Alpha(1.0)
#define kColor_9_With_Alpha(alpha) [UIColor leie_colorWithHex:0x000000 andAlpha:alpha]
#define kColor_10 kColor_10_With_Alpha(1.0)
#define kColor_10_With_Alpha(alpha) [UIColor leie_colorWithHex:0xffffff andAlpha:alpha]
#define kColor_11 kColor_11_With_Alpha(1.0)
#define kColor_11_With_Alpha(alpha) [UIColor leie_colorWithHex:0x221798 andAlpha:alpha]

#define COLOR_STATUS_BAR kColor_5
#define COLOR_NAVI_BAR kColor_5

/****************************字体大小***********************************/

#define kFont6 [UIFont systemFontOfSize:6]
#define kFont9 [UIFont systemFontOfSize:9]
#define kFont10 [UIFont systemFontOfSize:10]
#define kFont11 [UIFont systemFontOfSize:11]
#define kFont12 [UIFont systemFontOfSize:12]
#define kFont13 [UIFont systemFontOfSize:13]
#define kFont14 [UIFont systemFontOfSize:14]
#define kFont15 [UIFont systemFontOfSize:15]
#define kFont16 [UIFont systemFontOfSize:16]
#define kBoldFont16 [UIFont boldSystemFontOfSize:16]
#define kFont17 [UIFont systemFontOfSize:17]
#define kFont19 [UIFont systemFontOfSize:19]
#define kBoldFont19 [UIFont boldSystemFontOfSize:19]
#define kFont20 [UIFont systemFontOfSize:20]
#define kBoldFont20 [UIFont boldSystemFontOfSize:20]
#define kFont25 [UIFont systemFontOfSize:25]
#define kFont33 [UIFont systemFontOfSize:33]
#define kBoldFont33 [UIFont boldSystemFontOfSize:33]
#define kFont50 [UIFont systemFontOfSize:50]
#define kFont58 [UIFont systemFontOfSize:58]

#define kFontHeight6 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont6}].height)
#define kFontHeight9 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont9}].height)
#define kFontHeight10 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont10}].height)
#define kFontHeight11 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont11}].height)
#define kFontHeight12 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont12}].height)
#define kFontHeight13 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont13}].height)
#define kFontHeight14 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont14}].height)
#define kFontHeight15 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont15}].height)
#define kFontHeight16 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont16}].height)
#define kFontHeightBold16 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kBoldFont16}].height)
#define kFontHeight17 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont17}].height)
#define kFontHeight19 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont19}].height)
#define kFontHeightBold19 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kBoldFont19}].height)
#define kFontHeight20 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont20}].height)
#define kFontHeightBold20 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kBoldFont20}].height)
#define kFontHeight25 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont25}].height)
#define kFontHeight33 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont33}].height)
#define kFontHeight50 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont50}].height)
#define kFontHeight58 ([@"aqwyPW" sizeWithAttributes:@{NSFontAttributeName : kFont58}].height)

#endif /* ThemeConst_h */
