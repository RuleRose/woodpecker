//
//  WPThermometerView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WPThermometerViewDelegate;
@interface WPThermometerView : UIView
@property (nonatomic, assign) id<WPThermometerViewDelegate> delegate;

@end
@protocol WPThermometerViewDelegate <NSObject>
@optional
- (void)removeBinding;
- (void)showThermometerClock;
- (void)showThermometerUnit;
- (void)showThermometerHardware;
@end
