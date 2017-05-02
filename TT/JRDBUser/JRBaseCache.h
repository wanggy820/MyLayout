//
//  JRBaseCache.h
//  TT
//
//  Created by wangchunxiang on 2016/12/26.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "JRBaseDBUtils.h"

@interface JRBaseCache : JRBaseDBUtils

/**
 清楚所有数据表
 
 @return <#return value description#>
 */
+ (BOOL)clearCacheTable;

@end
