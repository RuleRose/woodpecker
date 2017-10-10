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
- (void)registerAccount:(void (^)(BOOL success))success;

@end
