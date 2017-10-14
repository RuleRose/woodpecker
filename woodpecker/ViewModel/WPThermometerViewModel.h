//
//  WPThermometerViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPThermometerViewModel : NSObject
- (void)unBindDeviceSuccess:(void (^)(BOOL finished))result;
@end
