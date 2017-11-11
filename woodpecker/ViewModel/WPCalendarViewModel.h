//
//  WPCalendarViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"
#import "WPProfileModel.h"
#import "NSDate+Extension.h"

@interface WPCalendarViewModel : NSObject
@property(nonatomic, strong)WPUserModel *user;
@property(nonatomic, strong)WPProfileModel *profile;

@end
