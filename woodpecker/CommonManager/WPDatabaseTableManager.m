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
@property(nonatomic, strong) NSString *latestDBVersion;
@property(nonatomic, strong) NSString *preDBVersion;
@property(nonatomic, assign) NSInteger latestVersion;
@property(nonatomic, assign) NSInteger preVersion;
@end

@implementation WPDatabaseTableManager
Singleton_Implementation(WPDatabaseTableManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        _latestDBVersion = @"4";
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
    //    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:USER_DEFAULT_DATABASE_VERSION];

//    self.preDBVersion = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DATABASE_VERSION];
//    NSString *userMode = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_MODE];
//    if (!userMode) {
//        //新装APP，后续版本可以去掉。因为第一版没有DB version，用userMode来判断是否是新安装。
//        //新装APP，不需要迁移数据。
//        [[NSUserDefaults standardUserDefaults] setObject:self.latestDBVersion forKey:USER_DEFAULT_DATABASE_VERSION];
//    } else if (!self.preDBVersion) {
//        //从第一版本升级。
//        [[NSUserDefaults standardUserDefaults] setObject:self.latestDBVersion forKey:USER_DEFAULT_DATABASE_VERSION];
//        self.preVersion = 1;
//        self.latestVersion = [self.latestDBVersion integerValue];
//        [self updateDataBase];
//    } else if (![self.preDBVersion isEqualToString:self.latestDBVersion]) {
//        //从非第一版本升级。
//        [[NSUserDefaults standardUserDefaults] setObject:self.latestDBVersion forKey:USER_DEFAULT_DATABASE_VERSION];
//        self.preVersion = [self.preDBVersion integerValue];
//        self.latestVersion = [self.latestDBVersion integerValue];
//        [self updateDataBase];
//    }
}

- (void)updateDataBase {
//    switch (self.preVersion) {
//        case 1: {
//            NSString *updateSQL = @"alter table UNICCommonOrderModel add is_temperature_uploaded INTEGER default 1";
//            [[XJFDBOperator defaultInstance] executeSQLs:updateSQL];
//
//            NSString *updateSQL2 = @"alter table UNICCommonTemperatureModel add order_pid TEXT";
//            [[XJFDBOperator defaultInstance] executeSQLs:updateSQL2];
//
//            UNICCommonOrderModel *orderCondition = [[UNICCommonOrderModel alloc] init];
//            orderCondition.order_type = 2;
//            NSArray<UNICCommonOrderModel *> *data = [XJFDBManager searchModelsWithCondition:orderCondition andpage:-1 andOrderby:nil isAscend:NO];
//            for (UNICCommonOrderModel *order in data) {
//                NSString *updateSQL3 =
//                    [NSString stringWithFormat:@"update UNICCommonTemperatureModel set order_pid = '%@' where order_id = %ld", order.pid, (long)order.order_id];
//                [[UNICDBOperator defaultInstance] executeSQLs:updateSQL3];
//            }
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
