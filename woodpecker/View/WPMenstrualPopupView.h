//
//  WPMenstrualPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"

typedef void(^WPMenstrualShowInfoBlock)(MMPopupView *);
typedef void(^WPMenstrualBlock)(MMPopupView *, NSInteger);

@interface WPMenstrualPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPMenstrualShowInfoBlock showInfoBlock;
@property (nonatomic, strong) WPMenstrualBlock menstrualBlock;
@property (nonatomic, strong) NSString *menstrual;

@end
