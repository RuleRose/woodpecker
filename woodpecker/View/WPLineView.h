//
//  WPLineView.h
//  woodpecker
//
//  Created by QiWL on 2017/9/27.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPLineView : UIView
@property (nonatomic, assign) BOOL showLegend; //是否显示标注
@property (nonatomic, assign) BOOL showLeftYAxis; //是否显示左侧y坐标
@property (nonatomic, assign) BOOL showRightYAxis; //是否显示右侧y坐标
@property (nonatomic, assign) BOOL showXAxis; //是否显示x坐标
@property (nonatomic, assign) UIEdgeInsets insets; //边框大小
@property (nonatomic, assign) NSInteger showCount; //大小（一屏显示的天数）
@property(nonatomic,assign) CGFloat scaleX;
@property(nonatomic,assign) NSInteger xIndex;

- (void)updateChartData:(NSMutableArray *)sortTemps;
@end
