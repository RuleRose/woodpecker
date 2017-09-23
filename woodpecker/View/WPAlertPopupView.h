//
//  WPAlertPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/23.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>
typedef void(^WPAlertPopupViewCancelBlock)(MMPopupView *);
typedef void(^WPAlertPopupViewConfirmBlock)(MMPopupView *, BOOL);
@interface WPAlertPopupView : MMPopupView
@property(nonatomic, strong)NSString *title;
@property (nonatomic, strong) WPAlertPopupViewCancelBlock cancelBlock;
@property (nonatomic, strong) WPAlertPopupViewConfirmBlock confirmBlock;

@end
