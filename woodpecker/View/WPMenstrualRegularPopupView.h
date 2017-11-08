//
//  WPMenstrualRegularPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPMenstrualRegularBlock)(MMPopupView *, BOOL);

@interface WPMenstrualRegularPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPMenstrualRegularBlock regularBlock;

@end
