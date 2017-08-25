//
//  MMC_Ntc.h
//  MiaoMiaoCe
//
//  Created by lanp on 9/13/14.
//  Copyright (c) 2014 Weisi Smart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMC_Ntc : NSObject
+(float)ntcResistanceToTemperature:(float)resistance index:(int)ntcIndex;

@end
