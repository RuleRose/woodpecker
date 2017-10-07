//
//  WPTemperatureRecordModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPTemperatureRecordModel : XJFBaseModel
@property(nonatomic, copy)NSString *update_time;
@property(nonatomic, copy)NSString *temperature;
@property(nonatomic, copy)NSString *status;

@end
