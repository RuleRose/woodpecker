//
//  WPStatusViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPProfileModel.h"

@interface WPStatusViewModel : NSObject
@property(nonatomic,strong)NSMutableArray *temps;
@property(nonatomic,strong)WPProfileModel *profile;

@end
