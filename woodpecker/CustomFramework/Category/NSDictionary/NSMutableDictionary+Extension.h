//
//  NSMutableDictionary+Extension.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableDictionary (leie_Short)

- (void)leie_setObject:(id)object forKey:(NSString *)key;

- (void)leie_setString:(NSString *)s forKey:(NSString *)key;

- (void)leie_setBool:(BOOL)i forKey:(NSString *)key;

- (void)leie_setInt:(int)i forKey:(NSString *)key;

- (void)leie_setInteger:(NSInteger)i forKey:(NSString *)key;

- (void)leie_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key;

- (void)leie_setCGFloat:(CGFloat)f forKey:(NSString *)key;

- (void)leie_setChar:(char)c forKey:(NSString *)key;

- (void)leie_setFloat:(float)i forKey:(NSString *)key;

- (void)leie_setDouble:(double)i forKey:(NSString *)key;

- (void)leie_setLongLong:(long long)i forKey:(NSString *)key;

- (void)leie_setPoint:(CGPoint)o forKey:(NSString *)key;

- (void)leie_setSize:(CGSize)o forKey:(NSString *)key;

- (void)leie_setRect:(CGRect)o forKey:(NSString *)key;

@end
