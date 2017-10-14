//
//  WPLoginViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUserModel.h"
#import "WPProfileModel.h"

@interface WPLoginViewModel : NSObject
@property(nonatomic, strong)NSString *user_id;
@property(nonatomic, strong)WPUserModel *user;


- (void)login;
- (void)registerAccount:(void (^)(BOOL success))result;
- (void)getAccount:(void (^)(WPUserModel *user))result;
- (void)getProfile:(NSString *)profile_id success:(void (^)(WPProfileModel *profile))result;

@end
