//
//  WPRecordViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPEventModel.h"

@interface WPRecordViewModel : NSObject
@property (nonatomic,strong) NSMutableArray *statuses;
@property (nonatomic,strong) WPEventModel *event;
- (NSString *)getThemeWithRecordTheme:(WPRecordTheme)theme;
- (NSArray *)getTitlesWithRecordTheme:(WPRecordTheme)theme;
- (NSString *)getThemeTypeWithRecordTheme:(WPRecordTheme)theme;
- (NSString *)getDetailWithRecordTheme:(WPRecordTheme)theme index:(NSInteger)index;
- (NSInteger)getSelectedIndexWithRecordTheme:(WPRecordTheme)theme detai:(NSString *)detail;
- (void)setTheme:(WPRecordTheme)theme index:(NSInteger)index;
- (NSString *)getDetailWithEventTheme:(WPRecordTheme)theme;
@end
