//
//  MMCDatabaseTableManager.h
//  mmcS2
//
//  Created by 肖君 on 16/10/25.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNICDatabaseTableManager : NSObject
Singleton_Interface(UNICDatabaseTableManager);
- (void)initDatabase;
@end
