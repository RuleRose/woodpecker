//
//  WPMenstrualLastperiodPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/10/9.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPMenstrualLastperiodBlock)(MMPopupView *, NSDate *);

@interface WPMenstrualLastperiodPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPMenstrualLastperiodBlock lastperiodBlock;

@end
