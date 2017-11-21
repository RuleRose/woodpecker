//
//  WPClockPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/12.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPClockBlock)(MMPopupView *, NSDate *);

@interface WPClockPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPClockBlock clockBlock;
@property (nonatomic, strong) NSDate *date;
@end
