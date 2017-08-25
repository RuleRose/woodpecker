//
//  MMCDBOperator.m
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import "XJFDBOperator.h"

@interface XJFDBOperator () {
    FMDatabaseQueue *_dbqueue;
}
@end

@implementation XJFDBOperator
Singleton_Implementation(XJFDBOperator);

- (instancetype)init {
    self = [super init];
    if (self) {
        _dbqueue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    }
    return self;
}

- (void)dealloc {
    [self close];
}

- (void)open{
    if (!_dbqueue) {
        _dbqueue = [FMDatabaseQueue databaseQueueWithPath:DATABASE_PATH];
    }
}

- (void)close {
    if (_dbqueue) {
        [_dbqueue close];
        _dbqueue = nil;
    }
}

- (BOOL)executeSQLs:(NSString *)sql {
    __block BOOL result = YES;
    [_dbqueue inDatabase:^(FMDatabase *db) {
      result = [db executeStatements:sql];
    }];
    return result;
}

- (BOOL)executeSqlsInTransaction:(NSArray *)sqls {
    if (nil == sqls || 0 == sqls.count) {
        return NO;
    }
    [_dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
      for (NSString *sql in sqls) {
          [db executeUpdate:sql];
      }
    }];
    return YES;
}

- (NSArray *)loadData:(Class)c sql:(NSString *)sql param:(NSArray *)array {
    NSArray *rows = [self loadData:sql param:array];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in rows) {
        XJFBaseModel *tmp = [[c alloc] init];
        [tmp loadDataFromkeyValues:dict];
        [list addObject:tmp];
    }
    rows = nil;

    return list;
}

- (NSArray *)loadData:(NSString *)sql param:(NSArray *)array {
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    [_dbqueue inDatabase:^(FMDatabase *db) {
      FMResultSet *result = [db executeQuery:sql withArgumentsInArray:array];
      while ([result next]) {
          NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
          for (NSString *col in result.columnNameToIndexMap.allKeys) {
              dict[col] = [result objectForColumnName:col];
          }

          [data addObject:dict];
      }
    }];

    return data;
}

- (BOOL)insertData:(XJFBaseModel *)data {
    __block BOOL result = YES;

    [_dbqueue inDatabase:^(FMDatabase *db) {

      NSArray *cols = [data transToDictionary].allKeys;

      NSMutableString *sql = [[NSMutableString alloc] init];
      if (!cols.count) {
          result = NO;
      } else {
          [sql appendFormat:@"INSERT INTO %@ (%@", [self tableNameForModel:data], cols[0]];
          for (int i = 1; i < cols.count; i++) {
              [sql appendFormat:@",%@", cols[i]];
          }
          [sql appendString:@") VALUES(?"];
          for (int i = 1; i < cols.count; i++) {
              [sql appendString:@",?"];
          }

          [sql appendString:@")"];
          NSMutableArray *array = [[NSMutableArray alloc] init];
          for (int i = 0; i < cols.count; i++) {
              id value = [data valueForKey:cols[i]];
              if ([value isKindOfClass:[NSString class]]) {
                  [array addObject:[value leie_trim]];
              } else {
                  [array addObject:value];
              }
          }
          result = [db executeUpdate:sql withArgumentsInArray:array];
      }
    }];

    return result;
}

- (void)batchInsertData:(NSArray *)dataArray {
    if (nil == dataArray || 0 == dataArray.count) {
        return;
    }
    [_dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
      BOOL result = NO;
      for (XJFBaseModel *data in dataArray) {
          NSArray *cols = [data transToDictionary].allKeys;

          NSMutableString *sql = [[NSMutableString alloc] init];
          if (!cols.count) {
              result = NO;
          } else {
              [sql appendFormat:@"INSERT INTO %@ (%@", [self tableNameForModel:data], cols[0]];
              for (int i = 1; i < cols.count; i++) {
                  [sql appendFormat:@",%@", cols[i]];
              }

              [sql appendString:@") VALUES(?"];
              for (int i = 1; i < cols.count; i++) {
                  [sql appendString:@",?"];
              }

              [sql appendString:@")"];
              NSMutableArray *array = [[NSMutableArray alloc] init];
              for (int i = 0; i < cols.count; i++) {
                  id value = [data valueForKey:cols[i]];
                  if ([value isKindOfClass:[NSString class]]) {
                      [array addObject:[value leie_trim]];
                  } else {
                      [array addObject:value];
                  }
              }
              result = [db executeUpdate:sql withArgumentsInArray:array];
              if (result) {
                  DDLogDebug(@"DB insert success");
              } else {
                  DDLogDebug(@"DB insert failed");
              }
          }
      }
    }];
}

- (BOOL)deleteData:(XJFBaseModel *)data dependOnKeys:(NSArray *)keys{
    __block BOOL result = YES;
    [_dbqueue inDatabase:^(FMDatabase *db) {
        
        NSMutableString *sql = [[NSMutableString alloc] init];
        [sql appendFormat:@"delete from %@", [self tableNameForModel:data]];
        NSMutableArray *parm = [[NSMutableArray alloc] init];
        if (keys.count == 1) {
            [sql appendFormat:@" where %@ = ?", keys[0]];
            
        } else if (keys.count > 1) {
            for (int i = 0; i < keys.count; i++) {
                if (i == 0) {
                    [sql appendFormat:@" where %@ = ?", keys[i]];
                    
                } else if (i == keys.count - 1) {
                    [sql appendFormat:@" and %@ = ?", keys[i]];
                    
                } else {
                    [sql appendFormat:@" and %@ = ?", keys[i]];
                }
            }
            
        } else {
            parm = nil;
        }
        
        for (int i = 0; i < keys.count; i++) {
            if (![data valueForKey:keys[i]]) {
                result = NO;
                DDLogDebug(@"操作表: %@ dependOn属性%@值为空,删除数据失败。 ", [self tableNameForModel:data], keys[i]);
                return;
            }
            [parm addObject:[data valueForKey:keys[i]]];
        }
        
        result = [db executeUpdate:sql withArgumentsInArray:parm];
        
    }];
    
    return result;
}

- (BOOL)updateData:(XJFBaseModel *)data dependOnKeys:(NSArray *)keys {
    __block BOOL result = YES;
    [_dbqueue inDatabase:^(FMDatabase *db) {
      NSMutableDictionary *rawDict = [data transToDictionaryWithIgnoredKeys:keys];
      NSArray *rawKeys = rawDict.allKeys;
      NSMutableArray *cols = [[NSMutableArray alloc] initWithArray:rawDict.allKeys];
      NSMutableString *sql = [[NSMutableString alloc] init];
      for (int i = 0; i < rawKeys.count; i++) {
          if (![rawDict objectForKey:rawKeys[i]]) {
              [cols removeObject:rawKeys[i]];
              continue;
          }

          //如果number值为默认值，不做更新。
          if ([[rawDict objectForKey:rawKeys[i]] isKindOfClass:[NSNumber class]] &&
              [[rawDict objectForKey:rawKeys[i]] isEqualToNumber:[NSNumber numberWithInteger:NON_OBJECT_DEFAULT_VALUE]]) {
              [cols removeObject:rawKeys[i]];
              continue;
          }
      }

      // never update pid
      [cols removeObject:kModelPrimary];

      [sql appendFormat:@"update %@ set", [self tableNameForModel:data]];

      for (int i = 0; i < cols.count; i++) {
          [sql appendFormat:@" %@ = ?,", cols[i]];
      }
      NSRange range = NSMakeRange(sql.length - 1, 1);
      [sql deleteCharactersInRange:range];
      if (keys.count == 1) {
          [sql appendFormat:@" where %@ = ?", keys[0]];

      } else if (keys.count > 1) {
          for (int i = 0; i < keys.count; i++) {
              if (i == 0) {
                  [sql appendFormat:@" where %@ = ?", keys[i]];

              } else if (i == keys.count - 1) {
                  [sql appendFormat:@" and %@ = ?", keys[i]];

              } else {
                  [sql appendFormat:@" and %@ = ?", keys[i]];
              }
          }
      }

      NSMutableArray *array = [[NSMutableArray alloc] init];
      for (int i = 0; i < cols.count; i++) {
          [array addObject:[data valueForKey:cols[i]]];
      }

      for (int i = 0; i < keys.count; i++) {
          if (![data valueForKey:keys[i]]) {
              result = NO;
              DDLogDebug(@"操作表: %@ dependOn属性%@值为空,更新数据库失败。 ", [self tableNameForModel:data], keys[i]);
              return;
          }
          id value = [data valueForKey:keys[i]];
          if ([value isKindOfClass:[NSString class]]) {
              [array addObject:[value leie_trim]];
          } else {
              [array addObject:value];
          }
      }

      result = [db executeUpdate:sql withArgumentsInArray:array];

    }];

    return result;
}

- (BOOL)clearTable:(XJFBaseModel *)data {
    __block BOOL result = YES;

    [_dbqueue inDatabase:^(FMDatabase *db) {
      NSMutableString *sql = [[NSMutableString alloc] init];
      [sql appendFormat:@"DELETE FROM %@", [self tableNameForModel:data]];
      result = [db executeUpdate:sql];
    }];

    return result;
}

- (NSArray *)searchModelsWithCondition:(XJFBaseModel *)condition andpage:(int)pageindex andOrderby:(NSString *)orderBy isAscend:(BOOL)isAscend {
    NSMutableString *sql = [[NSMutableString alloc] init];
    if (nil == condition) {
        return nil;
    }
    [sql appendFormat:@"select * from %@", [self tableNameForModel:condition]];

    NSDictionary *conditionDict = [condition transToDictionary];
    NSMutableArray *keyList = [NSMutableArray array];
    NSMutableArray *valueList = [NSMutableArray array];

    for (NSString *key in conditionDict.allKeys) {
        if ([conditionDict objectForKey:key]) {
            // 如果number值为默认值，不作为查询条件。
            if ([[conditionDict objectForKey:key] isKindOfClass:[NSNumber class]] &&
                [[conditionDict objectForKey:key] isEqualToNumber:[NSNumber numberWithInteger:NON_OBJECT_DEFAULT_VALUE]]) {
                continue;
            }
            id value = [conditionDict objectForKey:key];
            [keyList addObject:key];
            [valueList addObject:value];
        }
    }

    if (valueList.count) {
        for (int i = 0; i < valueList.count; i++) {
            if (i == 0) {
                [sql appendFormat:@" where %@ = ?", keyList[i]];
            } else {
                [sql appendFormat:@" and %@ = ?", keyList[i]];
            }
        }
    } else {
        valueList = nil;
    }

    if (orderBy) {
        NSString *sort = isAscend ? @"asc" : @"desc";
        [sql appendFormat:@" order by %@ %@", orderBy, sort];
    }

    if (-1 != pageindex) {
        [sql appendFormat:@" limit %d offset %d", LIMITNUMBER, pageindex * LIMITNUMBER];
    }

    return [self loadData:[condition class] sql:sql param:valueList];
}

- (NSInteger)resultCountWithCondition:(XJFBaseModel *)condition {
    return [self searchModelsWithCondition:condition andpage:-1 andOrderby:nil isAscend:YES].count;
}

- (NSString *)tableNameForModel:(XJFBaseModel *)model {
    return NSStringFromClass([model class]);
}
@end
