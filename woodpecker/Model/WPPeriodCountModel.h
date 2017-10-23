//
//  WPPeriodCountModel.h
//  woodpecker
//
//  Created by yongche on 17/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPPeriodCountModel : XJFBaseModel
@property(nonatomic, copy)NSString *period_id;
@property(nonatomic, strong)NSDate *period_start;
@property(nonatomic, strong)NSDate *period_end;
@property (nonatomic,strong) NSDate *pregnant_start;
@property (nonatomic,strong) NSDate *pregnant_end;
@property (nonatomic,strong) NSDate *ovulate_day;
@property (nonatomic,assign) BOOL isForecast;
@end
