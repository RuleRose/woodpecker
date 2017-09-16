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
    kPeriodTypeOfOviposit //排卵日
};
typedef NS_ENUM(NSUInteger, PeriodShapeType) {
    kPeriodShapeOfRight = 0,
    kPeriodShapeOfLeft,
    kPeriodShapeOfMiddle,
    kPeriodShapeOfSingle,
    kPeriodShapeOfCircle
};
#endif /* UtilsEnum_h */
