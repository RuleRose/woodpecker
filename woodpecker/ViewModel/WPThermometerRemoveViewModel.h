//
//  WPThermometerRemoveViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPThermometerRemoveViewModel : NSObject
- (void)unBindDeviceSuccess:(void (^)(BOOL finished))result;

@end
