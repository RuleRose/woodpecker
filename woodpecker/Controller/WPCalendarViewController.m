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
@property(nonatomic,strong)NSDate *selectedDate;

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
        [_calendar.appearance setHeaderDateFormat:@"M月"];
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
    [self setupData];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
    [_calendar selectDate:_selectedDate];
    _calendar.currentPage = _selectedDate;
    [self configureVisibleCells];
    [_calendar reloadData];
}

- (void)goBack:(UIButton *)sender{
    CATransition *transition = [CATransition pushFromRight:nil];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setupData{
//    [[WPPeriodCountManager defaultInstance] recountPeriod];
    _viewModel = [[WPCalendarViewModel alloc] init];
    if (!_selectedDate) {
        _selectedDate = [NSDate date];
    }
}

- (void)setupViews{
    _weekdayView = [[FSCalendarWeekdayView alloc] initWithFrame:CGRectMake(0, kStatusHeight + kNavigationHeight, kScreen_Width, 52)];
    _weekdayView.backgroundColor = kColor_4;
    _weekdayView.weekdays = @[ @"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
    _weekdayView.calendar = self.calendar;
    [self.view addSubview:_weekdayView];
    [_weekdayView configureAppearance];
    [self.view addSubview:self.calendar];
    _calendar.currentPage = [NSDate date];
    self.title = [NSDate stringFromDate:[NSDate date]format:@"yyyy年M月"];
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
    return [NSDate dateFromString:@"2017-01-01" format:@"yyyy-MM-dd"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return  [NSDate nextMonthOfDate:[NSDate date]];
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
    if ([NSDate isDateAfterToday:date]) {
        return;
    }
    _selectedDate = date;
    WPCalendarDetailViewController *detailVC = [[WPCalendarDetailViewController alloc] init];
    detailVC.selectedDate = date;
    detailVC.delegate = self;
    detailVC.periodDic = _viewModel.periodDic;
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
    if ([cell isKindOfClass:[WPCalendarCell class]]) {
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
        NSString *dateStr = [NSDate stringFromDate:date];
        WPDayInfoInPeriod *period = [_viewModel.periodDic objectForKey:dateStr];
        if(!period){
             period = [[WPPeriodCountManager defaultInstance] dayInfo:date];
            [_viewModel.periodDic setObject:period forKey:dateStr];
        }
        calendarCell.period = period.type;
        if (period.type == kPeriodTypeOfOviposit) {
            calendarCell.shape = kPeriodShapeOfCircle;
        }else{
            NSDate *tomorrow = [NSDate dateByAddingDays:1 toDate:date];
            NSDate *yesterday = [NSDate dateByAddingDays:-1 toDate:date];
            NSString *tomorrow_dateStr = [NSDate stringFromDate:tomorrow];
            WPDayInfoInPeriod *tomorrow_period = [_viewModel.periodDic objectForKey:tomorrow_dateStr];
            if(!tomorrow_period){
                tomorrow_period = [[WPPeriodCountManager defaultInstance] dayInfo:tomorrow];
                [_viewModel.periodDic setObject:tomorrow_period forKey:tomorrow_dateStr];
            }
            NSString *yesterday_dateStr = [NSDate stringFromDate:yesterday];
            WPDayInfoInPeriod *yesterday_period = [_viewModel.periodDic objectForKey:yesterday_dateStr];
            if(!yesterday_period){
                yesterday_period = [[WPPeriodCountManager defaultInstance] dayInfo:yesterday];
                [_viewModel.periodDic setObject:yesterday_period forKey:yesterday_dateStr];
            }
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
