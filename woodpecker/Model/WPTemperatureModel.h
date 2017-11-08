//
//  WPTemperatureModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPTemperatureModel : XJFBaseModel
@property(nonatomic, copy)NSString *device_id;// 设备ID
@property(nonatomic, copy)NSString *dindex;//当前温度在设备中的index
@property(nonatomic, copy)NSString *temp;//温度
@property(nonatomic, copy)NSString *time;//温度测量的时间 timestamp
@property(nonatomic, copy)NSString *date;//温度测量的日期 yyyy MM dd
@property(nonatomic, copy)NSString *gindex;//温度的全局index
@property(nonatomic, copy)NSString *lastupdate;//最近一次更新的时间
@property(nonatomic, copy)NSString *removed;//是否被删除
@property(nonatomic, copy)NSString *sync;//是否上传 1代表已上传
@property(nonatomic, copy)NSString *device; //温度是否是来自设备 1代表来自设备

@property(nonatomic, assign)PeriodType period_type; //周期信息

@end
