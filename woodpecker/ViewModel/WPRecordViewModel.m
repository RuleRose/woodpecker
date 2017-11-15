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
            status.title = kLocalization(@"menstrual_title");
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 1){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            if (!_period_day.isMenstruationSwitchOffValide) {
                status.title = kLocalization(@"menstrual_start");
            }else{
                status.title = kLocalization(@"menstrual_end");
            }
            status.showSwitch = YES;
            status.icon = @"icon-record-menses";
            status.showLine = NO;
            [_statuses addObject:status];
        }else if (i == 2){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"menstrual_detail");
            status.icon = @"icon-record-details";
            [_statuses addObject:status];
        }else if (i == 3){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_pregnant");
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 4){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_mucus");
            status.icon = @"icon-record-mucus";
            status.showLine = NO;
            [_statuses addObject:status];
        }else if (i == 5){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_love");
            status.icon = @"icon-record-love";
            [_statuses addObject:status];
        }else if (i == 6){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_ct");
            status.icon = @"icon-record-ct";
            [_statuses addObject:status];
        }else if (i == 7){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_day");
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 8){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_sleep");
            status.icon = @"icon-record-sleep";
            status.showLine = NO;
            [_statuses addObject:status];
        }else if (i == 9){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_mood");
            status.icon = @"icon-record-mood";
            [_statuses addObject:status];
        }else if (i == 10){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_sport");
            status.icon = @"icon-record-sport";
            [_statuses addObject:status];
        }else if (i == 11){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"userinfo_weight");
            status.icon = @"icon-record-weight";
            status.showDetailEnable = NO;
            [_statuses addObject:status];
        }else if (i == 12){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_drink");
            status.icon = @"icon-record-drink";
            [_statuses addObject:status];
        }else if (i == 13){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_drug");
            status.icon = @"icon-record-drug";
            [_statuses addObject:status];
        }else if (i == 14){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = kLocalization(@"record_comments");
            status.icon = @"icon-record-note";
            status.showDetailEnable = NO;
            [_statuses addObject:status];
        }
    }
}

- (NSString *)getThemeWithRecordTheme:(WPRecordTheme)theme{
    switch (theme) {
        case kWPRecordThemeOfColor:
            return kLocalization(@"record_color");
        case kWPRecordThemeOfFlow:
            return kLocalization(@"record_flow");
        case kWPRecordThemeOfPain:
            return kLocalization(@"record_pain");
        case kWPRecordThemeOfGore:
            return kLocalization(@"record_gore");
        case kWPRecordThemeOfMucusProb:
            return kLocalization(@"record_mucusprob");
        case kWPRecordThemeOfMucusFlow:
            return kLocalization(@"record_mucusflow");
        case kWPRecordThemeOfLove:
            return @"";
        case kWPRecordThemeOfCT:
            return @"";
        case kWPRecordThemeOfSleep:
            return kLocalization(@"record_quality");
        case kWPRecordThemeOfMood:
            return @"";
        case kWPRecordThemeOfSport:
            return kLocalization(@"record_sport_time");
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
            return @[kLocalization(@"record_color_l"),kLocalization(@"record_color_f"),kLocalization(@"record_color_d")];
        case kWPRecordThemeOfFlow:
            return @[kLocalization(@"record_flow_f"),kLocalization(@"record_flow_n"),kLocalization(@"record_flow_m")];
        case kWPRecordThemeOfPain:
            return @[kLocalization(@"record_pain_f"),kLocalization(@"record_pain_n"),kLocalization(@"record_pain_m")];
        case kWPRecordThemeOfGore:
            return @[kLocalization(@"record_gore_f"),kLocalization(@"record_gore_n"),kLocalization(@"record_gore_m")];
        case kWPRecordThemeOfMucusProb:
            return @[kLocalization(@"record_mucusprob_d"),kLocalization(@"record_mucusprob_t"),kLocalization(@"record_mucusprob_b")];
        case kWPRecordThemeOfMucusFlow:
            return @[kLocalization(@"record_mucusflow_f"),kLocalization(@"record_mucusflow_n"),kLocalization(@"record_mucusflow_m")];
        case kWPRecordThemeOfLove:
            return @[kLocalization(@"record_love_n"),kLocalization(@"record_love_m"),kLocalization(@"record_love_c")];
        case kWPRecordThemeOfCT:
            return @[kLocalization(@"record_ct_i"),kLocalization(@"record_ct_n"),kLocalization(@"record_ct_p")];
        case kWPRecordThemeOfSleep:
            return @[kLocalization(@"record_sleep_g"),kLocalization(@"record_sleep_n"),kLocalization(@"record_sleep_b")];
        case kWPRecordThemeOfMood:
            return @[kLocalization(@"record_mood_p"),kLocalization(@"record_mood_h"),kLocalization(@"record_mood_s"),kLocalization(@"record_mood_d"),kLocalization(@"record_mood_f"),kLocalization(@"record_mood_a"),kLocalization(@"record_mood_r"),kLocalization(@"record_mood_o")];
        case kWPRecordThemeOfSport:
            return @[kLocalization(@"record_sport_0"),kLocalization(@"record_sport_1"),kLocalization(@"record_sport_2")];
        case kWPRecordThemeOfDrink:
            return @[kLocalization(@"record_drink_l"),kLocalization(@"record_drink_n"),kLocalization(@"record_drink_b")];
        case kWPRecordThemeOfDrug:
            return @[kLocalization(@"record_drug_t"),kLocalization(@"record_drug_c"),kLocalization(@"record_drug_p"),kLocalization(@"record_drug_i"),kLocalization(@"record_drug_s"),kLocalization(@"record_drug_a")];
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
    BOOL changed = NO;
    if (![NSString leie_isBlankString:_event.color] || ![NSString leie_isBlankString:_event.flow] || ![NSString leie_isBlankString:_event.pain] || ![NSString leie_isBlankString:_event.gore]) {
        
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"1" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.color) {
            if (![NSString leie_isBlankString:_event.color]) {
                [description setObject:_event.color forKey:@"color"];
            }
            if (![_event.color isEqualToString:event.color]) {
                changed = YES;
            }
            
        }
        if (_event.flow) {
            if (![NSString leie_isBlankString:_event.flow]) {
                [description setObject:_event.flow forKey:@"flow"];
            }
            if (![_event.flow isEqualToString:event.flow]) {
                changed = YES;
            }
        }
        if (_event.pain) {
            if (![NSString leie_isBlankString:_event.pain]) {
                [description setObject:_event.pain forKey:@"pain"];
            }
            if (![_event.pain isEqualToString:event.pain]) {
                changed = YES;
            }
        }
        if (_event.gore) {
            if (![NSString leie_isBlankString:_event.gore]) {
                [description setObject:_event.gore forKey:@"gore"];
            }
            if (![_event.gore isEqualToString:event.gore]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.color] || ![NSString leie_isBlankString:event.flow] || ![NSString leie_isBlankString:event.pain] || ![NSString leie_isBlankString:event.gore]) {
            [delEvents addObject:event.event_id1];
        }
    }
    
    if (![NSString leie_isBlankString:_event.mucus_prob] || ![NSString leie_isBlankString:_event.mucus_flow] || ![NSString leie_isBlankString:_event.love] || ![NSString leie_isBlankString:_event.ct]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"2" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.mucus_prob) {
            if (![NSString leie_isBlankString:_event.mucus_prob]) {
                [description setObject:_event.mucus_prob forKey:@"mucus_prob"];
            }
            if (![_event.mucus_prob isEqualToString:event.mucus_prob]) {
                changed = YES;
            }
        }
        if (_event.mucus_flow) {
            if (![NSString leie_isBlankString:_event.mucus_flow]) {
                [description setObject:_event.mucus_flow forKey:@"mucus_flow"];
            }
            if (![_event.mucus_flow isEqualToString:event.mucus_flow]) {
                changed = YES;
            }
        }
        if (_event.love) {
            if (![NSString leie_isBlankString:_event.love]) {
                [description setObject:_event.love forKey:@"love"];
            }
            if (![_event.love isEqualToString:event.love]) {
                changed = YES;
            }
        }
        if (_event.ct) {
            if (![NSString leie_isBlankString:_event.ct]) {
                [description setObject:_event.ct forKey:@"test_paper"];
            }
            if (![_event.ct isEqualToString:event.ct]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.mucus_prob] || ![NSString leie_isBlankString:event.mucus_flow] || ![NSString leie_isBlankString:event.love] || ![NSString leie_isBlankString:event.ct]) {
            [delEvents addObject:event.event_id2];
        }
    }
    if (![NSString leie_isBlankString:_event.sleep]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"3" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.sleep) {
            if (![NSString leie_isBlankString:_event.sleep]) {
                [description setObject:_event.sleep forKey:@"quality"];
            }
            if (![_event.sleep isEqualToString:event.sleep]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.sleep]) {
            [delEvents addObject:event.event_id3];
        }
    }
    if (![NSString leie_isBlankString:_event.mood]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"4" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.mood) {
            if (![NSString leie_isBlankString:_event.mood]) {
                [description setObject:_event.mood forKey:@"motion"];
            }
            if (![_event.mood isEqualToString:event.mood]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.mood]) {
            [delEvents addObject:event.event_id4];
        }
    }
    if (![NSString leie_isBlankString:_event.sport]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"5" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.sport) {
            if (![NSString leie_isBlankString:_event.sport]) {
                [description setObject:_event.sport forKey:@"time"];
            }
            if (![_event.sport isEqualToString:event.sport]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.sport]) {
            [delEvents addObject:event.event_id5];
        }
    }
    if (![NSString leie_isBlankString:_event.drink]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"6" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.drink) {
            if (![NSString leie_isBlankString:_event.drink]) {
                [description setObject:_event.drink forKey:@"status"];
            }
            if (![_event.drink isEqualToString:event.drink]) {
                changed  = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.drink]) {
            [delEvents addObject:event.event_id6];
        }
    }
    if (![NSString leie_isBlankString:_event.drug]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"7" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.drug) {
            if (![NSString leie_isBlankString:_event.drug]) {
                [description setObject:_event.drug forKey:@"type"];
            }
            if (![_event.drug isEqualToString:event.drug]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.drug]) {
            [delEvents addObject:event.event_id7];
        }
    }
    if (![NSString leie_isBlankString:_event.comments]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"8" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.comments) {
            if (![NSString leie_isBlankString:_event.comments]) {
                [description setObject:_event.comments forKey:@"comments"];
            }
            if (![_event.comments isEqualToString:event.comments]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.comments]) {
            [delEvents addObject:event.event_id8];
        }
    }
    if (![NSString leie_isBlankString:_event.weight]) {
        NSMutableDictionary *eventDic = [[NSMutableDictionary alloc] init];
        [eventDic setObject:@"9" forKey:@"type"];
        [eventDic setObject:[NSDate stringFromDate:_eventDate] forKey:@"date"];
        NSMutableDictionary *description = [[NSMutableDictionary alloc] init];
        if (_event.weight) {
            if (![NSString leie_isBlankString:_event.weight]) {
                [description setObject:_event.weight forKey:@"weight"];
            }
            if (![_event.weight isEqualToString:event.weight]) {
                changed = YES;
            }
        }
        [eventDic setObject:[NSString getJSONString:description] forKey:@"description"];
        [events addObject:eventDic];
    }else{
        if (![NSString leie_isBlankString:event.weight]) {
            [delEvents addObject:event.event_id8];
        }
    }
    if (changed == NO && delEvents.count == 0) {
        if (result) {
            result(YES);
        }
        return;
    }
    __block NSInteger count = 0;
    WPUserModel *user = [[WPUserModel alloc] init];
    [user loadDataFromkeyValues:kDefaultObjectForKey(USER_DEFAULT_ACCOUNT_USER)];
    if (changed) {
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
            if (result) {
                result(NO);
            }
        }];
    }
    for (NSString *event_id in delEvents) {
        [WPNetInterface deleteEvent:event_id user_id:user.user_id success:^(BOOL finished) {
            WPEventItemModel *item = [[WPEventItemModel alloc] init];
            item.pid = event_id;
            [XJFDBManager deleteModel:item dependOnKeys:nil];
            count ++;
            if (changed) {
                if (count == delEvents.count + 1) {
                    if (result) {
                        result(YES);
                    }
                }
            }else{
                if (count == delEvents.count) {
                    if (result) {
                        result(YES);
                    }
                }
            }
        } failure:^(NSError *error) {
            if (result) {
                result(NO);
            }
        }];
    }
}

- (void)updatePeriodSuccess:(void (^)(BOOL finished,BOOL needUpdate))result{
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
                        WPPeriodModel *update_period = [[WPPeriodModel alloc] init];
                        [update_period loadDataFromkeyValues:periodDic];
                        update_period.period_end = period.period_end;
                        update_period.pid = update_period.period_id;
                        if ([update_period.removed boolValue]) {
                            [XJFDBManager deleteModel:update_period dependOnKeys:nil];
                        }else{
                            if (![update_period insertToDB]) {
                                [update_period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES,YES);
                    }
                } failure:^(NSError *error) {
                    if (result) {
                        result(NO,NO);
                    }
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
                                WPPeriodModel *update_period = [[WPPeriodModel alloc] init];
                                [update_period loadDataFromkeyValues:periodDic];
                                update_period.period_end = period.period_end;
                                update_period.pid = update_period.period_id;
                                if ([update_period.removed boolValue]) {
                                    [XJFDBManager deleteModel:update_period dependOnKeys:nil];
                                }else{
                                    if (![update_period insertToDB]) {
                                        [update_period updateToDBDependsOn:nil];
                                    }
                                }
                            }
                            if (result) {
                                result(YES,YES);
                            }
                        } failure:^(NSError *error) {
                            if (result) {
                                result(NO,NO);
                            }
                        }];
                    }else{
                        //create
                        WPPeriodModel *period = [[WPPeriodModel alloc] init];
                        period.period_start = [NSDate stringFromDate:_eventDate];
                        [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                            for (NSDictionary *periodDic in periods) {
                                WPPeriodModel *create_period = [[WPPeriodModel alloc] init];
                                [create_period loadDataFromkeyValues:periodDic];
                                create_period.pid = create_period.period_id;
                                if ([create_period.removed boolValue]) {
                                    [XJFDBManager deleteModel:create_period dependOnKeys:nil];
                                }else{
                                    if (![create_period insertToDB]) {
                                        [create_period updateToDBDependsOn:nil];
                                    }
                                }
                            }
                            if (result) {
                                result(YES,YES);
                            }
                        } failure:^(NSError *error) {
                            if (result) {
                                result(NO,NO);
                            }
                        }];
                    }
                }else{
                    //delete
                    WPPeriodModel *period = [[WPPeriodModel alloc] init];
                    period.period_id = currentPeriod.period_id;
                    [WPNetInterface deletePeriod:period.period_id success:^(NSArray *periods) {
                        for (NSDictionary *periodDic in periods) {
                            WPPeriodModel *delete_period = [[WPPeriodModel alloc] init];
                            [delete_period loadDataFromkeyValues:periodDic];
                            delete_period.pid = delete_period.period_id;
                            if ([delete_period.removed boolValue]) {
                                [XJFDBManager deleteModel:delete_period dependOnKeys:nil];
                            }else{
                                if (![delete_period insertToDB]) {
                                    [delete_period updateToDBDependsOn:nil];
                                }
                            }
                        }
                        if (result) {
                            result(YES,YES);
                        }
                    } failure:^(NSError *error) {
                        if (result) {
                            result(NO,NO);
                        }
                    }];
                }
            }
        }else{
            if (result) {
                result(YES,NO);
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
                        WPPeriodModel *update_period = [[WPPeriodModel alloc] init];
                        [update_period loadDataFromkeyValues:periodDic];
                        update_period.pid = update_period.period_id;
                        update_period.period_end = period.period_end;
                        if ([update_period.removed boolValue]) {
                            [XJFDBManager deleteModel:update_period dependOnKeys:nil];
                        }else{
                            if (![update_period insertToDB]) {
                                [update_period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES,NO);
                    }
                } failure:^(NSError *error) {
                    if (result) {
                        result(NO,NO);
                    }
                }];
            }else{
                WPPeriodModel *period = [[WPPeriodModel alloc] init];
                period.period_start = [NSDate stringFromDate:_eventDate];
                [WPNetInterface postPeriod:user.user_id period_start:period.period_start period_end:period.period_end success:^(NSArray *periods) {
                    for (NSDictionary *periodDic in periods) {
                        WPPeriodModel *create_period = [[WPPeriodModel alloc] init];
                        [create_period loadDataFromkeyValues:periodDic];
                        create_period.pid = create_period.period_id;
                        if ([create_period.removed boolValue]) {
                            [XJFDBManager deleteModel:create_period dependOnKeys:nil];
                        }else{
                            if (![create_period insertToDB]) {
                                [create_period updateToDBDependsOn:nil];
                            }
                        }
                    }
                    if (result) {
                        result(YES,YES);
                    }
                } failure:^(NSError *error) {
                    if (result) {
                        result(NO,NO);
                    }
                }];
            }
        }else{
            if (result) {
                result(YES,NO);
            }
        }
    }
}
@end
