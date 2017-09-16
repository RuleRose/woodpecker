//
//  WPCalendarDetailViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/16.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarDetailViewController.h"
#import "WPCalendarDetailViewModel.h"
#import "FSCalendar.h"
#import "WPCalendarCell.h"
#import "NSDate+Extension.h"

@interface WPCalendarDetailViewController ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>
@property (nonatomic, strong) WPCalendarDetailViewModel *viewModel;
@property (nonatomic, strong) FSCalendar* calendar;

@end

@implementation WPCalendarDetailViewController
- (FSCalendar*)calendar
{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, kStatusHeight + kNavigationHeight, kScreen_Width, 100)];
        _calendar.backgroundColor = kColorFromRGB(0xffffff);
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.pagingEnabled = YES;
        _calendar.allowsMultipleSelection = NO;
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.calendarWeekdayView.weekdays = @[ @"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
        [_calendar.appearance setWeekdayTextColor:kColor_7];
        _calendar.firstWeekday = 1;
        _calendar.scope = FSCalendarScopeWeek;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
        [_calendar.appearance setTitleFont:kFont_1(12)];
        [_calendar.appearance setWeekdayFont:kFont_1(12)];
        [_calendar.appearance setSubtitleFont:kFont_1(12)];
        _calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
        _calendar.weekdayHeight = 52;
        _calendar.rowHeight = 48;
        _calendar.headerHeight = 0;
        _calendar.swipeToChooseGesture.enabled = YES;
        _calendar.calendarHeaderView.hidden = YES;
        _calendar.calendarWeekdayView.backgroundColor = kColor_4;
        _calendar.today = [NSDate date];
        [_calendar registerClass:[WPCalendarCell class] forCellReuseIdentifier:@"cell"];
        _calendar.accessibilityIdentifier = @"calendar";
    }
    return _calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
    if (!_selectedDate) {
        _selectedDate = [NSDate date];
    }
    [_calendar selectDate:_selectedDate];
    _calendar.currentPage = _selectedDate;
    self.title = [NSDate stringFromDate:[NSDate date]format:@"yyyy年M月"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
}

- (void)setupData{
    _viewModel = [[WPCalendarDetailViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.calendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDelegate
#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate dateFromString:@"2016-07-08" format:@"yyyy-MM-dd"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return nil;
}

- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    if ([NSDate isDateInToday:date]) {
        return @"今天";
    }
    return nil;
}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    WPCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

#pragma mark - FSCalendarDelegate
- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(NSDate *)date{
    return 1.0;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self configureVisibleCells];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    if (calendar.currentPage) {
        self.title = [NSDate stringFromDate:calendar.currentPage format:@"yyyy年M月"];
    }else{
        self.title = [NSDate stringFromDate:[NSDate date]format:@"yyyy年M月"];
    }
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
    return [UIColor clearColor];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    return [UIColor clearColor];
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    return kColor_7;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date{
    return kColor_7;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
    return kColor_7;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date{
    return kColor_7;
}

#pragma mark - Private methods

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}


- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    if (cell.selected) {
        cell.titleLabel.font = kFont_6(16);
        cell.titleLabel.textColor = kColor_10;
        cell.subtitleLabel.textColor = kColor_10;
        cell.shapeLayer.fillColor = kColor_12.CGColor;
        cell.shapeLayer.opacity = 1;
        
    }else{
        cell.titleLabel.font = kFont_1(12);
        cell.subtitleLabel.textColor = kColor_7;
        cell.shapeLayer.fillColor = [UIColor clearColor].CGColor;
        cell.shapeLayer.opacity = 0;
    }
    [cell setNeedsLayout];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
