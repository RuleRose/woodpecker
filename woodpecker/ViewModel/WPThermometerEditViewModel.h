//
//  WPThermometerEditViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPTemperatureModel.h"

@interface WPThermometerEditViewModel : NSObject
- (void)syncTemp:(WPTemperatureModel *)temp success:(void (^)(BOOL success))success;
@end
