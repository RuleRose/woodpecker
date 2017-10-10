//
//  MMCMainViewModel.h
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"

@interface WPMainViewModel : NSObject
@property (nonatomic,strong) NSMutableArray *controllerList;
- (void)getAccount:(void (^)(WPUserModel *user))result;
@end
