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
#import "WPTemperatureModel.h"
#import "NSDate+Extension.h"
#import "WPLineDateFormatter.h"

@interface WPLineView ()<ChartViewDelegate>
@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic, strong) BalloonMarker *marker;
@property (nonatomic, strong) WPLineDateFormatter *formatter;
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
        leftAxis.drawZeroLineEnabled = YES;
        leftAxis.granularityEnabled = YES;
        leftAxis.drawAxisLineEnabled = YES;
        leftAxis.gridLineWidth = 0.5;
        leftAxis.axisMaximum = 45.0;
        leftAxis.axisMinimum = 32.0;
        leftAxis.gridColor = kColor_16_With_Alpha(0.1);
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
        rightAxis.drawGridLinesEnabled = YES;
        rightAxis.granularityEnabled = YES;
        rightAxis.drawAxisLineEnabled = YES;
        rightAxis.drawZeroLineEnabled = YES;
        rightAxis.gridLineWidth = 0.5;
        rightAxis.axisMaximum = 45.0;
        rightAxis.axisMinimum = 32.0;
        rightAxis.gridColor = kColor_16_With_Alpha(0.1);
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
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.gridLineWidth = 0.5;
        xAxis.gridColor = kColor_16_With_Alpha(0.5);
        xAxis.granularity = 1.0;
        _formatter = [[WPLineDateFormatter alloc] init];
        xAxis.valueFormatter = _formatter;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        self.showLegend = NO;
        self.showRightYAxis = NO;
        self.showLeftYAxis = YES;
        self.showXAxis = YES;
        self.scaleX = -1;
        self.xIndex = -1;
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
    [_chartView setScaleEnabled:NO];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.backgroundColor = [UIColor clearColor];
    _chartView.pinchZoomEnabled = NO;
    _chartView.scaleYEnabled = NO;
    _chartView.scaleXEnabled = NO;
    _marker = [[BalloonMarker alloc] initWithTextColor:kColorFromRGB(0x777777) font:[UIFont systemFontOfSize:14] insets:UIEdgeInsetsMake(4.0, 14.0, 8.0, 14.0)];
    _marker.minimumSize = CGSizeMake(60.f, 30.f);
    _marker.isInt = YES;
    _marker.color = kColorFromRGB(0xffffff);
    _marker.borderColor = kColorFromRGB(0x777777);
    _marker.arrowSize = CGSizeMake(7, 4);
    _chartView.marker = _marker;
    [_chartView animateWithXAxisDuration:0];
    _showCount = 15;
}

//- (void)setShowCount:(NSInteger)showCount{
//    _showCount = showCount;
//    _chartView.maxVisibleCount = showCount;
//
//}

- (void)updateChartData:(NSMutableArray *)sortTemps{
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSInteger total_days = 0;
    if (sortTemps.count > 0) {
        WPTemperatureModel *lastTemp = [[sortTemps lastObject] lastObject];
        NSDate *today = [NSDate dateFromString:[NSDate stringFromDate:[NSDate date]] format:@"yyyy MM dd"];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince2000:[lastTemp.time longLongValue]];
        startDate =[NSDate dateFromString:[NSDate stringFromDate:startDate] format:@"yyyy MM dd"];
        _formatter.startDate = startDate;
       total_days = [NSDate daysFromDate:startDate toDate:today];
//        for (NSInteger i = 0; i <= days; i ++) {
//            NSDate *date = [NSDate dateByAddingDays:i toDate:startDate];
//            [xVals addObject:[NSDate stringFromDate:date format:@"MMdd"]];
//        }

        NSMutableArray *startVals = [[NSMutableArray alloc] init];
        [startVals addObject:[[ChartDataEntry alloc] initWithX:-5 y:0]];
        LineChartDataSet *startSet = [[LineChartDataSet alloc] initWithValues:startVals label:@""];
        [dataSets addObject:startSet];
        for (NSArray *temps in sortTemps) {
            //每一段
            NSMutableArray *yVals = [[NSMutableArray alloc] init];
            PeriodType period_type = kPeriodTypeOfSafe;
            for (WPTemperatureModel *temp in temps) {
                NSDate *date = [NSDate dateFromString:temp.date format:@"yyyy MM dd"];
                NSInteger days = [NSDate daysFromDate:startDate toDate:date];
//                NSTimeInterval time = [date timeIntervalSince1970];
                if (yVals.count == 0) {
                    period_type = temp.period_type;
                }
                CGFloat temperature = [temp.temp floatValue];
                if (temperature > 45) {
                    temperature = 45;
                }
                if (temperature < 32) {
                    temperature = 32;
                }
                [yVals addObject:[[ChartDataEntry alloc] initWithX:days y:temperature]];
            }
            NSString *title = @"安全期";
            UIColor *linefillColor = [UIColor clearColor];
            UIColor *lineColor = [UIColor clearColor];
            switch (period_type) {
                case kPeriodTypeOfForecast:
                case kPeriodTypeOfMenstrual:
                    title = @"月经期";
                    linefillColor = kColor_5;
                    lineColor = kColor_5;
                    break;
                case kPeriodTypeOfOviposit:
                    title = @"排卵日";
                    linefillColor = kColor_15;
                    lineColor = kColor_15;
                    break;

                case kPeriodTypeOfPregnancy:
                    title = @"易孕期";
                    linefillColor = kColor_18;
                    lineColor = kColor_18;
                    break;
                default:
                    title = @"安全期";
                    linefillColor = kColor_17;
                    lineColor = kColor_17;
                    break;
            }
            LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yVals label:title];
            dataSet.axisDependency = AxisDependencyLeft;
            [dataSet setColor:lineColor];
            [dataSet setCircleColor:lineColor];
            dataSet.fillColor = lineColor;
            dataSet.highlightColor = lineColor;
            dataSet.circleHoleColor = lineColor;
            NSArray *gradientColors = @[(id)kColor_10.CGColor,(id)linefillColor.CGColor];
            CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
            dataSet.lineWidth = 1;
            dataSet.drawCircleHoleEnabled = YES;
            dataSet.drawCubicEnabled = NO;
            dataSet.circleRadius = 6;
            dataSet.circleHoleRadius = 3;
            dataSet.drawVerticalHighlightIndicatorEnabled = YES;
            dataSet.drawHorizontalHighlightIndicatorEnabled = NO;
            dataSet.drawValuesEnabled = NO;
            dataSet.highlightLineWidth = 1;
            dataSet.fillAlpha = 1.0;
            dataSet.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
            dataSet.drawFilledEnabled = YES;
            [dataSets addObject:dataSet];
        }
    }
    NSMutableArray *endVals = [[NSMutableArray alloc] init];
    [endVals addObject:[[ChartDataEntry alloc] initWithX:(total_days + 5) y:0]];
    LineChartDataSet *endSet = [[LineChartDataSet alloc] initWithValues:endVals label:@""];
    [dataSets addObject:endSet];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    data.highlightEnabled = YES;
    _chartView.data = data;
    if (_showCount != 0) {
        CGFloat scale = (CGFloat)total_days/(CGFloat)_showCount;
        if (_scaleX >= 0) {
            scale = _scaleX;
        }
        NSInteger index = total_days;
        if (_xIndex >= 0) {
            index = _xIndex + 3;
        }
        [_chartView zoomWithScaleX:scale scaleY:1 xValue:index yValue:0 axis:AxisDependencyLeft];

    }else{
        [_chartView zoomWithScaleX:1 scaleY:1 xValue:total_days yValue:0 axis:AxisDependencyLeft];
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
