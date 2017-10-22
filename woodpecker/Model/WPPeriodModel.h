//
//  WPPeriodModel.h
//  woodpecker
//
//  Created by QiWL on 2017/10/22.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseModel.h"

@interface WPPeriodModel : XJFBaseModel
@property(nonatomic, copy)NSString *period_id;
@property(nonatomic, copy)NSString *period_start;
@property(nonatomic, copy)NSString *period_end;
@property(nonatomic, copy)NSString *brief;
@property(nonatomic, copy)NSString *extra_data;
@property(nonatomic, copy)NSString *lastupdate;
@property(nonatomic, copy)NSString *removed;

@property(nonatomic, assign)BOOL speculate;
@property(nonatomic, assign)NSInteger menstruation_lenth;
@property(nonatomic, assign)NSInteger period_lenth;
@property(nonatomic, assign)NSInteger oviposit;
@property(nonatomic, assign)NSInteger pregnancy_start;
@property(nonatomic, assign)NSInteger pregnancy_end;

@end
