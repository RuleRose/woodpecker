//
//  UtilsMacro.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/4.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

#pragma mark - 设备相关

#define kStatusHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationHeight 44
#define kFitWidth(width) (width * (kScreen_Width > 375 ? 1 : kScreen_Width/375))

//屏幕的宽度,支持旋转屏幕
#define kScreen_Width                                                                                                                              \
    ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)                                                                       \
         ? (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? [UIScreen mainScreen].bounds.size.height \
                                                                                                        : [UIScreen mainScreen].bounds.size.width) \
         : [UIScreen mainScreen].bounds.size.width)

//屏幕的高度,支持旋转屏幕
#define kScreen_Height                                                                                                                              \
    ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)                                                                        \
         ? (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? [UIScreen mainScreen].bounds.size.width   \
                                                                                                        : [UIScreen mainScreen].bounds.size.height) \
         : [UIScreen mainScreen].bounds.size.height)

//当前设备是iPhone
#define kDevice_is_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//当前设备是iPad
#define kDevice_is_iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// iOS系统版本
#define kiOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]
// iOS 10
#define kiOSVersion_10X (kiOS_Version >= 10.0f && kiOS_Version < 11.0f)
// iOS 9
#define kiOSVersion_9X (kiOS_Version >= 9.0f && kiOS_Version < 10.0f)
// iOS 8
#define kiOSVersion_8X (kiOS_Version >= 8.0f && kiOS_Version < 9.0f)
// iOS 7
#define kiOSVersion_7X (kiOS_Version >= 7.0f && kiOS_Version < 8.0f)

// iPhone4/4S
#define kDevice_is_iPhone4 ([[UIScreen mainScreen] bounds].size.height == 480)
// iPhone5/5C/5S
#define kDevice_is_iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
// iPhone6
#define kDevice_is_iPhone6 ([[UIScreen mainScreen] bounds].size.height == 667)
// iPhone6 Plus
#define kDevice_is_iPhone6P ([[UIScreen mainScreen] bounds].size.height == 736)

/******************************** 单例 ********************************/
#pragma mark - 单例

// @interface
#define Singleton_Interface(className) +(className *)defaultInstance;

// @implementation
#define Singleton_Implementation(className)                 \
    static className *_instance;                            \
    static dispatch_once_t onceToken;                       \
    +(instancetype)allocWithZone : (struct _NSZone *)zone { \
        dispatch_once(&onceToken, ^{                        \
          _instance = [super allocWithZone:zone];           \
        });                                                 \
        return _instance;                                   \
    }                                                       \
    +(instancetype)defaultInstance {                        \
        static dispatch_once_t onceToken;                   \
        dispatch_once(&onceToken, ^{                        \
          _instance = [[self alloc] init];                  \
        });                                                 \
        return _instance;                                   \
    }

/*****************************************************************************************/
#pragma mark - 国际化
#define kLocalization(key) NSLocalizedStringFromTable(key, @"Localization", nil)
//当前语言
#define kSystem_Language ([[NSLocale preferredLanguages] objectAtIndex:0])

/*****************************************************************************************/
#pragma mark - 目录相关
// Document目录
#define kDocumentsDirectory ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

// Document子目录
#define kDocumentsSubDirectory(dir) ([kDocumentsDirectory stringByAppendingPathComponent:dir])

// Library目录
#define kLibraryDirectory ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0])

// Library子目录
#define kLibrarySubDirectory(dir) ([kLibraryDirectory stringByAppendingPathComponent:dir])

// Cache目录
#define kCacheDirectory ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])

// Cache子目录
#define kCacheSubDirectory(dir) ([kCacheDirectory stringByAppendingPathComponent:dir])

// Temp目录
#define kTempDirectory (NSTemporaryDirectory())

// Temp子目录
#define kTempSubDirectory(dir) ([NSTemporaryDirectory() stringByAppendingPathComponent:dir])

/*****************************************************************************************/
//获取应用目录下的PNG图片
#define kImage(key) [UIImage imageNamed:(key)]

#define kImageWithName_PNG(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]

//获取应用目录下的JPG图片
#define kImageWithName_JPG(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]]

#pragma mark - 真机模拟器
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif

#endif /* UtilsMacro_h */
