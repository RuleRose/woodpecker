//
//  MHBluetoothDeviceFactory.h
//  MiBluetoothFramework
//
//  Created by yinze zhang on 16/9/20.
//  Copyright © 2016年 yinze zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHBluetoothDevice.h"
#import "MHBluetoothBroadcastPackage.h"
@interface MHBluetoothDeviceFactory : NSObject

+(MHBluetoothDevice*)deviceFrom:(MHBluetoothBroadcastPackage*)package;

@end
