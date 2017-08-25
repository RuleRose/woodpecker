//
//  UNICServerTime.m
//  unicorn
//
//  Created by 肖君 on 16/12/13.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "UNICNetworkAgent.h"
#import "UNICServerTime.h"

@implementation UNICServerTime
Singleton_Implementation(UNICServerTime);

- (void)syncServerTime {
    [[UNICNetworkAgent defaultInstance] getServerTime:^(NSError *error, NSDictionary *dic) {
      if (!error) {
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
          NSDate *serverDate = [dateFormatter dateFromString:[dic leie_getObjectByPath:@"utc_time"]];
          self.secondsAheadLocalTime = [[NSDate date] timeIntervalSince1970] - [serverDate timeIntervalSince1970];
      }
    }];
}

- (NSString *)displayStringFromServerString:(NSString *)serverStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *serverDate = [dateFormatter dateFromString:serverStr];
    NSDate *displayDate = [NSDate dateWithTimeInterval:self.secondsAheadLocalTime sinceDate:serverDate];
    return [dateFormatter stringFromDate:displayDate];
}

- (NSString *)serverStringFromDisplayString:(NSString *)displayStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *displayDate = [dateFormatter dateFromString:displayStr];
    NSDate *serverDate = [NSDate dateWithTimeInterval:(-self.secondsAheadLocalTime) sinceDate:displayDate];

    return [dateFormatter stringFromDate:serverDate];
}
@end
