//
//  WPTemperatureRecordView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPTemperatureRecordViewDelegate;
@interface WPTemperatureRecordView : UIView
@property (nonatomic, assign) id<WPTemperatureRecordViewDelegate> delegate;

@end
@protocol WPTemperatureRecordViewDelegate <NSObject>
@optional
@end
