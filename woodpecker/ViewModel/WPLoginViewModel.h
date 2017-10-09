//
//  WPLoginViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPLoginViewModel : NSObject
- (void)login;
+ (void)registerWithAccountID:(NSString*)account_id type:(NSString*)account_type nickname:(NSString*)nikename avatar:(NSString *)avatar success:(void (^)(NSString* user_id))success failure:(void (^)(NSError* error))failure;
@end
