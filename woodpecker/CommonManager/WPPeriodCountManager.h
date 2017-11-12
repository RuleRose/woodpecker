//
//  WPPeriodCountManager.h
//  woodpecker
//
//  Created by yongche on 17/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPeriodCountModel.h"
#import "WPDayInfoInPeriod.h"
@interface WPPeriodCountManager : NSObject
Singleton_Interface(WPPeriodCountManager);
@property(nonatomic, strong)NSMutableDictionary *periodDic;
@property(nonatomic, assign)BOOL loadingPeriods;

-(void)recountPeriod;
-(WPDayInfoInPeriod *)dayInfo:(NSDate*)day;
-(WPPeriodCountModel *)getCurrentPeriodInfo:(NSDate *)day;
-(WPPeriodCountModel *)getPrePeriodInfo:(NSDate *)day;
-(WPPeriodCountModel *)getNextPeriodInfo:(NSDate *)day;
@end
