//
//  WPTemperatureDetailView.h
//  woodpecker
//
//  Created by QiWL on 2017/10/9.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPLineView.h"

@interface WPTemperatureDetailView : UIView
@property(nonatomic, strong) WPLineView *lineView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIButton *switchBtn;
@end
