//
//  NSFileManager+Extensions.h
//  easyMeasure
//
//  Created by qiwl on 2017/7/11.
//  Copyright © 2017年 goldsmith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extensions)
+ (BOOL)createDirectoryAtPath:(NSString*)path;
+ (BOOL)removeDirectoryAtPath:(NSString*)path;
+ (BOOL)clearDirectoryAtPath:(NSString*)path;
+ (float)folderSizeAtPath:(NSString*)folderPath;
+ (NSString *)sizeStrWithSize:(float)size;
@end
