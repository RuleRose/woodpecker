//
//  MMCHUDManager.h
//  mmcS2
//
//  Created by 肖君 on 16/11/7.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJFHUDManager : NSObject
Singleton_Interface(XJFHUDManager);
- (void)showQuickTextHUD:(NSString *)title;
- (void)showTextHUD:(NSString *)title;
- (void)showLoadingHUDwithCallback:(MBProgressHUDCompletionBlock)timeoutCallback;
- (void)hide;
- (void)hideLoading;
@end
