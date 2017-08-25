//
//  UNICOrderResendManager.h
//  unicorn
//
//  Created by 肖君 on 17/3/4.
//  Copyright © 2017年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNICOrderResendManager : NSObject
Singleton_Interface(UNICOrderResendManager);
- (void)startRetry;
@end
