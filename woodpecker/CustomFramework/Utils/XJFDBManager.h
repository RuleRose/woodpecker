//
//  MMCDBManager.h
//  mmcS2
//
//  Created by 肖君 on 16/10/24.
//  Copyright © 2016年 johnxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJFDBManager : NSObject
/**
 *  创建表格
 *  注意，mode中的类型只支持nstring和nsinteger，并且命名必须全部小写。
 *
 *  @param className 表明
 *
 *  @return 是否成功
 */
+ (BOOL)createTableWithModel:(Class)className;

/**
 *  将model储存到数据库
 *  @return 执行结果
 */
+ (BOOL)insertModel:(XJFBaseModel *)model;

+ (void)batchInsertModel:(NSArray<XJFBaseModel *> *)modelList;

/**
 *  将model从本地数据库删除
 *  keys   是根据哪些参数来删除 如果传nil 则会根据pid参数来删除
 *  @return 执行结果
 */
+ (BOOL)deleteModel:(XJFBaseModel *)model dependOnKeys:(NSArray *)keys;

/**
 *  将model更新到数据库
 *  keys   是根据哪些参数来更新 如果传nil 则会根据pid来更新
 *  @return 执行结果
 */
+ (BOOL)updateModel:(XJFBaseModel *)model dependOnKeys:(NSArray *)keys;

/**
 *  清空表格
 *  @return 执行结果
 */
+ (BOOL)clearTableModel:(XJFBaseModel *)model;

/**
 *  查询，可分页以及排序
 *
 *  @param cls       类对象。如果number为默认值，则不作为查询条件; 其他类型数据为nil，也不作为查询条件。
 *  @param pageindex 分页, 如果为-1，则不分页，一次全取出来。
 *  @param orderBy   排序字段 如果为nil，就不做排序。
 *  @param isAscen   升/降序。
 *
 *  @return 查询结果（condition class）数组
 */
+ (NSArray *)searchModelsWithCondition:(XJFBaseModel *)condition andpage:(int)pageindex andOrderby:(NSString *)orderBy isAscend:(BOOL)isAscend;

/**
 *  查询结果集的数量
 *
 *  @param cls       类对象，如果number为默认值，则不作为查询条件。
 *
 *  @return 结果集数量
 */
+ (NSInteger)resultCountWithCondition:(XJFBaseModel *)condition;
@end
