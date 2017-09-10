//
//  WPThermometerHardwareView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPThermometerHardwareViewDelegate;
@interface WPThermometerHardwareView : UIView
@property (nonatomic, assign) id<WPThermometerHardwareViewDelegate> delegate;

@end
@protocol WPThermometerHardwareViewDelegate <NSObject>
@optional

@end
