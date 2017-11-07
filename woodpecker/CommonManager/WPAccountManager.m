//
//  WPPassportManager.m
//  woodpecker
//
//  Created by yongche on 17/9/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPAccountManager.h"
@interface WPAccountManager ()<MPSessionDelegate, MPRequestDelegate>
@property(nonatomic, strong) MiPassport *account;
@end

@implementation WPAccountManager
Singleton_Implementation(WPAccountManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        _account = [[MiPassport alloc] initWithAppId:@"2882303761517613555" redirectUrl:@"http://mmc.mi-ae.cn/mmc/api/user/login/" andDelegate:self];
        
        [self loadUserDefaultValue];
    }
    return self;
}

- (void)login {
    if (![self isLogin]) {
        [self.account loginWithPermissions:@[ @1, @3 ]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyLoginSuccess object:nil];
    }
}

- (BOOL)isLogin {
    DDLogDebug(@"userID:%@, token:%@", self.userID, self.userToken);
    if (self.userToken && self.userID) {
        return YES;
    }
    return NO;
}

- (void)logout {
    if ([self isLogin]) {
        [self.account logOut];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyLogoutSuccess object:nil];
    }
}

#pragma mark - MPSessionDelegate
/**
 * Called when the user successfully logged in.
 */
- (void)passportDidLogin:(MiPassport *)passport{
    DDLogDebug(@"passport login succeeded, token:%@", passport.accessToken);
    self.account = passport;
    self.userToken = self.account.accessToken;
    kDefaultSetObjectForKey(self.userToken, USER_DEFAULT_ACCOUNT_TOKEN);
    [self fetchProfile];
}
/**
 * Called when the user failed to log in.
 */
- (void)passport:(MiPassport *)passport failedWithError:(NSError *)error{
    DDLogDebug(@"passport login failed, error:%@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyLoginFailed object:nil];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)passportDidCancel:(MiPassport *)passport{
    DDLogDebug(@"passport login did cancel");
    [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyLoginCancel object:nil];
}

/**
 * Called when the user logged out.
 */
- (void)passportDidLogout:(MiPassport *)passport{
    DDLogDebug(@"passport did log out");
    [self cleanUserDefaultValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyLogoutSuccess object:nil];
}

/**
 * Called when the user get code.
 */
- (void)passport:(MiPassport *)passport didGetCode:(NSString *)code{
    DDLogDebug(@"passport did get code: %@", code);
}

/**
 * Called when access token expired.
 */
- (void)passport:(MiPassport *)passport accessTokenInvalidOrExpired:(NSError *)error{
    DDLogDebug(@"passport accesstoken invalid or expired: %@", error);
    [self cleanUserDefaultValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyTokenExpire object:nil];
}


- (void)fetchProfile {
    [self.account requestWithURL:@"user/profile" params:[NSMutableDictionary dictionaryWithObject:self.account.appId forKey:@"clientId"] httpMethod:@"GET" delegate:self];
}

- (void)request:(MPRequest *)request didLoadRawResponse:(NSData *)data{
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *userData = [response objectForKey:@"data"];
    self.userID = [userData objectForKey:@"userId"];
    self.userNickName = [userData objectForKey:@"miliaoNick"];
    self.userAvatar = [userData objectForKey:@"miliaoIcon"];
    DDLogDebug(@"userID:%@", self.userID);
    kDefaultSetObjectForKey(self.userID, USER_DEFAULT_ACCOUNT_USER_ID);
    kDefaultSetObjectForKey(self.userNickName, USER_DEFAULT_ACCOUNT_USER_NICKNAME);
    kDefaultSetObjectForKey(self.userAvatar, USER_DEFAULT_ACCOUNT_USER_AVATAR);
    [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationKeyLoginSuccess object:nil];
}

- (void)loadUserDefaultValue {
    self.userToken = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_TOKEN);
    self.userID = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_ID);
    self.userNickName = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_NICKNAME);
    self.userAvatar = kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER_AVATAR);
}

- (void)cleanUserDefaultValue{
    self.userToken = nil;
    self.userID = nil;
    self.userNickName = nil;
    self.userAvatar = nil;
    kDefaultRemoveForKey(USER_DEFAULT_ACCOUNT_TOKEN);
    kDefaultRemoveForKey(USER_DEFAULT_ACCOUNT_USER_ID);
    kDefaultRemoveForKey(USER_DEFAULT_ACCOUNT_USER_NICKNAME);
    kDefaultRemoveForKey(USER_DEFAULT_ACCOUNT_USER_AVATAR);
}
@end
