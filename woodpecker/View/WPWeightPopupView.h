//
//  WPWeightPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPWeightBlock)(MMPopupView *, NSInteger, NSInteger);

@interface WPWeightPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPWeightBlock weightBlock;
@property (nonatomic, strong) NSString *weight;

@end
