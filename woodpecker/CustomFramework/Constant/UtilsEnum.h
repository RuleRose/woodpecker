//
//  UtilsEnum.h
//  easyMeasure
//
//  Created by qiwl on 2017/6/9.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#ifndef UtilsEnum_h
#define UtilsEnum_h
typedef NS_ENUM(NSUInteger, PeriodType) {
    kPeriodTypeOfMenstrual = 0, //月经期
    kPeriodTypeOfPregnancy, //易孕期
    kPeriodTypeOfForecast, //预测经期
    kPeriodTypeOfOviposit, //排卵日
    kPeriodTypeOfSafe //安全期
};
typedef NS_ENUM(NSUInteger, PeriodShapeType) {
    kPeriodShapeOfRight = 0,
    kPeriodShapeOfLeft,
    kPeriodShapeOfMiddle,
    kPeriodShapeOfSingle,
    kPeriodShapeOfCircle
};

typedef NS_ENUM(NSUInteger, WPRecordTheme) {
    kWPRecordThemeOfColor = 0, //颜色
    kWPRecordThemeOfFlow,      //流量
    kWPRecordThemeOfPain,      //痛经
    kWPRecordThemeOfGore, //血块
    kWPRecordThemeOfMucusProb, //性状
    kWPRecordThemeOfMucusFlow, //量
    kWPRecordThemeOfLove, //同房记录
    kWPRecordThemeOfCT, //排卵试纸
    kWPRecordThemeOfSleep, //睡眠
    kWPRecordThemeOfMood, //情绪
    kWPRecordThemeOfSport, //运动时长
    kWPRecordThemeOfDrink, //饮酒
    kWPRecordThemeOfDrug,//服药
    kWPRecordThemeOfComments//备注
};
#endif /* UtilsEnum_h */
