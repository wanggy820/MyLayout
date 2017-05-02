//
//  JRBaseDBUtils.h
//  JRBaseDBUtils
//
//  Created by wangchunxiang on 2016/11/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *使用说明
 * 数据库里面只存储 NSString  NSNumber NSdata
 * NSString对应的是NSString
 * NSNumber对应的是NSNumber
 * NSdata 对应的是NSdata、NSArray、NSDictionary、自定义类型(NSArray、NSDictionary不能放入NSData,自定义类型不能含有NSData属性)
 */
@interface JRBaseDBUtils : NSObject

/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable;

/**
 查询字段为key的数据
 
 @param key <#key description#>
 @return <#return value description#>
 */
+ (id)findValueForKey:(NSString *)key;

/**
 删除字段为key的数据
 
 @param key <#key description#>
 */
+ (void)deleteValueForKey:(NSString *)key;

/**
 *保存数据/更新数据
 *如果对应key有值，则更新数据，没有则保存数据
 @param value <#value description#>
 @param key <#key description#>
 */
+ (void)setValue:(id)value forKey:(NSString *)key;



/**
 *如果子类中有一些property是数组，那么这个方法必须在子类中重写
 */
+ (Class)objectClassInArray;


@end





