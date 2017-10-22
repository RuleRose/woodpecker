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
@property (nonatomic,assign) BOOL isForeCast; //是否预测周期
@property (nonatomic,assign) BOOL isMenstruationSwitchOffValide; //经期结束开关
@property (nonatomic,assign) BOOL isValide; //数据是否有效，无效就显示空白
@end
