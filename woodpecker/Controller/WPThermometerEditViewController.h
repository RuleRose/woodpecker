//
//  WPThermometerEditViewController.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseViewController.h"
#import "WPTemperatureModel.h"

@interface WPThermometerEditViewController : XJFBaseViewController
@property(nonatomic, strong)NSDate *date;
@property(nonatomic, strong)WPTemperatureModel *temperature;
@end
