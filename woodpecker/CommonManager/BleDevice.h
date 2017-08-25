//
//  BleDevice.h
//  MiaoMiaoCe
//
//  Created by lanp on 15/12/4.
//  Copyright (c) 2015年 Weisi Smart. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MMCDeviceWorkMode) { MMCDeviceWorkMode_None, MMCDeviceWorkMode_Broadcast, MMCDeviceWorkMode_Connect };

typedef NS_ENUM(NSUInteger, MMCDeviceType) {
    MMC_TYPE_NONE,
    MMC_TYPE_A,
    MMC_TYPE_C,
    MMC_TYPE_D,
    MMC_TYPE_C_OR_D,
    MMC_TYPE_CPLUS,
    MMC_TYPE_DPLUS,
    MMC_TYPE_CPLUS_OR_DPLUS,
    MMC_TYPE_OWL,
    MMC_TYPE_WOODPECKER,
    MMC_TYPE_UNICORN
};

@interface BleDevice : NSObject

@property(assign, nonatomic) NSInteger RSSI;
@property(nonatomic, assign) MMCDeviceType type;
@property(nonatomic, strong) CBPeripheral *peripheral;
@property(nonatomic, strong) NSUUID *identifier;
@property(nonatomic, assign) int8_t scanningTTL;

- (MMCDeviceWorkMode)getWorkMode;
- (BOOL)isSameIdentifier:(NSUUID *)identifier;

@end
