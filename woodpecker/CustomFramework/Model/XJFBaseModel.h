//
//  BaseModel.h
//  storyhouse2
//
//  Created by 肖君 on 16/7/7.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kModelPrimary @"pid"

@interface XJFBaseModel : NSObject
@property(nonatomic, copy) NSString *pid;

/** !!!!!!!!!!!!
 *  所有忽略保存至数据库的属性都需要在该方法中指出，
 *  在该方法中返回的属性，在存DB和转字典时都会被忽略
 *  @return 不需要保存至数据库的方法
 */
+ (NSMutableArray *)mj_ignoredPropertyNames;
/**
 *  如果model的属性名称存在于json内对应的键不匹配时，此函数更换key值，具体实现参考.m文件实现
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName;

/**
 *  return @{
 @"statuses" : @"Status",
 @"ads" : @"Ad"
 };
 statuses 和 ads 是属性名称，Status和Ad 是类的名字
 */
+ (NSDictionary *)mj_objectClassInArray;

/**
 *  字典数组生成对象数组
 *
 *  @param keyValuesArray 字典数组
 *
 *  @return 对象数组
 */
+ (NSMutableArray *)getArrayWithKeyValuesArray:(NSArray *)keyValuesArray;

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSMutableDictionary *)transToDictionary;

/**
 *  将模型转成字典
 keys  内容是，希望转为json的属性的名称组成的数组
 *  @return 字典
 */
- (NSMutableDictionary *)transToDictionaryWithKeys:(NSArray *)keys;

/**
 *  将模型转成字典
 ignoredKeys  内容是，希望不被转为json的属性的名称组成的数组
 *  @return 字典
 */
- (NSMutableDictionary *)transToDictionaryWithIgnoredKeys:(NSArray *)ignoredKeys;

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 */
- (void)loadDataFromkeyValues:(id)keyValues;

/**
 *  将model储存到数据库
 *  @return 执行结果
 */
- (BOOL)insertToDB;
/**
 *  将model更新到数据库
 *  keys   是根据哪些参数来更新 如果传nil 则会根据PID来更新
 *  @return 执行结果
 */
- (BOOL)updateToDBDependsOn:(NSArray *)keys;
///**
// *  将model从本地数据库删除
// *  keys   是根据哪些参数来删除 如果传nil 则会根据所有参数来删除
// *  @return 执行结果
// */
//- (BOOL)removeFromDB;
///**
// *  查询数据库，将查询条件赋值给此model，所有的赋值的属性，都会作为查询条件
// *  @return 返回值是查询结果数组
// */
//
//- (NSArray *)getFromDB;

@end
