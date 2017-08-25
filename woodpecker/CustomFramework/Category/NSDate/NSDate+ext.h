//
//  NSDate+ext.h
//  mmcS2
//
//  Created by 肖君 on 16/11/7.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ext)
+ (instancetype)dateWithTimeIntervalSince2000:(NSTimeInterval)secs;
- (NSTimeInterval)timeIntervalSince2000;

+ (instancetype)dateOfDisplayString:(NSString*)dateStr;
- (NSString*)displayStringOfDate;

- (BOOL)isToday;
@end
