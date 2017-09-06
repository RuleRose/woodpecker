//
//  WPPassportManager.h
//  woodpecker
//
//  Created by yongche on 17/9/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAccountManager : NSObject
Singleton_Interface(WPAccountManager);
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *userNickName;
@property (nonatomic,copy) NSString *userAvatar;
@property (nonatomic,copy) NSString *userToken;

- (void)login;
- (BOOL)isLogin;
- (void)logout;
@end
