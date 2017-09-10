//
//  WPThermometerClockView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPThermometerClockViewDelegate;
@interface WPThermometerClockView : UIView
@property (nonatomic, assign) id<WPThermometerClockViewDelegate> delegate;

@end
@protocol WPThermometerClockViewDelegate <NSObject>
@optional

@end
