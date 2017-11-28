//
//  WPDatabaseTableManager.m
//  mmcS2
//
//  Created by 肖君 on 16/10/25.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "WPDatabaseTableManager.h"
#import "WPTemperatureModel.h"
#import "WPEventItemModel.h"
#import "XJFDBManager.h"
#import "XJFDBOperator.h"
#import "WPPeriodUpdateModel.h"
#import "WPPeriodModel.h"

@interface WPDatabaseTableManager ()
@property(nonatomic, assign) NSInteger latestVersion;
@property(nonatomic, assign) NSInteger preVersion;
@end

@implementation WPDatabaseTableManager
Singleton_Implementation(WPDatabaseTableManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        _latestVersion = 1;
    }
    return self;
}

- (void)initDatabase {
    NSArray *DBTableArray = @[ [WPTemperatureModel class], [WPEventItemModel class], [WPPeriodUpdateModel class], [WPPeriodModel class]];

    for (Class model in DBTableArray) {
        /**
         *  创建表格
         *  注意，mode中的类型nstring/nsinteger/cgfloat，并且命名必须全部小写。
         *
         *  @param className 表明
         *
         *  @return 是否成功
         */
        [XJFDBManager createTableWithModel:model];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DATABASE_VERSION]) {
        //新装app不用升级
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_latestVersion] forKey:USER_DEFAULT_DATABASE_VERSION];
    } else if (_latestVersion != [[[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DATABASE_VERSION] integerValue]) {
        //从非第一版本升级。
        self.preVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DATABASE_VERSION] integerValue];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_latestVersion] forKey:USER_DEFAULT_DATABASE_VERSION];
        [self updateDataBase];
    }
}

- (void)updateDataBase {
//    switch (self.preVersion) {
//        case 1: {
//        } break;
//        default:
//            break;
//    }
//
//    self.preVersion++;
//    if (self.preVersion >= self.latestVersion) {
//        return;
//    } else {
//        [self updateDataBase];
//    }
}
@end
