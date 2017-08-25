//
//  BaseModel.m
//  storyhouse2
//
//  Created by 肖君 on 16/7/7.
//  Copyright © 2016年 LEIE. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "XJFBaseModel.h"
#import "XJFDBManager.h"

@implementation XJFBaseModel

MJExtensionCodingImplementation;

+ (NSMutableArray *)mj_ignoredPropertyNames {
    return nil;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    /**
     *  将属性名换为其他key去字典中取值
     *
     *  @return 字典中的key是属性名，value是从字典中取值用的key
     */
    return nil;
}

+ (NSDictionary *)mj_objectClassInArray {
    return nil;
}

+ (NSMutableArray *)getArrayWithKeyValuesArray:(NSArray *)keyValuesArray {
    return [self mj_objectArrayWithKeyValuesArray:keyValuesArray];
}

- (NSMutableDictionary *)transToDictionary {
    return [self mj_keyValues];
}

- (NSMutableDictionary *)transToDictionaryWithKeys:(NSArray *)keys {
    return [self mj_keyValuesWithKeys:keys];
}

- (NSMutableDictionary *)transToDictionaryWithIgnoredKeys:(NSArray *)ignoredKeys {
    return [self mj_keyValuesWithIgnoredKeys:ignoredKeys];
}

- (void)loadDataFromkeyValues:(id)keyValues {
    [self mj_setKeyValues:keyValues];
}

- (BOOL)insertToDB {
    return [XJFDBManager insertModel:self];
}

- (BOOL)updateToDBDependsOn:(NSArray *)keys {
    return [XJFDBManager updateModel:self dependOnKeys:keys];
}
//
//- (BOOL)removeFromDB {
//    return [LeieDBManager deleteModel:self dependOnKeys:nil];
//}
//
//- (NSArray *)getFromDB {
//    return [LeieDBManager searchModelsWithCondition:self];
//}
@end
