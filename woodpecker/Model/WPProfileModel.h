//
//  WPProfileModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPProfileModel : XJFBaseModel
@property(nonatomic, copy)NSString *menstruation;//经期长度
@property(nonatomic, copy)NSString *period;//周期长度
@property(nonatomic, copy)NSString *lastperiod;//最后一次月经时间
@property(nonatomic, copy)NSString *extra_data;//额外数据（可选）

@end
