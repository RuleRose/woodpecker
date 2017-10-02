//
//  WPTemperatureUnitPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/10/2.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPTemperatureUnitBlock)(MMPopupView *, NSInteger);

@interface WPTemperatureUnitPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPTemperatureUnitBlock unitBlock;

@end
