//
//  WPRecordStatusModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/20.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPRecordStatusModel : NSObject
@property(nonatomic,strong)NSString *icon;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *detail;
@property (nonatomic, assign) BOOL showSwitch;
@property (nonatomic, assign) BOOL onlyTitle;
@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, assign) BOOL showDetail;
@property (nonatomic, assign) BOOL showDetailEnable;

@end
