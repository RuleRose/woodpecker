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
        self.selectedDate = [NSDate date];
    }
    [_calendar selectDate:_selectedDate];
    _calendar.currentPage = _selectedDate;
    self.title = [NSDate stringFromDate:_selectedDate format:@"yyyy年M月"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBackBarButton];
    [self showNavigationBar];
    self.bottomLine.hidden = YES;
}

- (void)setupData{
    _viewModel = [[WPCalendarDetailViewModel alloc] init];
    _viewModel.periodDic = _periodDic;
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
    return [NSDate dateFromString:@"2017-01-01" format:@"yyyy-MM-dd"];
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
    self.selectedDate = date;
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
    cell.rightModel = kCellRightModelNone;
    cell.leftModel = kCellLeftModelNone;
    WPDayInfoInPeriod *period = [[WPPeriodCountManager defaultInstance] dayInfo:_selectedDate];
    if (indexPath.row == 0) {
        cell.titleLabel.text = [NSString stringWithFormat:@"周期第%ld天",(long)period.dayInPeriod];
        switch (period.type) {
            case kPeriodTypeOfForecast:
            case kPeriodTypeOfForecastStart:
            case kPeriodTypeOfForecastEnd:
                cell.detailLabel.text = @"预测经期";
                break;
            case kPeriodTypeOfOviposit:
                cell.detailLabel.text = @"排卵日";
                break;
            case kPeriodTypeOfMenstrual:
            case kPeriodTypeOfMenstrualStart:
            case kPeriodTypeOfMenstrualEnd:
                cell.detailLabel.text = @"月经期";
                break;
            case kPeriodTypeOfPregnancy:
            case kPeriodTypeOfPregnancyStart:
            case kPeriodTypeOfPregnancyEnd:
                cell.detailLabel.text = @"易孕期";
                break;
            case kPeriodTypeOfSafe:
                cell.detailLabel.text = @"安全期";
                break;
        }
        cell.line.hidden = YES;
    }else if (indexPath.row == 1){
        cell.titleLabel.text = @"基础体温";
         WPTemperatureModel *temperature = [_viewModel getTempWithDate:_selectedDate];
        if (temperature && ![NSString leie_isBlankString:temperature.temp]) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@°C", temperature.temp];
        }
        cell.line.hidden = YES;
    }else if (indexPath.row == 2){
        cell.titleLabel.text = @"受孕指数";
        cell.detailLabel.text = @"4%";
        cell.line.hidden = YES;
    }else if (indexPath.row == 3){
        cell.titleLabel.text = @"距离易孕期";
        cell.detailLabel.text = [NSString stringWithFormat:@"%ld天",(long)period.dayBeforePregnantPeriod];
        cell.line.hidden = YES;
    }else if (indexPath.row == 4){
        cell.titleLabel.text = @"当日记录";
        cell.detailLabel.text = [NSString stringWithFormat:@"%ld项",(long)[_viewModel eventCountAtDate:_selectedDate]];
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
