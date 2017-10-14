//
//  WPStatusViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProfileModel.h"
#import "WPUserModel.h"
#import "WPDeviceModel.h"

@interface WPStatusViewModel : NSObject
@property(nonatomic,strong)NSMutableArray *temps;
@property(nonatomic,strong)WPProfileModel *profile;
@property(nonatomic,strong)WPUserModel *user;
@property(nonatomic,strong)WPDeviceModel *device;

- (void)bindDevice;
- (void)syncTempDataFromIndex:(NSInteger)index;
- (void)syncTempData;
@end
