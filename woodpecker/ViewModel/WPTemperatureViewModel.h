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
@property(nonatomic, strong)NSMutableArray *temps;//有序温度WPTemperatureModel,按时间升序
@end
