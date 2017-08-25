//
//  NSDictionary+Extension.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (leie_Short)

- (long)leie_longForKey:(NSString *)key;

- (int)leie_intForKey:(NSString *)key;

- (NSString *)leie_stringForKey:(id)key;

- (NSNumber *)leie_numberForKey:(id)key;

- (NSArray *)leie_arrayForKey:(id)key;

- (NSDictionary *)leie_dictionaryForKey:(id)key;

- (NSInteger)leie_integerForKey:(id)key;

- (NSUInteger)leie_unsignedIntegerForKey:(id)key;

- (BOOL)leie_boolForKey:(id)key;

- (int16_t)leie_int16ForKey:(id)key;

- (int32_t)leie_int32ForKey:(id)key;

- (int64_t)leie_int64ForKey:(id)key;

- (char)leie_charForKey:(id)key;

- (short)leie_shortForKey:(id)key;

- (float)leie_floatForKey:(id)key;

- (double)leie_doubleForKey:(id)key;

- (long long)leie_longLongForKey:(id)key;

- (unsigned long long)leie_unsignedLongLongForKey:(id)key;

// CG
- (CGFloat)leie_CGFloatForKey:(id)key;

- (CGPoint)leie_pointForKey:(id)key;

- (CGSize)leie_sizeForKey:(id)key;

- (CGRect)leie_rectForKey:(id)key;

// 根据key/key形式获取数据，分隔符'/'
- (id)leie_getObjectByPath:(NSString *)path;
@end
