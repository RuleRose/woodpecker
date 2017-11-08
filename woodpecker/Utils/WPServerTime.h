//
//  UNICServerTime.h
//  unicorn
//
//  Created by 肖君 on 16/12/13.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPServerTime : NSObject
Singleton_Interface(WPServerTime);

- (NSString *)displayStringFromServerString:(NSString *)serverStr;
- (NSString *)serverStringFromDisplayString:(NSString *)displayStr;
@end
