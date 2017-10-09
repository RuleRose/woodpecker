//
//  WPRecordViewModel.h
//  woodpecker
//
//  Created by QiWL on 2017/9/14.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPRecordViewModel : NSObject
@property (nonatomic,strong) NSMutableArray *statuses;
@property (nonatomic,strong) NSMutableDictionary *themeDic;
- (NSString *)getThemeWithRecordTheme:(WPRecordTheme)theme;
- (NSArray *)getTitlesWithRecordTheme:(WPRecordTheme)theme;
- (NSString *)getThemeTypeWithRecordTheme:(WPRecordTheme)theme;
- (NSString *)getDetailWithRecordTheme:(WPRecordTheme)theme index:(NSInteger)index;
- (NSInteger)getDetailIndexWithRecordTheme:(WPRecordTheme)theme;
- (void)setTheme:(WPRecordTheme)theme index:(NSInteger)index;
@end
