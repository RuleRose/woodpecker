//
//  WPCalendarViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPCalendarViewModel : NSObject


- (PeriodType)getPeriodWithDate:(NSDate *)date;
@end
