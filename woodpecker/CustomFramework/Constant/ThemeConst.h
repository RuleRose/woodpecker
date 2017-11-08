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
#define kColorFromRGBA(rgbValue, alpha) [UIColor leie_colorWithHex:rgbValue andAlpha:alpha]
#define kColorFromRGB(rgbValue) kColorFromRGBA(rgbValue, 1.0f)

/**************************颜色**************************************/
#define kColor_NavigationBar kColorFromRGB(0xffc905)
#define kColor_Text1 kColorFromRGB(0x333333)
#define kColor_Text2 kColorFromRGB(0x666666)
#define kColor_Text3 kColorFromRGB(0x999999)
#define kColor_Text4 kColorFromRGB(0xffffff)
#define kColor_Text5 kColorFromRGB(0x54b3c5)
#define kColor_Button1 kColorFromRGB(0xffc905)
#define kColor_Button2 kColorFromRGB(0xffefb4)
#define kColor_Highlight_Button3 kColorFromRGB(0xcca004)

#define kColor_1 kColor_1_With_Alpha(1.0)
#define kColor_1_With_Alpha(alpha) kRGBA_Color(248, 248, 248, alpha)

#define kColor_2 kColor_2_With_Alpha(1.0)
#define kColor_2_With_Alpha(alpha) kRGBA_Color(247, 247, 247, alpha)

#define kColor_3 kColor_3_With_Alpha(1.0)
#define kColor_3_With_Alpha(alpha) kRGBA_Color(239, 239, 239, alpha)

#define kColor_4 kColor_4_With_Alpha(1.0)
#define kColor_4_With_Alpha(alpha) kRGBA_Color(255, 233, 231, alpha)

#define kColor_5 kColor_5_With_Alpha(1.0)
#define kColor_5_With_Alpha(alpha) kRGBA_Color(251, 148, 140, alpha)

#define kColor_6 kColor_6_With_Alpha(1.0)
#define kColor_6_With_Alpha(alpha) kRGBA_Color(191, 191, 192, alpha)

#define kColor_7 kColor_7_With_Alpha(1.0)
#define kColor_7_With_Alpha(alpha) kRGBA_Color(111, 101, 104, alpha)

#define kColor_8 kColor_8_With_Alpha(1.0)
#define kColor_8_With_Alpha(alpha) kRGBA_Color(52, 53, 53, alpha)

#define kColor_9 kColor_9_With_Alpha(1.0)
#define kColor_9_With_Alpha(alpha) kRGBA_Color(0, 0, 0, alpha)

#define kColor_10 kColor_10_With_Alpha(1.0)
#define kColor_10_With_Alpha(alpha) kRGBA_Color(255, 255, 255, alpha)

#define kColor_11 kColor_11_With_Alpha(1.0)
#define kColor_11_With_Alpha(alpha) kRGBA_Color(34, 23, 152, alpha)

#define kColor_12 kColor_12_With_Alpha(1.0)
#define kColor_12_With_Alpha(alpha) kRGBA_Color(17, 10, 104, alpha)

#define kColor_13 kColor_13_With_Alpha(1.0)
#define kColor_13_With_Alpha(alpha) kRGBA_Color(253, 191, 183, alpha)

#define kColor_14 kColor_14_With_Alpha(1.0)
#define kColor_14_With_Alpha(alpha) kRGBA_Color(73, 124, 121, alpha)

#define kColor_15 kColor_15_With_Alpha(1.0)
#define kColor_15_With_Alpha(alpha) kRGBA_Color(250, 114, 58, alpha)

#define kColor_16 kColor_16_With_Alpha(1.0)
#define kColor_16_With_Alpha(alpha) kRGBA_Color(35, 24, 21, alpha)

#define kColor_17 kColor_17_With_Alpha(1.0)
#define kColor_17_With_Alpha(alpha) kRGBA_Color(254, 231, 228, alpha)

#define kColor_18 kColor_18_With_Alpha(1.0)
#define kColor_18_With_Alpha(alpha) kRGBA_Color(162, 162, 253, alpha)

#define kColor_19 kColor_19_With_Alpha(1.0)
#define kColor_19_With_Alpha(alpha) kRGBA_Color(237, 114, 98, alpha)

#define COLOR_STATUS_BAR kColor_5
#define COLOR_NAVI_BAR kColor_5

/****************************字体大小***********************************/

#define kFont_1(size) [UIFont systemFontOfSize:size]
#define kFont_2(size) [UIFont systemFontOfSize:size]
#define kFont_3(size) [UIFont systemFontOfSize:size]
#define kFont_4(size) [UIFont systemFontOfSize:size]
#define kFont_5(size) [UIFont systemFontOfSize:size]
#define kFont_6(size) [UIFont systemFontOfSize:size]


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

#define kCorner_radio 5
#endif /* ThemeConst_h */
