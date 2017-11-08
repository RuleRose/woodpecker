//
//  WPBirthdayPopupView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/24.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPSelectionPopupView.h"
typedef void(^WPBirthdayBlock)(MMPopupView *, NSDate *);

@interface WPBirthdayPopupView : WPSelectionPopupView
@property (nonatomic, strong) WPBirthdayBlock birthdayBlock;

@end
