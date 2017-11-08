//
//  WPPeriodPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPPeriodShowInfoBlock)(MMPopupView *);
typedef void(^WPPeriodBlock)(MMPopupView *, NSInteger);

@interface WPPeriodPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPPeriodShowInfoBlock showInfoBlock;
@property (nonatomic, strong) WPPeriodBlock periodBlock;

@end
