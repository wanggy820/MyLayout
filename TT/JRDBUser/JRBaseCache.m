//
//  JRBaseCache.m
//  TT
//
//  Created by wangchunxiang on 2016/12/26.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "JRBaseCache.h"
#import "JRBigValue.h"
#import "JRDBHelper.h"

@implementation JRBaseCache

/** 清空表 */
+ (BOOL)clearCacheTable {
    [JRBigValue clearFileCache];
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    __block BOOL res = NO;
    
    [jrDB.dbQueue inDatabase:^(FMDatabase *db) {
        
        // 根据请求参数查询数据
        FMResultSet *resultSet = nil;
        resultSet = [db executeQuery:@"SELECT * FROM sqlite_master where type='table';"];
        
        // 遍历查询结果
        while (resultSet.next) {
            NSString *tableName = [resultSet stringForColumnIndex:1];
            Class class = NSClassFromString(tableName);
            
            if (class) {
                id value = [[class alloc] init];
                if ([value isKindOfClass:[JRBaseCache class]]) {
                    
                    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
                    res = [db executeUpdate:sql];
                    NSLog(@"清空 %@ %@",tableName,res?@"成功":@"失败");
                }
            }
            
        }
    }];
    return res;
}

@end
