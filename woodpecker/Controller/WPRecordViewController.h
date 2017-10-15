//
//  WPRecordViewController.h
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "XJFBaseViewController.h"
#import "WPMenstrualRecordModel.h"
#import "WPEventModel.h"

@interface WPRecordViewController : XJFBaseViewController
@property(nonatomic, strong)WPMenstrualRecordModel *menstrual;
@property(nonatomic, strong)WPEventModel *event;
@property(nonatomic, strong)NSDate *eventDate;

@end
