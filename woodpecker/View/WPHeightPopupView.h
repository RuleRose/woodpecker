//
//  WPHeightPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPHeightBlock)(MMPopupView *, NSInteger);

@interface WPHeightPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPHeightBlock heightBlock;
@property (nonatomic, strong) NSString *height;

@end
