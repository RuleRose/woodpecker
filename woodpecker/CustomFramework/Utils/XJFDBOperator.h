//
//  MMCDBOperator.h
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LIMITNUMBER 30

#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/MeasureData.db"]

@interface XJFDBOperator : NSObject
Singleton_Interface(XJFDBOperator);
- (void)close;
- (void)open;
//执行批量sql命令
/*
 Formate like:
 @"create table bulktest1 (id integer primary key autoincrement, x text);"
 @"insert into bulktest1 (x) values ('XXX');"
 */
- (BOOL)executeSQLs:(NSString *)sql;
- (BOOL)executeSqlsInTransaction:(NSArray *)sqls;

- (BOOL)insertData:(XJFBaseModel *)data;
- (void)batchInsertData:(NSArray *)dataArray;
- (BOOL)deleteData:(XJFBaseModel *)data dependOnKeys:(NSArray *)keys;
- (BOOL)updateData:(XJFBaseModel *)data dependOnKeys:(NSArray *)keys;
- (BOOL)clearTable:(XJFBaseModel *)data;

/**
 *  分页查询并排序
 *
 *  @param cls       类对象。如果number为默认值，则不作为查询条件; 其他类型数据为nil，也不作为查询条件。
 *  @param pageindex 分页, 如果为-1，则不分页，一次全取出来。
 *  @param orderBy   排序字段 如果为nil，就不做排序。
 *  @param isAscen   升/降序。
 *
 *  @return 查询结果（condition class）数组
 */
- (NSArray *)searchModelsWithCondition:(XJFBaseModel *)condition andpage:(int)pageindex andOrderby:(NSString *)orderBy isAscend:(BOOL)isAscend;

- (NSInteger)resultCountWithCondition:(XJFBaseModel *)condition;

@end
