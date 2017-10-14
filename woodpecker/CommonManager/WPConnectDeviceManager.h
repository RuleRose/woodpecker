//
//  WPConnectDeviceManager.h
//  woodpecker
//
//  Created by QiWL on 2017/10/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPDeviceModel.h"

@interface WPConnectDeviceManager : NSObject
Singleton_Interface(WPConnectDeviceManager);
@property(nonatomic, strong)WPDeviceModel *device;

//开启定时器
- (void)startTimer;
//停止定时器
- (void)stopTimer;
@end
