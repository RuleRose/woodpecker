//
//  NSFileManager+Extensions.m
//  easyMeasure
//
//  Created by qiwl on 2017/7/11.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import "NSFileManager+Extensions.h"

@implementation NSFileManager (Extensions)
+ (BOOL)createDirectoryAtPath:(NSString*)path
{
    NSFileManager* fileM = [NSFileManager defaultManager];
    BOOL dbEsist = YES;
    if (![fileM fileExistsAtPath:path]) {
        
        //第一次登陆的情况
        dbEsist = [fileM createDirectoryAtPath:path withIntermediateDirectories:YES
                                    attributes:nil
                                         error:nil];
    }
    return dbEsist;
}

+ (BOOL)removeDirectoryAtPath:(NSString*)path
{
    NSFileManager* fileM = [NSFileManager defaultManager];
    BOOL dbRemove = YES;
    if ([fileM fileExistsAtPath:path]) {
        dbRemove = [fileM removeItemAtPath:path error:nil];
    }
    return dbRemove;
}

+ (NSString *)sizeStrWithSize:(float)size{
    if (size > 1024) {
        if (size > 1024*1024) {
            return [NSString stringWithFormat:@"%0.01fMB",size/(1024.f * 1024.f)];
            
        }else{
            return [NSString stringWithFormat:@"%0.1fKB",size/1024.f];
            
        }
    }else{
        if (size < 0) {
            size = 0;
        }
        return [NSString stringWithFormat:@"%1.0fB",size];
        
    }
}

+ (BOOL)clearDirectoryAtPath:(NSString*)path{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
        return YES;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    if (contents.count > 0) {
        NSEnumerator *childFilesEnumerator = [contents objectEnumerator];
        NSString* fileName;
        BOOL result = YES;
        while ((fileName = [childFilesEnumerator nextObject]) != nil) {
            NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            BOOL  dbRemove = [fileManager removeItemAtPath:fileAbsolutePath error:nil];
            if (!dbRemove) {
                result = NO;
            }
        }
        return result;
    }
    return YES;
}

+ (float)folderSizeAtPath:(NSString*)folderPath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator* childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize;
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

@end
