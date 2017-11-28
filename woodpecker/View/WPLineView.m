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
@property (nonatomic, assign) CGFloat maxTemp;
@property (nonatomic, assign) CGFloat minTemp;

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
        leftAxis.labelTextColor = kColor_8;
        leftAxis.labelFont = kFont_3(14);
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.drawZeroLineEnabled = YES;
        leftAxis.granularityEnabled = YES;
        leftAxis.drawAxisLineEnabled = YES;
        leftAxis.gridLineWidth = 0.5;
        leftAxis.axisMaximum = _maxTemp;
        leftAxis.axisMinimum = _minTemp;
        leftAxis.labelCount = 15;
        leftAxis.granularity = 0.1;
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
        rightAxis.labelTextColor = kColor_8;
        rightAxis.labelFont = kFont_3(14);
        rightAxis.drawGridLinesEnabled = YES;
        rightAxis.granularityEnabled = YES;
        rightAxis.drawAxisLineEnabled = YES;
        rightAxis.drawZeroLineEnabled = YES;
        rightAxis.gridLineWidth = 0.5;
        rightAxis.axisMaximum = _maxTemp;
        rightAxis.axisMinimum = _minTemp;
        rightAxis.labelCount = 15;
        rightAxis.granularity = 0.1;
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
        xAxis.labelFont = kFont_3(8);;
        xAxis.labelTextColor = kColor_7;
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
        _maxTemp = 38;
        _minTemp = 35;
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
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = kColor_8;
    _dateLabel.font = kFont_3(8);
    _dateLabel.text = kLocalization(@"common_date");
    [self addSubview:_dateLabel];
    
    _periodLabel = [[UILabel alloc] init];
    _periodLabel.backgroundColor = [UIColor clearColor];
    _periodLabel.textColor = kColor_8;
    _periodLabel.font = kFont_3(8);
    _periodLabel.text = kLocalization(@"common_period");
    [self addSubview:_periodLabel];
    _chartView = [[ LineChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_chartView];
    _chartView.delegate = self;
    _chartView.descriptionText = @"";
    _chartView.noDataText = kLocalization(@"common_nodata");
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:NO];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.backgroundColor = [UIColor clearColor];
    _chartView.pinchZoomEnabled = NO;
    _chartView.scaleYEnabled = NO;
    _chartView.scaleXEnabled = NO;
    _chartView.maxVisibleCount = 30;
    _marker = [[BalloonMarker alloc] initWithTextColor:kColorFromRGB(0x777777) font:[UIFont systemFontOfSize:14] insets:UIEdgeInsetsMake(4.0, 14.0, 8.0, 14.0)];
    _marker.minimumSize = CGSizeMake(60.f, 30.f);
    _marker.isInt = YES;
    _marker.color = kColorFromRGB(0xffffff);
    _marker.borderColor = kColorFromRGB(0x777777);
    _marker.arrowSize = CGSizeMake(7, 4);
    _chartView.marker = _marker;
    [_chartView animateWithXAxisDuration:0];
    _showCount = 15;
    _periodLabel.frame = CGRectMake(0, self.height - 9, self.width, 10);
    _dateLabel.frame = CGRectMake(0, self.height - 18, self.width, 10);
    self.layer.masksToBounds = NO;
    _periodLabel.hidden = YES;
    _dateLabel.hidden = YES;

}

- (void)setShowCount:(NSInteger)showCount{
    _showCount = showCount;
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelCount = showCount;
}

- (void)updateChartData:(NSMutableArray *)sortTemps{
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSInteger total_days = 0;
    if (sortTemps.count > 0) {
        WPTemperatureModel *lastTemp = [[sortTemps lastObject] lastObject];
        NSDate *today = [NSDate dateFromString:[NSDate stringFromDate:[NSDate date]] format:DATE_FORMATE_STRING];
        NSDate *startDate = [NSDate dateWithTimeIntervalSince2000:[lastTemp.time longLongValue]];
        startDate =[NSDate dateFromString:[NSDate stringFromDate:startDate] format:DATE_FORMATE_STRING];
        _formatter.startDate = startDate;
       total_days = [NSDate daysFromDate:startDate toDate:today];
        NSMutableArray *startVals = [[NSMutableArray alloc] init];
        if (total_days < 30) {
            [startVals addObject:[[ChartDataEntry alloc] initWithX:total_days - 30 y:0]];
        }else{
            [startVals addObject:[[ChartDataEntry alloc] initWithX:-1 y:0]];
        }
        LineChartDataSet *startSet = [[LineChartDataSet alloc] initWithValues:startVals label:@""];
        [dataSets addObject:startSet];
        for (NSInteger i = sortTemps.count - 1; i >= 0; i --) {
            NSArray *temps = [sortTemps objectAtIndex:i];
            NSMutableArray *yVals = [[NSMutableArray alloc] init];
            PeriodType period_type = kPeriodTypeOfSafe;
            for (NSInteger j = temps.count -1; j >= 0; j --) {
                WPTemperatureModel *temp = [temps objectAtIndex:j];
                NSDate *date = [NSDate dateFromString:temp.date format:DATE_FORMATE_STRING];
                CGFloat x = [NSDate daysFromDate:startDate toDate:date];
                if (yVals.count == 0) {
                    period_type = temp.period_type;
                }
                double temperature = [temp.temp doubleValue];
                if (temperature > _maxTemp) {
                    temperature = _maxTemp;
                }
                if (temperature < _minTemp) {
                    temperature = _minTemp;
                }
                [yVals addObject:[[ChartDataEntry alloc] initWithX:x y:round(temperature*100)/100.0]];
            }
            NSString *title = kLocalization(@"period_safe");
            UIColor *linefillColor = [UIColor clearColor];
            UIColor *linefillEndColor = [UIColor clearColor];
            UIColor *lineColor = [UIColor clearColor];
            switch (period_type) {
                case kPeriodTypeOfForecast:
                case kPeriodTypeOfMenstrual:
                    title = kLocalization(@"period_menstrual");
                    lineColor = kColor_5;
                    linefillColor = kColor_5_With_Alpha(0.8);
                    linefillEndColor = kColor_5_With_Alpha(0.2);
                    break;
                case kPeriodTypeOfOviposit:
                    title = kLocalization(@"period_oviposit");
                    linefillColor = kColor_15;
                    lineColor = kColor_15_With_Alpha(0.8);
                    linefillEndColor = kColor_15_With_Alpha(0.2);
                    break;
                    
                case kPeriodTypeOfPregnancy:
                    title = kLocalization(@"period_pregnancy");
                    lineColor = kColor_18;
                    linefillColor = kColor_18_With_Alpha(0.8);
                    linefillEndColor = kColor_18_With_Alpha(0.2);
                    break;
                default:
                    title = kLocalization(@"period_safe");
                    lineColor = kColor_17;
                    linefillColor = kColor_17_With_Alpha(0.8);
                    linefillEndColor = kColor_17_With_Alpha(0.2);
                    break;
            }
            LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:yVals label:title];
            dataSet.axisDependency = AxisDependencyLeft;
            [dataSet setColor:lineColor];
            [dataSet setCircleColor:lineColor];
            dataSet.fillColor = lineColor;
            dataSet.highlightColor = lineColor;
            dataSet.circleHoleColor = lineColor;
            NSArray *gradientColors = @[(id)linefillEndColor.CGColor,(id)linefillColor.CGColor];
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
        NSMutableArray *endVals = [[NSMutableArray alloc] init];
        [endVals addObject:[[ChartDataEntry alloc] initWithX:(total_days + 1) y:0]];
        LineChartDataSet *endSet = [[LineChartDataSet alloc] initWithValues:endVals label:@""];
        [dataSets addObject:endSet];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.whiteColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        data.highlightEnabled = YES;
        _chartView.data = data;
        if (_showCount != 0) {
            if (total_days < 30) {
                total_days = 30;
            }
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
        _periodLabel.hidden = NO;
        _dateLabel.hidden = NO;
    }else{
        _chartView.data = nil;
        _periodLabel.hidden = YES;
        _dateLabel.hidden = YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
