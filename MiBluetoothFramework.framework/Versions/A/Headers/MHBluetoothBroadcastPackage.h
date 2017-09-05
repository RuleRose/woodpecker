//
//  MHBluetoothBroadcastPackage.h
//  Miio
//
//  Created by marteswang on 15/11/24.
//  Copyright © 2015年 xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MHBluetoothBroadcastPackage : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic ,strong) NSNumber *RSSI;
@property (nonatomic, weak) CBCentralManager *centralManager;

@property (nonatomic, strong) NSDictionary *extra;


+(instancetype)parserFromRawData:(NSDictionary*)data;

@end
