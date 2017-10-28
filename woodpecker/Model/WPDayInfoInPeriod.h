//
//  WPDayInfoInPeriod.h
//  woodpecker
//
//  Created by yongche on 17/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPDayInfoInPeriod : XJFBaseModel
@property (nonatomic,assign) PeriodType type;
@property (nonatomic,assign) NSInteger dayInPeriod;
@property (nonatomic,assign) NSInteger dayBeforePregnantPeriod;
@property (nonatomic,assign) BOOL isForecast; //整个周期是否是预测的
@property (nonatomic,assign) BOOL isEndDayForecast; //周期经期的结束日期是否是预测的
@property (nonatomic,assign) BOOL isMenstruationSwitchOffValide; //经期结束开关
@property (nonatomic,assign) BOOL isValide; //数据是否有效，无效就显示空白

@property (nonatomic,assign) BOOL isStart;
@property (nonatomic,assign) BOOL isEnd;

@end
