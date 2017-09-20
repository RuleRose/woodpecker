//
//  WPRecordViewModel.m
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "WPRecordViewModel.h"
#import "WPRecordStatusModel.h"

@implementation WPRecordViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _statuses = [[NSMutableArray alloc] init];
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
                [_statuses addObject:status];
            }
        }
    }
    return self;
}
@end
