//
//  WPThermometerUnitView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WPThermometerUnitViewDelegate;
@interface WPThermometerUnitView : UIView
@property (nonatomic, assign) id<WPThermometerUnitViewDelegate> delegate;

@end
@protocol WPThermometerUnitViewDelegate <NSObject>
@optional

@end
