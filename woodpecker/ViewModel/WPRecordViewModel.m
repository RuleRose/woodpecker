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

@implementation WPRecordViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _statuses = [[NSMutableArray alloc] init];
        _themeDic = [[NSMutableDictionary alloc] init];
        [self setupDatas];
    }
    return self;
}

- (void)setupDatas{
    //statuses
    for (NSInteger i = 0; i < 15; i ++) {
        if (i == 0) {
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"经期";
            status.onlyTitle = YES;
            [_statuses addObject:status];
        }else if (i == 1){
            WPRecordStatusModel *status = [[WPRecordStatusModel alloc] init];
            status.title = @"经期开始";
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
            status.title = @"经期";
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
    //eventDic
    NSArray *events;
    for (WPEventModel *eventModel in events) {
        [_themeDic setObject:eventModel.detail forKey:eventModel.theme_type];
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
    }
}

- (NSString *)getDetailWithRecordTheme:(WPRecordTheme)theme index:(NSInteger)index{
    NSArray *details = [self getDetailsWithTheme:theme];
    if ([details count] > index) {
        return [details objectAtIndex:index];
    }
    return @"";
}

- (NSInteger)getDetailIndexWithRecordTheme:(WPRecordTheme)theme{
    NSString *theme_type = [self getThemeTypeWithRecordTheme:theme];
    NSString *detail = [_themeDic objectForKey:theme_type];
    NSArray *details = [self getDetailsWithTheme:theme];
    if (details && ![NSString leie_isBlankString:detail]) {
        if ([details containsObject:detail]) {
            return [details indexOfObject:detail];
        }else{
            return -1;
        }
    }else{
        return -1;
    }
}

- (void)setTheme:(WPRecordTheme)theme index:(NSInteger)index{
    NSArray *details = [self getDetailsWithTheme:theme];
    NSString *theme_type = [self getThemeTypeWithRecordTheme:theme];
    if ([details count] > index && index >= 0) {
        [_themeDic setObject:[details objectAtIndex:index] forKey:theme_type];
    }else{
        [_themeDic removeObjectForKey:theme_type];
    }
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
@end
