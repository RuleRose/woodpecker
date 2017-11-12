//
//  WPStatusView.m
//  woodpecker
//
//  Created by QiWL on 2017/9/10.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPStatusView.h"
#import "MMCDeviceManager.h"
#import "NSDate+Extension.h"
#import "XJFDBManager.h"
#import "WPPeriodCountManager.h"

@implementation WPStatusView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedDate = [NSDate date];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = kColor_7;
    _dateLabel.font = kFont_2(23);
    [self addSubview:_dateLabel];
    _periodLabel = [[UILabel alloc] init];
    _periodLabel.backgroundColor = [UIColor clearColor];
    _periodLabel.textColor = kColor_7;
    _periodLabel.font = kFont_2(23);
    [self addSubview:_periodLabel];
    _tempLabel = [[UILabel alloc] init];
    _tempLabel.backgroundColor = [UIColor clearColor];
    _tempLabel.textColor = kColor_7;
    _tempLabel.text = kLocalization(@"temperature_nodata");
    [self addSubview:_tempLabel];
    _tempUnitLabel = [[UILabel alloc] init];
    _tempUnitLabel.backgroundColor = [UIColor clearColor];
    _tempUnitLabel.textColor = kColor_7;
    _tempUnitLabel.font = kFont_2(23);
    _tempUnitLabel.text = @"°C";
    [self addSubview:_tempUnitLabel];
    _tempEditBtn = [[UIButton alloc] init];
    _tempEditBtn.backgroundColor = [UIColor clearColor];
    [_tempEditBtn setImage:kImage(@"icon-status-edit") forState:UIControlStateNormal];
    [_tempEditBtn addTarget:self action:@selector(tempEditBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tempEditBtn];
    _wheelView = [[WPStatusWheelView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
    _wheelView.backgroundColor = [UIColor clearColor];
    _wheelView.delegate = self;
    [self addSubview:_wheelView];
    _indexView = [[WPStatusItemView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 170, (kScreen_Width - 125)/2, 80)];
    _indexView.backgroundColor = [UIColor clearColor];
    [self addSubview:_indexView];
    _timeView = [[WPStatusItemView alloc] initWithFrame:CGRectMake(_indexView.right, kScreen_Height - 170, 125, 80)];
    _timeView.backgroundColor = [UIColor clearColor];
    [self addSubview:_timeView];
    _recordView = [[WPStatusItemView alloc] initWithFrame:CGRectMake(_timeView.right, kScreen_Height - 170, (kScreen_Width - 125)/2, 80)];
    _recordView.backgroundColor = [UIColor clearColor];
    [self addSubview:_recordView];
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(_indexView.right, _indexView.top + 16, 0.5, 47)];
    leftLine.backgroundColor = kColor_9_With_Alpha(0.1);
    [self addSubview:leftLine];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(_timeView.right, _indexView.top + 16, 0.5, 47)];
    rightLine.backgroundColor = kColor_9_With_Alpha(0.1);
    [self addSubview:rightLine];
    
    _calendarBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 33, 33)];
    _calendarBtn.backgroundColor = [UIColor clearColor];
    [_calendarBtn setImage:kImage(@"btn-navi-status-cale") forState:UIControlStateNormal];
    [_calendarBtn addTarget:self action:@selector(calendarBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_calendarBtn];
    _tempBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - 53, 20, 33, 33)];
    _tempBtn.backgroundColor = [UIColor clearColor];
    [_tempBtn setImage:kImage(@"btn-navi-device-add") forState:UIControlStateNormal];
    [_tempBtn addTarget:self action:@selector(tempBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tempBtn];
    _todayBtn = [[UIButton alloc] initWithFrame:CGRectMake(_tempBtn.left - 48, 20, 33, 33)];
    _todayBtn.backgroundColor = [UIColor clearColor];
    [_todayBtn setImage:kImage(@"btn-navi-status-today") forState:UIControlStateNormal];
    [_todayBtn addTarget:self action:@selector(todayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_todayBtn];

    
    [_indexView setTitle:kLocalization(@"period_pregnancy_index") detail:@"" unit:@"%" showNext:NO];
    [_timeView setTitle:kLocalization(@"period_pregnancy_distance") detail:@"" unit:kLocalization(@"common_day_unit") showNext:NO];
    [_recordView setTitle:kLocalization(@"record_title") detail:@"0" unit:kLocalization(@"common_record_unit") showNext:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRecord)];
    [_recordView addGestureRecognizer:tap];
    _todayBtn.hidden = YES;
}

- (void)resetTemp:(NSString *)temp{
    if ([NSString leie_isBlankString:temp]) {
        temp = kLocalization(@"temperature_nodata");
        _tempLabel.font = kFont_4(48);
    }else{
        _tempLabel.font = kFont_4(84);
    }
    _tempLabel.text = temp;
    CGSize size = [_tempLabel.text sizeWithFont:_tempLabel.font];
    if (kDevice_is_iPhone5 || kDevice_is_iPhone4) {
        _dateLabel.frame = CGRectMake(25, kScreen_Height - 350, self.width - 50, 33);
    }else{
        _dateLabel.frame = CGRectMake(25, kScreen_Height - 400, self.width - 50, 33);
    }
    _periodLabel.frame = CGRectMake(25, _dateLabel.bottom, self.width - 50, 35);
    _tempLabel.frame = CGRectMake(25, _periodLabel.bottom, size.width, 106);
    _tempUnitLabel.frame = CGRectMake(_tempLabel.right + 12, _tempLabel.top + 14, 40, 38);
    _tempEditBtn.frame = CGRectMake(_tempLabel.right + 12, _tempUnitLabel.bottom, 33, 33);

}

- (void)setViewModel:(WPStatusViewModel *)viewModel{
    _viewModel = viewModel;
//    _wheelView.viewModel = viewModel;
}

- (void)todayBtnPressed{
    [_wheelView scrollToBottom];
}

- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    _wheelView.startDate = startDate;
}

- (void)showRecord{
    if (_delegate && [_delegate respondsToSelector:@selector(showEventWithDate:)]) {
        [_delegate showEventWithDate:_selectedDate];
    }
}

- (void)calendarBtnPressed{
    if (_delegate && [_delegate respondsToSelector:@selector(showCalendar)]) {
        [_delegate showCalendar];
    }
}

- (void)tempBtnPressed{
    if (_delegate && [_delegate respondsToSelector:@selector(showTemperature)]) {
        [_delegate showTemperature];
    }
}

- (void)tempEditBtnPressed{
    if (_delegate && [_delegate respondsToSelector:@selector(editTemperature:date:)]) {
        [_delegate editTemperature:_temperature date:_selectedDate];
    }
}

- (void)updateState{
    if ([NSDate isDateInToday:_selectedDate]) {
        _todayBtn.hidden = YES;
    }else{
        _todayBtn.hidden = NO;
    }
    [_wheelView updateData];
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    switch ([MMCDeviceManager defaultInstance].deviceConnectionState) {
        case STATE_DEVICE_CONNECTING:
        case STATE_DEVICE_DISCONNECTING:
            [_tempBtn setImage:kImage(@"btn-navi-device-connecting") forState:UIControlStateNormal];

            break;
        case STATE_DEVICE_CONNECTED:
            [_tempBtn setImage:kImage(@"btn-navi-device-con") forState:UIControlStateNormal];
            break;
        default:
            if ([NSString leie_isBlankString:user.device_id] ) {
                [_tempBtn setImage:kImage(@"btn-navi-device-add") forState:UIControlStateNormal];
            }else{
                [_tempBtn setImage:kImage(@"btn-navi-device-nc") forState:UIControlStateNormal];
            }
            break;
    }
    WPDayInfoInPeriod *period_day = [[WPPeriodCountManager defaultInstance] dayInfo:_selectedDate];
    [self showDetailDate:_selectedDate period:period_day];
}

#pragma mark WPStatusWheelViewDelegate
- (void)showDetailDate:(NSDate *)date period:(WPDayInfoInPeriod *)period_day{
    _selectedDate = date;
    _dateLabel.text =  [NSDate stringFromDate:date format:kLocalization(@"status_dateformate")];
    switch (period_day.type) {
        case kPeriodTypeOfForecast:
            _periodLabel.text = kLocalization(@"period_forecast");
            break;
        case kPeriodTypeOfMenstrual:
             _periodLabel.text = kLocalization(@"period_menstrual");
            break;
        case kPeriodTypeOfOviposit:
             _periodLabel.text = kLocalization(@"period_oviposit");
            break;
            
        case kPeriodTypeOfPregnancy:
             _periodLabel.text = kLocalization(@"period_pregnancy");
            break;
        default:
            _periodLabel.text = kLocalization(@"period_safe");
            break;
    }
    //取某天的记录
    NSInteger eventCount = [_viewModel eventCountAtDate:date];
    if (period_day.type == kPeriodTypeOfMenstrual) {
        if ((!period_day.isForecast && period_day.isStart) || (!period_day.isEndDayForecast && period_day.isEnd)) {
            eventCount ++;
        }
    }
    [_recordView setTitle:kLocalization(@"record_title") detail:[NSString stringWithFormat:@"%ld",(long)eventCount] unit:kLocalization(@"common_record_unit") showNext:YES];
    [_timeView setTitle:kLocalization(@"period_pregnancy_distance") detail: [NSString stringWithFormat:@"%ld",(long)period_day.dayBeforePregnantPeriod] unit:kLocalization(@"common_day_unit") showNext:NO];
    
    //某日温度
    _temperature = [_viewModel getTempWithDate:date];
    [self resetTemp:_temperature.temp];
    if ([NSDate isDateInToday:date]) {
        _todayBtn.hidden = YES;
    }else{
        _todayBtn.hidden = NO;
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
