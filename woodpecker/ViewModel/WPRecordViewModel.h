//
//  WPRecordViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPEventModel.h"
#import "WPPeriodModel.h"
#import "WPProfileModel.h"

@interface WPRecordViewModel : NSObject
@property (nonatomic,strong) NSMutableArray *statuses;
@property (nonatomic,strong) NSMutableArray *periods;
@property (nonatomic,strong) WPEventModel *event;
@property (nonatomic,strong) WPPeriodModel *period;
@property (nonatomic,strong) NSDate *eventDate;
@property (nonatomic,assign) BOOL on;
@property (nonatomic,assign) BOOL isStart;

- (NSString *)getThemeWithRecordTheme:(WPRecordTheme)theme;
- (NSArray *)getTitlesWithRecordTheme:(WPRecordTheme)theme;
- (NSString *)getThemeTypeWithRecordTheme:(WPRecordTheme)theme;
- (NSString *)getDetailWithRecordTheme:(WPRecordTheme)theme index:(NSInteger)index;
- (NSInteger)getSelectedIndexWithRecordTheme:(WPRecordTheme)theme detai:(NSString *)detail;
- (void)setTheme:(WPRecordTheme)theme index:(NSInteger)index;
- (void)setTheme:(WPRecordTheme)theme detail:(NSString *)detail;
- (NSString *)getDetailWithEventTheme:(WPRecordTheme)theme;
- (NSArray *)getDetailsWithTheme:(WPRecordTheme)theme;

- (WPEventModel *)getEventWithDate:(NSDate *)date;
- (void)updateEventSuccess:(void (^)(BOOL finished))result;
- (void)updatePeriodSuccess:(void (^)(BOOL finished))result;
@end
