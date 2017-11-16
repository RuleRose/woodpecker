//
//  WPStatusViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProfileModel.h"
#import "WPUserModel.h"
#import "WPDeviceModel.h"
#import "WPTemperatureModel.h"
#import "WPDayInfoInPeriod.h"

@interface WPStatusViewModel : NSObject
@property(nonatomic,strong)NSMutableArray *temps;
@property (nonatomic,assign) Boolean isBindNewDevice;
@property (nonatomic,copy) NSString *syncFromTime;

- (void)bindDevice;
- (void)syncTempDataFromIndex:(NSInteger)index;
- (void)syncTempDataToService;
- (void)syncTempData;
- (NSDate *)getStartDate;
- (NSInteger)eventCountAtDate:(NSDate *)date withDayInfor:(WPDayInfoInPeriod *)dayInfo;
- (WPTemperatureModel *)getTempWithDate:(NSDate *)date;
- (void)insertTemperature:(NSNumber *)temp index:(NSNumber *)index time:(NSNumber *)time;

- (NSMutableArray *)getPeriods;
@end
