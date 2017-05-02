//
//  JRBigValue.h
//  JKDBModel
//
//  Created by wangchunxiang on 16/9/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRBigValue : NSObject



/**
 *保存数据

 @param key <#key description#>
 @param data <#data description#>
 */
+ (void)saveValue:(NSData *)data forKey:(NSString *)key;

/**
 *查找数据

 @param key <#key description#>
 @return <#return value description#>
 */
+ (NSString *)findValueForKey:(NSString *)key;

/**
 *删除数据

 @param key <#key description#>
 */
+ (void)deleteValueForKey:(NSString *)key;

/**
 *删除文件缓存
 */
+ (void)clearFileCache;

@end
