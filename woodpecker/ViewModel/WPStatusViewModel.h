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
@property (nonatomic,assign) Boolean isBindNewDevice;
@property (nonatomic,copy) NSString *syncFromTime;
- (void)bindDevice;
- (void)syncTempDataFromIndex:(NSInteger)index;
- (void)syncTempDataToService;
- (void)syncTempData;
@end
