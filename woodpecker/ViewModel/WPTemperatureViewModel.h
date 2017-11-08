//
//  WPTemperatureViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPTemperatureModel.h"

@interface WPTemperatureViewModel : NSObject
//- (PeriodType)getPeriodWithDate:(NSDate *)date;
- (void)getTempsBlock:(void (^)(NSMutableArray *sortTemps))result;

@end
