//
//  WPDeviceModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPDeviceModel : XJFBaseModel
@property(nonatomic, copy)NSString *mac_addr;
@property(nonatomic, copy)NSString *serial_num;
@property(nonatomic, copy)NSString *model_num;
@property(nonatomic, copy)NSString *software_rev;
@property(nonatomic, copy)NSString *hardware_rev;
@property(nonatomic, copy)NSString *software_rev_latest;
@property(nonatomic, copy)NSString *production_test;
@property(nonatomic, copy)NSString *time_registered;
@property(nonatomic, copy)NSString *firmwareRev;
@property (nonatomic,copy) NSString *device_id;
@end
