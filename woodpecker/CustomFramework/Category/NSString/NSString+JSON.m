//
//  NSString+JSON.m
//  woodpecker
//
//  Created by QiWL on 2017/11/6.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)
+ (NSString *)getJSONString:(NSDictionary *)dic{
    if (!dic) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSString *)getReadableJSONString:(NSDictionary *)dic{
    if (!dic) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

+ (NSDictionary *)getDictionary:(NSString *)jsonStr{
    if ([NSString leie_isBlankString:jsonStr]) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        err = nil;
    }
    return dic;
}
@end
