//
//  JRBigValue.m
//  JKDBModel
//
//  Created by wangchunxiang on 16/9/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JRBigValue.h"
#import "MyMD5.h"

@implementation JRBigValue


/**
 保存数据
 
 @param key <#key description#>
 @param data <#data description#>
 */
+ (void)saveValue:(NSData *)data forKey:(NSString *)key {
    NSString *md5Url = [MyMD5 md5:key];
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDirectoryPath], md5Url];
    [data writeToFile:path atomically:YES];
}

/**
 查找数据
 
 @param key <#key description#>
 @return <#return value description#>
 */
+ (NSData *)findValueForKey:(NSString *)key {
    NSString *md5Url = [MyMD5 md5:key];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDirectoryPath], md5Url];
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (existed) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        return data;
    }
    return nil;
}

/**
 删除数据
 
 @param key <#key description#>
 */
+ (void)deleteValueForKey:(NSString *)key {
    NSString *md5Url = [MyMD5 md5:key];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self getDirectoryPath], md5Url];
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (existed) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (NSString *)getDirectoryPath {
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    directoryPath = [directoryPath stringByAppendingPathComponent:@"JRHttp"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}

/** 
 *删除文件缓存
 */
+ (void)clearFileCache {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    [manager removeItemAtPath:[self getDirectoryPath] error:&error];
}

@end
