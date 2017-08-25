//
//  UNICServerTime.h
//  unicorn
//
//  Created by 肖君 on 16/12/13.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNICServerTime : NSObject
Singleton_Interface(UNICServerTime);
@property(nonatomic, assign) NSTimeInterval secondsAheadLocalTime;

- (void)syncServerTime;
- (NSString *)displayStringFromServerString:(NSString *)serverStr;
- (NSString *)serverStringFromDisplayString:(NSString *)displayStr;
@end
