//
//  AppDelegate.m
//  woodpecker
//
//  Created by yongche on 17/8/25.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "AppDelegate.h"
#import "WPMainViewController.h"
#import "initServer.h"
#import "WPLoginViewController.h"
#import "WPAccountManager.h"
#import "XJFServerManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = kColor_10;
    [initServer load];

    // Override point for customization after application launch.
    if ([[WPAccountManager defaultInstance] isLogin]) {
        //主页
       NSString *user_id = kDefaultValueForKey(USER_DEFAULT_USER_ID);
        if ([NSString leie_isBlankString:user_id]) {
            //登录
            WPLoginViewController *loginVC = [[WPLoginViewController alloc] init];
            _navigationC = [[XJFBaseNavigationController alloc] initWithRootViewController:loginVC];
        }else{
            WPMainViewController *mainVC = [[WPMainViewController alloc] init];
            _navigationC = [[XJFBaseNavigationController alloc] initWithRootViewController:mainVC];
        }

    }else{
        //登录
        WPLoginViewController *loginVC = [[WPLoginViewController alloc] init];
        _navigationC = [[XJFBaseNavigationController alloc] initWithRootViewController:loginVC];
    }
    self.window.rootViewController = _navigationC;
    [self.window makeKeyAndVisible];
    //[NSThread sleepForTimeInterval:1];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background,
    // optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
