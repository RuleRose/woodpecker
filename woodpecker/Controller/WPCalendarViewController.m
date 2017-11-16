//
//  WPCalendarViewController.m
//  woodpecker
//
//  Created by QiWL on 2017/9/15.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPCalendarViewController.h"
#import "WPCalendarViewModel.h"
#import "FSCalendar.h"
#import "NSDate+Extension.h"
#import "WPCalendarCell.h"
#import "WPCalendarDetailViewController.h"
#import "WPCalendarNoteView.h"
#import "CATransition+PageTransition.h"
#import "WPPeriodCountManager.h"

@interface WPCalendarViewController ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, WPCalendarDetailDelegate>
@property (nonatomic, strong) WPCalendarViewModel *viewModel;
@property (nonatomic, strong) FSCalendar* calendar;
@property (nonatomic, strong) FSCalendarWeekdayView* weekdayView;
@property (nonatomic, strong) WPCalendarNoteView *noteView;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) BOOL appeared;

@end

@interface FSCalendarWeekdayView (Extension)

@property (readwrite, nonatomic) FSCalendar *calendar;

@end

@implementation WPCalendarViewController
- (FSCalendar*)calendar
{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, _weekdayView.bottom, kScreen_Width, kScreen_Height - _weekdayView.bottom - 52)];
        _calendar.backgroundColor = kColorFromRGB(0xffffff);
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.pagingEnabled = NO;
        _calendar.allowsMultipleSelection = NO;
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        [_calendar.appearance setWeekdayTextColor:kColor_7];
        _calendar.firstWeekday = 1;
        [_calendar.appearance setTitleFont:kFont_1(12)];
        [_calendar.appearance setHeaderTitleFont:kFont_2(23)];
        [_calendar.appearance setHeaderTitleColor:kColor_7];
        [_calendar.appearance setHeaderDateFormat:kLocalization(@"calendar_header_dateformat")];
        [_calendar.appearance setWeekdayFont:kFont_1(12)];
        [_calendar.appearance setSubtitleFont:kFont_2(12)];
        _calendar.weekdayHeight = 0;
        _calendar.rowHeight = 48;
        _calendar.headerHeight = 56;
        _calendar.swipeToChooseGesture.enabled = YES;
        _calendar.calendarHeaderView.hidden = YES;
        _calendar.today = [NSDate date];
        [_calendar registerClass:[WPCalendarCell class] forCellReuseIdentifier:@"cell"];
        _calendar.accessibilityIdentifier = @"calendar";
    }
    return _calendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColor_2;
    _appeared = NO;
    [self setupData];
    [self setupViews];
    self.calendar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[XJFHUDManager defaultInstance] showLoadingHUDwithCallback:^{
        
    }];
    [self performSelector:@selector(showCalendar) withObject:nil afterDelay:0];
}

- (void)showCalendar{
    _calendar.hidden = NO;
    _appeared = YES;
    [_calendar selectDate:_selectedDate];
    _calendar.currentPage = _selectedDate;
    [_calendar reloadData];
    [[XJFHUDManager defaultInstance] hideLoading];
}


- (void)goBack:(UIButton *)sender{
    CATransition *transition = [CATransition revealFromRight:nil];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setupData{
    _viewModel = [[WPCalendarViewModel alloc] init];
    if (!_selectedDate) {
        _selectedDate = [NSDate date];
    }
}

- (void)setupViews{
    _weekdayView = [[FSCalendarWeekdayView alloc] initWithFrame:CGRectMake(0, kStatusHeight + kNavigationHeight, kScreen_Width, 52)];
    _weekdayView.backgroundColor = kColor_4;
    _weekdayView.weekdays = @[kLocalization(@"common_sunday_abbr"), kLocalization(@"common_monday_abbr"), kLocalization(@"common_tuesday_abbr"), kLocalization(@"common_wednesday_abbr"), kLocalization(@"common_thursday_abbr"), kLocalization(@"common_friday_abbr"), kLocalization(@"common_saturday_abbr") ];
    _weekdayView.calendar = self.calendar;
    [self.view addSubview:_weekdayView];
    [_weekdayView configureAppearance];
    [self.view addSubview:self.calendar];
    _calendar.currentPage = [NSDate date];
    self.title = [NSDate stringFromDate:[NSDate date]format:kLocalization(@"calendar_title_dateformat")];
    _noteView = [[WPCalendarNoteView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 52, kScreen_Width, 52)];
    _noteView.backgroundColor = kColor_3;
    [self.view addSubview:_noteView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDelegate
#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate dateFromString:DATE_STAERT format:DATE_FORMATE_STRING];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate endOfMonthOfDate:[NSDate nextMonthOfDate:[NSDate date]]];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return nil;
}

- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    if ([NSDate isDateInToday:date]) {
        return kLocalization(@"common_today");
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
//    if ([NSDate isDateAfterToday:date]) {
//        return;
//    }
    _selectedDate = date;
    WPCalendarDetailViewController *detailVC = [[WPCalendarDetailViewController alloc] init];
    detailVC.selectedDate = date;
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES
     ];
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self configureVisibleCells];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    if (calendar.currentPage) {
        self.title = [NSDate stringFromDate:calendar.currentPage format:kLocalization(@"calendar_title_dateformat")];
    }else{
        self.title = [NSDate stringFromDate:[NSDate date]format:kLocalization(@"calendar_title_dateformat")];
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
    if ([cell isKindOfClass:[WPCalendarCell class]] && _appeared) {
        WPCalendarCell *calendarCell = (WPCalendarCell *)cell;
        if (calendarCell.selected) {
            calendarCell.titleLabel.font = kFont_6(16);
            calendarCell.titleLabel.textColor = kColor_10;
            calendarCell.subtitleLabel.textColor = kColor_10;
            calendarCell.shapeLayer.fillColor = kColor_12.CGColor;
            calendarCell.shapeLayer.opacity = 1;
            
        }else{
            calendarCell.titleLabel.font = kFont_1(12);
            calendarCell.subtitleLabel.textColor = kColor_7;
            calendarCell.shapeLayer.fillColor = [UIColor clearColor].CGColor;
            calendarCell.shapeLayer.opacity = 0;
        }
        WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:date];
        calendarCell.period = period.type;
        if (period.type == kPeriodTypeOfOviposit) {
            calendarCell.shape = kPeriodShapeOfCircle;
        }else{
            NSDate *tomorrow = [NSDate dateByAddingDays:1 toDate:date];
            NSDate *yesterday = [NSDate dateByAddingDays:-1 toDate:date];
            WPDayInfoInPeriod *tomorrow_period = [[WPPeriodCountManager defaultInstance] dayInfo:tomorrow];
            WPDayInfoInPeriod *yesterday_period = [[WPPeriodCountManager defaultInstance] dayInfo:yesterday];
            NSInteger weekday = [NSDate weekdayOfDate:date];
            if (weekday == 1 || [NSDate isDate:date equalToDate:[NSDate beginingOfMonthOfDate:date] toCalendarUnit:NSCalendarUnitDay]) {
                if (tomorrow_period.type == period.type) {
                    if (tomorrow_period.dayInPeriod  == 1) {
                        calendarCell.shape = kPeriodShapeOfSingle;
                    }else{
                        calendarCell.shape = kPeriodShapeOfLeft;
                    }
                }else{
                    calendarCell.shape = kPeriodShapeOfSingle;
                }
            }else if (weekday == 7 || [NSDate isDate:date equalToDate:[NSDate endOfMonthOfDate:date] toCalendarUnit:NSCalendarUnitDay]){
                if (yesterday_period.type == period.type) {
                    if (period.dayInPeriod  == 1) {
                        calendarCell.shape = kPeriodShapeOfSingle;
                    }else{
                        calendarCell.shape = kPeriodShapeOfRight;
                    }
                }else{
                    calendarCell.shape = kPeriodShapeOfSingle;
                }
            }else{
                if ((yesterday_period.type == period.type) && (tomorrow_period.type == period.type)) {
                    if (tomorrow_period.dayInPeriod  == 1) {
                        calendarCell.shape = kPeriodShapeOfRight;
                    }else if (period.dayInPeriod  == 1) {
                        calendarCell.shape = kPeriodShapeOfLeft;
                    }else{
                        calendarCell.shape = kPeriodShapeOfMiddle;
                    }
                }else if(yesterday_period.type == period.type){
                    if (period.dayInPeriod  == 1) {
                        calendarCell.shape = kPeriodShapeOfSingle;
                    }else{
                        calendarCell.shape = kPeriodShapeOfRight;
                    }
                }else if(tomorrow_period.type == period.type){
                    if (tomorrow_period.dayInPeriod  == 1) {
                        calendarCell.shape = kPeriodShapeOfSingle;
                    }else{
                        calendarCell.shape = kPeriodShapeOfLeft;
                    }
                }else{
                    calendarCell.shape = kPeriodShapeOfSingle;
                }
            }
        }
        [calendarCell setNeedsLayout];
    }
}

#pragma mark WPCalendarDetailDelegate
- (void)updateSelectedDate:(NSDate *)date{
    _selectedDate = date;
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
