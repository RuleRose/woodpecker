//
//  NSArray+Extension.h
//
//  Created by wangyuehong on 15/9/6.
//  Copyright (c) 2015年 Oradt. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (leie_Kit)

- (id)leie_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (instancetype)leie_arrayByAddUniqueArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray arrayWithArray:self];
    for (id obj in array) {
        if ([result containsObject:obj]) continue;
        [result addObject:obj];
    }

    return result;
}

- (BOOL)leie_isEmpty {
    return [self count] == 0;
}

- (NSArray *)leie_reverse {
    NSMutableArray *reverses = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];

    id object = [enumerator nextObject];
    while (object) {
        [reverses addObject:object];
        object = [enumerator nextObject];
    }

    return reverses;
}

#pragma mark  数组转字符串
-(NSString *)string{
    
    if(self==nil || self.count==0) return @"";
    
    NSMutableString *str=[NSMutableString string];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,",obj];
    }];
    
    //删除最后一个','
    NSString *strForRight = [str substringWithRange:NSMakeRange(0, str.length-1)];
    
    return strForRight;
}





#pragma mark  数组比较
-(BOOL)compareIgnoreObjectOrderWithArray:(NSArray *)array{
    
    NSSet *set1=[NSSet setWithArray:self];
    
    NSSet *set2=[NSSet setWithArray:array];
    
    return [set1 isEqualToSet:set2];
}


/**
 *  数组计算交集
 */
-(NSArray *)arrayForIntersectionWithOtherArray:(NSArray *)otherArray{
    
    NSMutableArray *intersectionArray=[NSMutableArray array];
    
    if(self.count==0) return nil;
    if(otherArray==nil) return nil;
    
    //遍历
    for (id obj in self) {
        
        if(![otherArray containsObject:obj]) continue;
        
        //添加
        [intersectionArray addObject:obj];
    }
    
    return intersectionArray;
}



/**
 *  数据计算差集
 */
-(NSArray *)arrayForMinusWithOtherArray:(NSArray *)otherArray{
    
    if(self==nil) return nil;
    
    if(otherArray==nil) return self;
    
    NSMutableArray *minusArray=[NSMutableArray arrayWithArray:self];
    
    //遍历
    for (id obj in otherArray) {
        
        if(![self containsObject:obj]) continue;
        
        //添加
        [minusArray removeObject:obj];
        
    }
    
    return minusArray;
}

@end
