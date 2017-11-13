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
#import "WPTableViewCell.h"
#import "WPPeriodCountManager.h"
#import "WPThermometerEditViewController.h"

@interface WPCalendarDetailViewController ()<FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) WPCalendarDetailViewModel *viewModel;
@property (nonatomic, strong) FSCalendar* calendar;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation WPCalendarDetailViewController
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _calendar.bottom, kScreen_Width, kScreen_Height - _calendar.bottom)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 10)];
        headerView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = headerView;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

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
        _calendar.calendarWeekdayView.weekdays = @[kLocalization(@"common_sunday_abbr"), kLocalization(@"common_monday_abbr"), kLocalization(@"common_tuesday_abbr"), kLocalization(@"common_wednesday_abbr"), kLocalization(@"common_thursday_abbr"), kLocalization(@"common_friday_abbr"), kLocalization(@"common_saturday_abbr") ];
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
        self.selectedDate = [NSDate date];
    }
    [_calendar selectDate:_selectedDate];
    _calendar.currentPage = _selectedDate;
    self.title = [NSDate stringFromDate:_selectedDate format:kLocalization(@"calendar_detail_dateformat")];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
    [_tableView reloadData];
}

- (void)setupData{
    _viewModel = [[WPCalendarDetailViewModel alloc] init];
}

- (void)setupViews{
    [self.view addSubview:self.calendar];
    [self.view addSubview:self.tableView];
}

- (void)goBack:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(updateSelectedDate:)]) {
        [_delegate updateSelectedDate:_selectedDate];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    return [NSDate date];
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
    self.selectedDate = date;
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    [self configureVisibleCells];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    if (calendar.currentPage) {
        self.title = [NSDate stringFromDate:calendar.currentPage format:kLocalization(@"calendar_detail_dateformat")];
    }else{
        self.title = [NSDate stringFromDate:[NSDate date]format:kLocalization(@"calendar_detail_dateformat")];
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

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"ClockCell";
    WPTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)configureCell:(WPTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = kColor_10;
    cell.layer.masksToBounds = YES;
    cell.leftModel = kCellLeftModelNone;
    WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:_selectedDate];
    if (indexPath.row == 0) {
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = [NSString stringWithFormat:kLocalization(@"period_index"),(long)period.dayInPeriod];
        switch (period.type) {
            case kPeriodTypeOfForecast:
            case kPeriodTypeOfForecastStart:
            case kPeriodTypeOfForecastEnd:
                cell.detailLabel.text = kLocalization(@"period_forecast");
                break;
            case kPeriodTypeOfOviposit:
                cell.detailLabel.text = kLocalization(@"period_oviposit");
                break;
            case kPeriodTypeOfMenstrual:
            case kPeriodTypeOfMenstrualStart:
            case kPeriodTypeOfMenstrualEnd:
                cell.detailLabel.text = kLocalization(@"period_menstrual");
                break;
            case kPeriodTypeOfPregnancy:
            case kPeriodTypeOfPregnancyStart:
            case kPeriodTypeOfPregnancyEnd:
                cell.detailLabel.text = kLocalization(@"period_pregnancy");
                break;
            case kPeriodTypeOfSafe:
                cell.detailLabel.text =kLocalization(@"period_safe");
                break;
        }
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.rightModel = kCellRightModelNext;
        cell.titleLabel.text = kLocalization(@"calendar_detail_temp");
         WPTemperatureModel *temperature = [_viewModel getTempWithDate:_selectedDate];
        if (temperature && ![NSString leie_isBlankString:temperature.temp]) {
            cell.detailLabel.text = [NSString stringWithFormat:kLocalization(@"temperature_unit_c"), temperature.temp];
        }else{
            cell.detailLabel.text = kLocalization(@"temperature_nodata");
        }
        cell.line.hidden = YES;
    }else if (indexPath.row == 2){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"period_pregnancy_index");
        cell.detailLabel.text = @"";
        cell.line.hidden = YES;
    }else if (indexPath.row == 3){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"period_pregnancy_distance");
        cell.detailLabel.text = [NSString stringWithFormat:kLocalization(@"period_pregnancy_distance_unit"),(long)period.dayBeforePregnantPeriod];
        cell.line.hidden = YES;
    }else if (indexPath.row == 4){
        cell.rightModel = kCellRightModelNone;
        cell.titleLabel.text = kLocalization(@"record_today");
        cell.detailLabel.text = [NSString stringWithFormat:kLocalization(@"record_today_unit"),(long)[_viewModel eventCountAtDate:_selectedDate]];
        cell.line.hidden = YES;
    }
    [cell drawCellWithSize:CGSizeMake(kScreen_Width, [self tableView:_tableView heightForRowAtIndexPath:indexPath])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 41;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 1){
        WPTemperatureModel *temperature = [_viewModel getTempWithDate:_selectedDate];
        WPThermometerEditViewController *editVC = [[WPThermometerEditViewController alloc] init];
        editVC.date = _selectedDate;
        editVC.temperature = temperature;
        [self.navigationController pushViewController:editVC animated:YES];
    }
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
