//
//  NSMutableDictionary+Extension.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (leie_Short)

- (void)leie_setObject:(id)object forKey:(NSString *)key {
    if (object) {
        [self setObject:object forKey:key];
    }
}

- (void)leie_setString:(NSString *)s forKey:(NSString *)key {
    if (s) {
        [self setObject:s forKey:key];
    }
}

- (void)leie_setBool:(BOOL)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setInt:(int)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setInteger:(NSInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setCGFloat:(CGFloat)f forKey:(NSString *)key {
    self[key] = @(f);
}

- (void)leie_setChar:(char)c forKey:(NSString *)key {
    self[key] = @(c);
}

- (void)leie_setFloat:(float)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setDouble:(double)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setLongLong:(long long)i forKey:(NSString *)key {
    self[key] = @(i);
}

- (void)leie_setPoint:(CGPoint)o forKey:(NSString *)key {
    self[key] = NSStringFromCGPoint(o);
}

- (void)leie_setSize:(CGSize)o forKey:(NSString *)key {
    self[key] = NSStringFromCGSize(o);
}

- (void)leie_setRect:(CGRect)o forKey:(NSString *)key {
    self[key] = NSStringFromCGRect(o);
}

@end
