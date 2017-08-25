//
//  MMCHUDManager.m
//  mmcS2
//
//  Created by 肖君 on 16/11/7.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "XJFHUDManager.h"
@interface XJFHUDManager ()<MBProgressHUDDelegate>
@property(nonatomic, strong) MBProgressHUD *HUD;
@property(nonatomic, strong) MBProgressHUD *loadingHUD;
@end

@implementation XJFHUDManager
Singleton_Implementation(XJFHUDManager);
- (void)showQuickTextHUD:(NSString *)title {
    if (self.HUD) {
        [self.HUD hideAnimated:NO];
    }
    self.HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    self.HUD.delegate = self;

    [[UIApplication sharedApplication].keyWindow addSubview:self.HUD];
    self.HUD.label.text = title;
    self.HUD.removeFromSuperViewOnHide = YES;
    self.HUD.mode = MBProgressHUDModeText;

    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:0.4];
}

- (void)showTextHUD:(NSString *)title {
    if (self.HUD) {
        [self.HUD hideAnimated:NO];
    }
    self.HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    self.HUD.delegate = self;

    [[UIApplication sharedApplication].keyWindow addSubview:self.HUD];
    //    self.HUD.label.text = title;
    self.HUD.detailsLabel.text = title;
    self.HUD.removeFromSuperViewOnHide = YES;
    self.HUD.mode = MBProgressHUDModeText;

    [self.HUD showAnimated:YES];
    [self.HUD hideAnimated:YES afterDelay:1.5];
}

- (void)showLoadingHUDwithCallback:(MBProgressHUDCompletionBlock)timeoutCallback {
    if (self.loadingHUD) {
        return;
    }
    self.loadingHUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    self.loadingHUD.delegate = self;

    [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHUD];
    self.loadingHUD.removeFromSuperViewOnHide = YES;
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    self.loadingHUD.completionBlock = timeoutCallback;

    [self.loadingHUD showAnimated:YES];
    [self.loadingHUD hideAnimated:YES afterDelay:80];
}

- (void)hide {
    if (self.HUD) {
        [self.HUD hideAnimated:YES];
    }
}

- (void)hideLoading {
    if (self.loadingHUD) {
        [self.loadingHUD hideAnimated:YES];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    if (self.loadingHUD == hud) {
        self.loadingHUD = nil;
    } else if (self.HUD == hud) {
        self.HUD = nil;
    }
}
@end
