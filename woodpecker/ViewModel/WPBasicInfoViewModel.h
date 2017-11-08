//
//  WPBasicInfoViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"

@interface WPBasicInfoViewModel : NSObject
- (void)updateUserinfo:(WPUserModel *)userinfo reuslt:(void (^)(BOOL success))result;

@end
