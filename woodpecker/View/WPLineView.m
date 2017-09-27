//
//  WPLineView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/27.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPLineView.h"
#import "woodpecker-Swift.h"
#import <Charts/Charts.h>
@interface WPLineView ()<ChartViewDelegate>
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) BalloonMarker *marker;
@end

@implementation WPLineView
- (void)setInsets:(UIEdgeInsets)insets{
    _insets = insets;
    [_chartView setExtraOffsetsWithLeft:_insets.left top:_insets.top right:_insets.right bottom:insets.bottom];
}

- (void)setShowLegend:(BOOL)showLegend{
    _showLegend = showLegend;
    ChartLegend *legend = _chartView.legend;
    legend.enabled = showLegend;
    if (showLegend) {
        legend.form = ChartLegendFormCircle;
        legend.position = ChartLegendPositionBelowChartRight;
        legend.direction = ChartLegendDirectionLeftToRight;
        legend.textColor = kColorFromRGB(0x666666);
        legend.font = [UIFont systemFontOfSize:11.0f];
    }
}

- (void)setShowLeftYAxis:(BOOL)showLeftYAxis{
    _showLeftYAxis = showLeftYAxis;
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.enabled = showLeftYAxis;
    if (showLeftYAxis) {
        leftAxis.labelTextColor = kColorFromRGB(0x666666);
        leftAxis.labelFont = [UIFont systemFontOfSize:11.0f];
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.granularityEnabled = NO;
        leftAxis.drawAxisLineEnabled = YES;
        leftAxis.gridLineWidth = 2;
        leftAxis.axisMaximum = 40.0;
        leftAxis.axisMinimum = 35.0;
        leftAxis.gridColor = kColorFromRGB(0xf6f6f6);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:formatter];
    }
}

- (void)setShowRightYAxis:(BOOL)showRightYAxis{
    _showRightYAxis = showRightYAxis;
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.enabled = showRightYAxis;
    if (showRightYAxis) {
        rightAxis.labelTextColor = kColorFromRGB(0x666666);
        rightAxis.labelFont = [UIFont systemFontOfSize:11.0f];
        rightAxis.drawGridLinesEnabled = NO;
        rightAxis.granularityEnabled = NO;
        rightAxis.drawAxisLineEnabled = YES;
        rightAxis.drawZeroLineEnabled = NO;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        rightAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:formatter];
    }
}

- (void)setShowXAxis:(BOOL)showXAxis{
    _showXAxis = showXAxis;
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.enabled = showXAxis;
    if (showXAxis) {
        xAxis.labelFont = [UIFont systemFontOfSize:11.0f];
        xAxis.labelTextColor = kColorFromRGB(0x666666);
        xAxis.drawGridLinesEnabled = YES;
        xAxis.drawAxisLineEnabled = YES;
        xAxis.granularity = 1.0;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.gridLineWidth = 2;
        xAxis.gridColor = kColorFromRGB(0xf6f6f6);
        
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        self.showLegend = YES;
        self.showRightYAxis = NO;
        self.showLeftYAxis = YES;
        self.showXAxis = YES;
        self.showCount = 7.0;
    }
    return self;
}

- (void)setupViews{
    _chartView = [[ LineChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_chartView];
    _chartView.delegate = self;
    _chartView.descriptionText = @"";
    _chartView.noDataText = @"没有数据";
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = YES;
    _chartView.backgroundColor = [UIColor clearColor];
    _chartView.pinchZoomEnabled = YES;
    _chartView.scaleYEnabled = NO;
    _chartView.scaleXEnabled = YES;
    
    _marker = [[BalloonMarker alloc] initWithTextColor:kColorFromRGB(0x777777) font:[UIFont systemFontOfSize:14] insets:UIEdgeInsetsMake(4.0, 14.0, 8.0, 14.0)];
    _marker.minimumSize = CGSizeMake(60.f, 30.f);
    _marker.isInt = YES;
    _marker.color = kColorFromRGB(0xffffff);
    _marker.borderColor = kColorFromRGB(0x777777);
    _marker.arrowSize = CGSizeMake(7, 4);
    _chartView.marker = _marker;
    [_chartView animateWithXAxisDuration:0];
}

- (void)updateChartData{
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 4; i++ ) {
        //周期
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < 6; j++){
            //日期
            CGFloat temperature = 35+ i + j/5.0;
            [yVals addObject:[[ChartDataEntry alloc] initWithX:(i *5 + j) y:temperature]];
            [xVals addObject:[NSString stringWithFormat:@"%ld",i *5 + j]];

        }
        LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yVals label:@"温度"];
        dataSet.axisDependency = AxisDependencyLeft;
        
        UIColor *linefillColor = kColor_5;
        if (i == 0 || i == 2) {
            [dataSet setColor:kColor_5];
            [dataSet setCircleColor:kColor_5];
            dataSet.fillColor = kColor_5;
            dataSet.highlightColor = kColor_5;
            dataSet.circleHoleColor = kColor_5;
            linefillColor = kColor_5;
        }else{
            [dataSet setColor:kColor_17];
            [dataSet setCircleColor:kColor_17];
            dataSet.fillColor = kColor_17;
            dataSet.highlightColor = kColor_17;
            dataSet.circleHoleColor = kColor_17;
            linefillColor = kColor_17;
        }
        NSArray *gradientColors = @[(id)kColor_10.CGColor,(id)linefillColor.CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        dataSet.lineWidth = 0.5;
        dataSet.drawCircleHoleEnabled = YES;
        dataSet.drawCubicEnabled = NO;
        dataSet.circleRadius = 3;
        dataSet.circleHoleRadius = 1.5;
        dataSet.drawVerticalHighlightIndicatorEnabled = YES;
        dataSet.drawHorizontalHighlightIndicatorEnabled = NO;
        dataSet.drawValuesEnabled = NO;
        dataSet.highlightLineWidth = 0.5;
        dataSet.fillAlpha = 1.0;
        dataSet.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        dataSet.drawFilledEnabled = YES;
        [dataSets addObject:dataSet];
    }
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    data.highlightEnabled = YES;
    _chartView.data = data;
    if (_showCount != 0) {
        CGFloat scale = xVals.count/_showCount;
        if (_scaleX >= 0) {
            scale = _scaleX;
        }
        NSInteger index = xVals.count;
        if (_xIndex >= 0) {
            index = _xIndex + 3;
        }
        [_chartView zoomWithScaleX:scale scaleY:1 xValue:index yValue:0 axis:AxisDependencyLeft];
//        if (_delegate && [_delegate respondsToSelector:@selector(scaleLine:scaleX:scaleY:)]) {
//            [_delegate scaleLine:self scaleX:scale scaleY:1];
//        }
//        if (_delegate && [_delegate respondsToSelector:@selector(scrollLine:lowestVisibleXIndex:highestVisibleXIndex:)]) {
//            [_delegate scrollLine:self lowestVisibleXIndex:_chartView.lowestVisibleX highestVisibleXIndex:_chartView.highestVisibleX];
//        }
    }else{
        [_chartView zoomWithScaleX:1 scaleY:1 xValue:xVals.count yValue:0 axis:AxisDependencyLeft];
    }
    [_chartView highlightValue:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
