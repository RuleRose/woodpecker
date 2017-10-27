//
//  WPEventModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/8.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPEventModel : XJFBaseModel
@property(nonatomic, copy)NSString *color;//颜色
@property(nonatomic, copy)NSString *flow;//流量
@property(nonatomic, copy)NSString *pain; //痛经
@property(nonatomic, copy)NSString *gore;//血块
@property(nonatomic, copy)NSString *mucus_prob;//性状
@property(nonatomic, copy)NSString *mucus_flow;//量
@property(nonatomic, copy)NSString *love;//同房记录
@property(nonatomic, copy)NSString *ct;//排卵试纸
@property(nonatomic, copy)NSString *sleep;//睡眠
@property(nonatomic, copy)NSString *mood;//情绪
@property(nonatomic, copy)NSString *sport;//运动时长
@property(nonatomic, copy)NSString *drink;//饮酒
@property(nonatomic, copy)NSString *drug;//服药
@property(nonatomic, copy)NSString *comments;//备注
@property(nonatomic, copy)NSString *weight;//体重
@property(nonatomic, copy)NSString *lastupdate; //最近一次更新的时间
@property(nonatomic, copy)NSString *date; //事件日期（2017 07 18）
@property(nonatomic, copy)NSString *extra_data; //额外数据（可选）
@property(nonatomic, copy)NSString *software_rev;

@property(nonatomic, copy)NSString *event_id1;
@property(nonatomic, copy)NSString *event_id2;
@property(nonatomic, copy)NSString *event_id3;
@property(nonatomic, copy)NSString *event_id4;
@property(nonatomic, copy)NSString *event_id5;
@property(nonatomic, copy)NSString *event_id6;
@property(nonatomic, copy)NSString *event_id7;
@property(nonatomic, copy)NSString *event_id8;
- (void)setTheme:(WPRecordTheme)theme detail:(NSString *)detail;
@end
