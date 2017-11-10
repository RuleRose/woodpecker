//
//  WPRecordViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordViewModel.h"
#import "WPRecordStatusModel.h"
#import "WPEventModel.h"
#import "WPNetInterface.h"
#import "NSDate+Extension.h"
#import "WPUserModel.h"
#import "WPPeriodUpdateModel.h"
#import "XJFDBManager.h"
#import "WPEventItemModel.h"
#import "WPPeriodCountManager.h"
#import "WPPeriodCountModel.h"
#import "NSString+JSON.h"

@implementation WPRecordViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statuses = [[NSMutableArray alloc] init];
//        _periods = [self getPeriods];
 }
    return self;
}

- (void)setEvent:(WPEventModel *)event{
    _event = event;
    [self reloadDatas];
}

- (void)reloadDatas{
    _period_day = [[WPPeriodCountManager defaultInstance] dayInfo:_eventDate];
    if (_period_day.type == kPeriodTypeOfMenstrual) {
        if ((!_period_day.isForecast && _period_day.isStart) || (!_period_day.isEndDayForecast && _period_day.isEnd)) {
            _on = YES;
        }else{
            _on = NO;
        }
    }else{
        _on = NO;
    }
    //statuses
    for (NSInteger i = 0; i < 15; i ++) {
        if (i == 0) {
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"经期";
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 1){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            if (!_period_day.isMenstruationSwitchOffValide) {
                status.title = @"经期开始";
            }else{
                status.title = @"经期结束";
            }
            status.showSwitch = YES;
            status.icon = @"icon-record-menses";
            status.showLine = NO;
            [_statuses addObject:status];
        }else if (i == 2){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"经期详情";
            status.icon = @"icon-record-details";
            [_statuses addObject:status];
        }else if (i == 3){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"备用";
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 4){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"宫颈粘液";
            status.icon = @"icon-record-mucus";
            status.showLine = NO;
            [_statuses addObject:status];
        }else if (i == 5){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"同房记录";
            status.icon = @"icon-record-love";
            [_statuses addObject:status];
        }else if (i == 6){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"排卵试纸";
            status.icon = @"icon-record-ct";
            [_statuses addObject:status];
        }else if (i == 7){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"日常";
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 8){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"睡眠";
            status.icon = @"icon-record-sleep";
            status.showLine = NO;
            [_statuses addObject:status];
        }else if (i == 9){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"情绪";
            status.icon = @"icon-record-mood";
            [_statuses addObject:status];
        }else if (i == 10){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"运动";
            status.icon = @"icon-record-sport";
            [_statuses addObject:status];
        }else if (i == 11){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"体重";
            status.icon = @"icon-record-weight";
            status.showDetailEnable = NO;
            [_statuses addObject:status];
        }else if (i == 12){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"饮酒";
            status.icon = @"icon-record-drink";
            [_statuses addObject:status];
        }else if (i == 13){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"服药";
            status.icon = @"icon-record-drug";
            [_statuses addObject:status];
        }else if (i == 14){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"备注";
            status.icon = @"icon-record-note";
            status.showDetailEnable = NO;
            [_statuses addObject:status];
        }
    }
}

- (NSString *)getThemeWithRecordTheme:(WPRecordTheme)theme{
    switch (theme) {
        case kWPRecordThemeOfColor:
            return @"颜色";
        case kWPRecordThemeOfFlow:
            return @"流量";
        case kWPRecordThemeOfPain:
            return @"痛经";
        case kWPRecordThemeOfGore:
            return @"血块";
        case kWPRecordThemeOfMucusProb:
            return @"性状";
        case kWPRecordThemeOfMucusFlow:
            return @"量";
        case kWPRecordThemeOfLove:
            return @"";
        case kWPRecordThemeOfCT:
            return @"";
        case kWPRecordThemeOfSleep:
            return @"质量";
        case kWPRecordThemeOfMood:
            return @"";
        case kWPRecordThemeOfSport:
            return @"时长";
        case kWPRecordThemeOfDrink:
            return @"";
        case kWPRecordThemeOfDrug:
            return @"";
        default:
            return @"";
    }
}

- (NSArray *)getTitlesWithRecordTheme:(WPRecordTheme)theme{
    switch (theme) {
        case kWPRecordThemeOfColor:
            return @[@"淡红",@"鲜红",@"深红"];
        case kWPRecordThemeOfFlow:
            return @[@"较少",@"中等",@"较多"];
        case kWPRecordThemeOfPain:
            return @[@"轻度",@"中度",@"重度"];
        case kWPRecordThemeOfGore:
            return @[@"无",@"较少",@"较多"];
        case kWPRecordThemeOfMucusProb:
            return @[@"发干",@"粘稠",@"拉丝"];
        case kWPRecordThemeOfMucusFlow:
            return @[@"较少",@"中等",@"较多"];
        case kWPRecordThemeOfLove:
            return @[@"无措施",@"避孕药",@"避孕套"];
        case kWPRecordThemeOfCT:
            return @[@"无效",@"阴性",@"阳性"];
        case kWPRecordThemeOfSleep:
            return @[@"很好",@"一般",@"较差"];
        case kWPRecordThemeOfMood:
            return @[@"平静",@"开心",@"伤感",@"郁闷",@"烦躁",@"焦虑",@"愤怒",@"其它"];
        case kWPRecordThemeOfSport:
            return @[@"<0.5小时",@"0.5-1小时",@">1小时"];
        case kWPRecordThemeOfDrink:
            return @[@"小酌",@"微醉",@"大醉"];
        case kWPRecordThemeOfDrug:
            return @[@"中药",@"感冒药",@"止疼药",@"消炎药",@"肠胃药",@"避孕药"];
        default:
            return nil;
    }
}

- (NSString *)getThemeTypeWithRecordTheme:(WPRecordTheme)theme{
    switch (theme) {
        case kWPRecordThemeOfColor:
            return @"color";
        case kWPRecordThemeOfFlow:
            return @"flow";
        case kWPRecordThemeOfPain:
            return @"pain";
        case kWPRecordThemeOfGore:
            return @"gore";
        case kWPRecordThemeOfMucusProb:
            return @"mucus_prob";
        case kWPRecordThemeOfMucusFlow:
            return @"mucus_flow";
        case kWPRecordThemeOfLove:
            return @"love";
        case kWPRecordThemeOfCT:
            return @"test_paper";
        case kWPRecordThemeOfSleep:
            return @"quality";
        case kWPRecordThemeOfMood:
            return @"motion";
        case kWPRecordThemeOfSport:
            return @"time";
        case kWPRecordThemeOfDrink:
            return @"status";
        case kWPRecordThemeOfDrug:
            return @"type";
        case kWPRecordThemeOfComments:
            return @"comments";
        case kWPRecordThemeOfWeight:
            return @"weight";
    }
}

- (WPRecordTheme)getThemeWIthDetaiType:(NSString *)detail_type{
    if ([@"color" isEqualToString:detail_type]) {
        return kWPRecordThemeOfColor;
    }else if ([@"flow" isEqualToString:detail_type]){
        return kWPRecordThemeOfFlow;
    }else if ([@"pain" isEqualToString:detail_type]){
        return kWPRecordThemeOfPain;
    }else if ([@"gore" isEqualToString:detail_type]){
        return kWPRecordThemeOfGore;
    }else if ([@"mucus_prob" isEqualToString:detail_type]){
        return kWPRecordThemeOfMucusProb;
    }else if ([@"mucus_flow" isEqualToString:detail_type]){
        return kWPRecordThemeOfMucusFlow;
    }else if ([@"love" isEqualToString:detail_type]){
        return kWPRecordThemeOfLove;
    }else if ([@"test_paper" isEqualToString:detail_type]){
        return kWPRecordThemeOfCT;
    }else if ([@"quality" isEqualToString:detail_type]){
        return kWPRecordThemeOfSleep;
    }else if ([@"motion" isEqualToString:detail_type]){
        return kWPRecordThemeOfMood;
    }else if ([@"time" isEqualToString:detail_type]){
        return kWPRecordThemeOfSport;
    }else if ([@"status" isEqualToString:detail_type]){
        return kWPRecordThemeOfDrink;
    }else if ([@"type" isEqualToString:detail_type]){
        return kWPRecordThemeOfDrug;
    }else if ([@"weight" isEqualToString:detail_type]){
        return kWPRecordThemeOfWeight;
    }else{
        return kWPRecordThemeOfComments;
    }
}

- (NSString *)getDetailWithRecordTheme:(WPRecordTheme)theme index:(NSInteger)index{
    NSArray *details = [self getDetailsWithTheme:theme];
    if ([details count] > index) {
        return [details objectAtIndex:index];
    }
    return @"";
}

- (NSInteger)getSelectedIndexWithRecordTheme:(WPRecordTheme)theme detai:(NSString *)detail{
    NSArray *details = [self getDetailsWithTheme:theme];
    if (![NSString leie_isBlankString:detail] && details && [details containsObject:detail]) {
        return [details indexOfObject:detail];
    }
    return -1;
}

- (void)setTheme:(WPRecordTheme)theme index:(NSInteger)index{
    NSArray *details = [self getDetailsWithTheme:theme];
    if ([details count] > index && index >= 0) {
        NSString *detail = [details objectAtIndex:index];
        [_event setTheme:theme detail:detail];
    }
}

- (void)setTheme:(WPRecordTheme)theme detail:(NSString *)detail{
    [_event setTheme:theme detail:detail];
}

- (NSArray *)getDetailsWithTheme:(WPRecordTheme)theme{
    NSArray *details;
    switch (theme) {
        case kWPRecordThemeOfColor:
            details = @[@"L",@"F",@"D"];
            break;
        case kWPRecordThemeOfFlow:
            details = @[@"F",@"N",@"M"];
            break;
        case kWPRecordThemeOfPain:
            details = @[@"F",@"N",@"M"];
            break;
        case kWPRecordThemeOfGore:
            details = @[@"F",@"N",@"M"];
            break;
        case kWPRecordThemeOfMucusProb:
            details = @[@"D",@"T",@"B"];
            break;
        case kWPRecordThemeOfMucusFlow:
            details = @[@"F",@"N",@"M"];
            break;
        case kWPRecordThemeOfLove:
            details = @[@"N",@"M",@"C"];
            break;
        case kWPRecordThemeOfCT:
            details = @[@"I",@"N",@"P"];
            break;
        case kWPRecordThemeOfSleep:
            details = @[@"G",@"N",@"B"];
            break;
        case kWPRecordThemeOfMood:
            details = @[@"P",@"H",@"S",@"D",@"F",@"A",@"R",@"O"];
            break;
        case kWPRecordThemeOfSport:
            details = @[@"0",@"1",@"2"];
            break;
        case kWPRecordThemeOfDrink:
            details = @[@"L",@"N",@"B"];
            break;
        case kWPRecordThemeOfDrug:
            details = @[@"T",@"C",@"P",@"I",@"S",@"A"];
            break;
        default:
            break;
    }
    return details;
}

- (NSString *)getDetailWithEventTheme:(WPRecordTheme)theme{
    NSString *detail= nil;
    switch (theme) {
        case kWPRecordThemeOfColor:
            detail = _event.color;
            break;
        case kWPRecordThemeOfFlow:
            detail = _event.flow;
            break;
        case kWPRecordThemeOfPain:
            detail = _event.pain;
            break;
        case kWPRecordThemeOfGore:
            detail = _event.gore;
            break;
        case kWPRecordThemeOfMucusProb:
            detail = _event.mucus_prob;
            break;
        case kWPRecordThemeOfMucusFlow:
            detail = _event.mucus_flow;
            break;
        case kWPRecordThemeOfLove:
            detail = _event.love;
            break;
        case kWPRecordThemeOfCT:
            detail = _event.ct;
            break;
        case kWPRecordThemeOfSleep:
            detail = _event.sleep;
            break;
        case kWPRecordThemeOfMood:
            detail = _event.mood;
            break;
        case kWPRecordThemeOfSport:
            detail = _event.sport;
            break;
        case kWPRecordThemeOfDrink:
            detail = _event.drink;
            break;
        case kWPRecordThemeOfDrug:
            detail = _event.drug;
            break;
        case kWPRecordThemeOfComments:
            detail = _event.comments;
            break;
        case kWPRecordThemeOfWeight:
            detail = _event.weight;
            break;
    }
    return detail;
}

- (WPEventModel *)getEventWithDate:(NSDate *)date{
    WPEventModel *event = [[WPEventModel alloc] init];
    WPEventItemModel *item = [[WPEventItemModel alloc] init];
    item.date = [NSDate stringFromDate:_eventDate];
    NSArray *items = [XJFDBManager searchModelsWithCondition:item andpage:-1 andOrderby:nil isAscend:YES];
    for (WPEventItemModel *item in items) {
        if (![NSString leie_isBlankString:item.brief]) {
            NSDictionary *breifDic =[NSString getDictionary:item.brief];
            for (NSString *key in breifDic) {
                [event setTheme:[self getThemeWIthDetaiType:key] detail:[breifDic objectForKey:key]];
            }
            if ([item.type integerValue] == 1) {
                event.event_id1 = item.event_id;
            }else if ([item.type integerValue] == 2){
                event.event_id2 = item.event_id;

            }else if ([item.type integerValue] == 3){
                event.event_id3 = item.event_id;

            }else if ([item.type integerValue] == 4){
                event.event_id4 = item.event_id;

            }else if ([item.type integerValue] == 5){
                event.event_id5 = item.event_id;

            }else if ([item.type integerValue] == 6){
                event.event_id6 = item.event_id;

            }else if ([item.type integerValue] == 7){
                event.event_id7 = item.event_id;

            }else if ([item.type integerValue] == 8){
                event.event_id8 = item.event_id;
            }
        }
    }
    return event;
}

- (void)updateEventSuccess:(void (^)(BOOL finished))result{
    NSMutableArray *events = [[NSMutableArray alloc] init];
    NSMutableArray *delEvents = [[NSMutableArray alloc] init];
    WPEventModel *event = [self getEventWithDate:_eventDate];
    if (_event.color || _event.flow || _event.pain || _event.gore) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"1" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.color) {
            [description setObject:_event.color forKey:@"color"];
        }
        if (_event.flow) {
            [description setObject:_event.flow forKey:@"flow"];
        }
        if (_event.pain) {
            [description setObject:_event.pain forKey:@"pain"];
        }
        if (_event.gore) {
            [description setObject:_event.gore forKey:@"gore"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.color || event.flow || event.pain || event.gore) {
            [delEvents addObject:event.event_id1];
        }
    }
    
    if (_event.mucus_prob || _event.mucus_flow || _event.love || _event.ct) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"2" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.mucus_prob) {
            [description setObject:_event.mucus_prob forKey:@"mucus_prob"];
        }
        if (_event.mucus_flow) {
            [description setObject:_event.mucus_flow forKey:@"mucus_flow"];
        }
        if (_event.love) {
            [description setObject:_event.love forKey:@"love"];
        }
        if (_event.ct) {
            [description setObject:_event.ct forKey:@"test_paper"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.mucus_prob || event.mucus_flow || event.love || event.ct) {
            [delEvents addObject:event.event_id2];
        }
    }
    if (_event.sleep) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"3" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.sleep) {
            [description setObject:_event.sleep forKey:@"quality"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.sleep) {
            [delEvents addObject:event.event_id3];
        }
    }
    if (_event.mood) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"4" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.mood) {
            [description setObject:_event.mood forKey:@"motion"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.mood) {
            [delEvents addObject:event.event_id4];
        }
    }
    if (_event.sport) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"5" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.sport) {
            [description setObject:_event.sport forKey:@"time"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.sport) {
            [delEvents addObject:event.event_id5];
        }
    }
    if (_event.drink) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"6" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.drink) {
            [description setObject:_event.drink forKey:@"status"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.drink) {
            [delEvents addObject:event.event_id6];
        }
    }
    if (_event.drug) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"7" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.drug) {
            [description setObject:_event.drug forKey:@"type"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.drug) {
            [delEvents addObject:event.event_id7];
        }
    }
    if (_event.comments) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"8" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.comments) {
            [description setObject:_event.comments forKey:@"comments"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.comments) {
            [delEvents addObject:event.event_id8];
        }
    }
    if (_event.weight) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"9" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.weight) {
            [description setObject:_event.weight forKey:@"weight"];
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (event.comments) {
            [delEvents addObject:event.event_id8];
        }
    }
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    __block NSInteger count = 0;
    [WPNetInterface postEvents:events user_id:user.user_id success:^(NSArray *events) {
        for (NSDictionary *eventDic in events) {
            WPEventItemModel *item = [[WPEventItemModel alloc] init];
            [item loadDataFromkeyValues:eventDic];
            item.pid = item.event_id;
            item.brief = [eventDic objectForKey:@"description"];
            if (![item insertToDB]) {
                [item updateToDBDependsOn:nil];
            }
        }
        count ++;
        if (count == delEvents.count + 1) {
            if (result) {
                result(YES);
            }
        }
    } failure:^(NSError *error) {
        
    }];
    for (NSString *event_id in delEvents) {
        [WPNetInterface deleteEvent:event_id user_id:user.user_id success:^(BOOL finished) {
            
            count ++;
            if (count == delEvents.count + 1) {
                if (result) {
                    result(YES);
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)updatePeriodSuccess:(void (^)(BOOL finished))result{
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    WPProfileModel *profile = [[WPProfileModel alloc] init];
    [profile loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_PROFILE)];
    WPPeriodCountModel *currentPeriod = [[WPPeriodCountManager defaultInstance] getCurrentPeriodInfo:_eventDate];
    if (_period_day && currentPeriod) {
        BOOL on = NO;
        if (_period_day.type == kPeriodTypeOfMenstrual) {
            if ((!_period_day.isForecast && _period_day.isStart) || (!_period_day.isEndDayForecast && _period_day.isEnd)) {
                on = YES;
            }else{
                on = NO;
            }
        }else{
            on = NO;
        }
        if (_on != on) {
            //变化
            if (_period_day.isMenstruationSwitchOffValide) {
                //结束 update当前周期
                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                period.period_start = [NSDate stringFromDate:currentPeriod.period_start];
                period.period_end = [NSDate stringFromDate:currentPeriod.period_end];
                period.period_id = currentPeriod.period_id;
                period.brief = currentPeriod.brief;
                period.extra_data = currentPeriod.extra_data;
                period.lastupdate = currentPeriod.lastupdate;
                period.removed = currentPeriod.removed;
                if (_on) {
                    period.period_end = [NSDate stringFromDate:_eventDate];
                }else{
                    period.period_end = @"";
                }
                [WPNetInterface updatePeriod:period.period_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                    for (NSDictionary *periodDic in periods) {
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        [period loadDataFromkeyValues:periodDic];
                        period.pid = period.period_id;
                        if ([period.removed boolValue]) {
                            [XJFDBManager deleteModel:period dependOnKeys:nil];
                        }else{
                            if (![period insertToDB]) {
                                [period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES);
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else{
                //开始
                if (_on) {
                    WPPeriodCountModel *nextPeriod = [[WPPeriodCountManager defaultInstance] getNextPeriodInfo:_eventDate];
                    NSInteger days = [NSDate daysFromDate:_eventDate toDate:nextPeriod.period_start];
                    if (days <= 7 && nextPeriod && !nextPeriod.isForecast ) {
                        //update
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        period.period_start = [NSDate stringFromDate:_eventDate];
                        period.period_end = [NSDate stringFromDate:nextPeriod.period_end];
                        period.period_id = nextPeriod.period_id;
                        period.brief = nextPeriod.brief;
                        period.extra_data = nextPeriod.extra_data;
                        period.lastupdate = nextPeriod.lastupdate;
                        period.removed = nextPeriod.removed;
                        [WPNetInterface updatePeriod:period.period_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                            for (NSDictionary *periodDic in periods) {
                                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                                [period loadDataFromkeyValues:periodDic];
                                period.pid = period.period_id;
                                if ([period.removed boolValue]) {
                                    [XJFDBManager deleteModel:period dependOnKeys:nil];
                                }else{
                                    if (![period insertToDB]) {
                                        [period updateToDBDependsOn:nil];
                                    }
                                }
                            }
                            if (result) {
                                result(YES);
                            }
                        } failure:^(NSError *error) {
                            
                        }];
                    }else{
                        //create
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        period.period_start = [NSDate stringFromDate:_eventDate];
                        [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                            for (NSDictionary *periodDic in periods) {
                                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                                [period loadDataFromkeyValues:periodDic];
                                period.pid = period.period_id;
                                if ([period.removed boolValue]) {
                                    [XJFDBManager deleteModel:period dependOnKeys:nil];
                                }else{
                                    if (![period insertToDB]) {
                                        [period updateToDBDependsOn:nil];
                                    }
                                }
                            }
                            if (result) {
                                result(YES);
                            }
                        } failure:^(NSError *error) {
                            
                        }];
                    }
                }else{
                    //delete
                    WPPeriodModel *period = [[WPPeriodModel alloc] init];
                    period.period_id = currentPeriod.period_id;
                    [WPNetInterface deletePeriod:period.period_id success:^(NSArray *periods) {
                        for (NSDictionary *periodDic in periods) {
                            WPPeriodModel *period = [[WPPeriodModel alloc] init];
                            [period loadDataFromkeyValues:periodDic];
                            period.pid = period.period_id;
                            if ([period.removed boolValue]) {
                                [XJFDBManager deleteModel:period dependOnKeys:nil];
                            }else{
                                if (![period insertToDB]) {
                                    [period updateToDBDependsOn:nil];
                                }
                            }
                        }
                        if (result) {
                            result(YES);
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }
        }else{
            if (result) {
                result(YES);
            }
        }
    }else{
        //最早之前新建
        if (_on) {
            WPPeriodCountModel *nextPeriod = [[WPPeriodCountManager defaultInstance] getNextPeriodInfo:_eventDate];
            NSInteger days = [NSDate daysFromDate:_eventDate toDate:nextPeriod.period_start];
            if (days <= 7 && nextPeriod && !nextPeriod.isForecast ) {
                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                period.period_start = [NSDate stringFromDate:_eventDate];
                period.period_end = [NSDate stringFromDate:nextPeriod.period_end];
                period.period_id = nextPeriod.period_id;
                period.brief = nextPeriod.brief;
                period.extra_data = nextPeriod.extra_data;
                period.lastupdate = nextPeriod.lastupdate;
                period.removed = nextPeriod.removed;
                [WPNetInterface updatePeriod:period.period_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                    for (NSDictionary *periodDic in periods) {
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        [period loadDataFromkeyValues:periodDic];
                        period.pid = period.period_id;
                        if ([period.removed boolValue]) {
                            [XJFDBManager deleteModel:period dependOnKeys:nil];
                        }else{
                            if (![period insertToDB]) {
                                [period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES);
                    }
                } failure:^(NSError *error) {
                    
                }];
            }else{
                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                period.period_start = [NSDate stringFromDate:_eventDate];
                [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                    for (NSDictionary *periodDic in periods) {
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        [period loadDataFromkeyValues:periodDic];
                        period.pid = period.period_id;
                        if ([period.removed boolValue]) {
                            [XJFDBManager deleteModel:period dependOnKeys:nil];
                        }else{
                            if (![period insertToDB]) {
                                [period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES);
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }else{
            if (result) {
                result(YES);
            }
        }
    }
}
@end
