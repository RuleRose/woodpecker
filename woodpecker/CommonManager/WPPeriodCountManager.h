//
//  WPPeriodCountManager.h
//  woodpecker
//
//  Created by yongche on 17/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPeriodModel.h"
#import "WPPeriodCountModel.h"
#import "WPDayInfoInPeriod.h"
@interface WPPeriodCountManager : NSObject
Singleton_Interface(WPPeriodCountManager);

-(void)recountPeriod;
-(WPDayInfoInPeriod *)dayInfo:(NSDate*)day;
@end
