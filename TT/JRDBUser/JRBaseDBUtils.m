//
//  JRBaseDBUtils.m
//  TT
//
//  Created by wangchunxiang on 2016/11/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "JRBaseDBUtils.h"
#import "JRDBHelper.h"
#import "MJExtension.h"
#import "JRBigValue.h"

#define jr_sqlite_max_bit  16*1024   //大于16k则存储为文件

@implementation JRBaseDBUtils

#pragma mark - override method
+ (void)initialize {
    [self createTable];
}

/** 数据库中创建表 */
+ (BOOL)createTable {
    __block BOOL res = YES;
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    [jrDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *columeAndType = [NSString stringWithFormat:@"pk INTEGER primary key,sqlKey TEXT,sqlValue TEXT,className TEXT"];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
        if (![db executeUpdate:sql]) {
            res = NO;
            *rollback = YES;
        };
    }];
    
    return res;
}

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable {
    __block BOOL res = NO;
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    [jrDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        res = [db tableExists:tableName];
    }];
    return res;
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    id keyForValue = [self findValueForKey:key];
    if (keyForValue) {
        [self updateValue:value forKey:key];
    } else {
        [self saveValue:value forKey:key];
    }
}

// 除NSNumber外，所有value都转成NSData  *shouldSaveFile == YES时，一定是NSData
+ (id)toSqlValue:(id)value shouldSaveFile:(BOOL *)shouldSaveFile{
    if (!value) {
        return @"";
    }
    if ([value isKindOfClass:[NSNumber class]]){
        if (shouldSaveFile) {
            *shouldSaveFile = NO;
        }
        return value;
    }
    NSData *data;
    if ([value isKindOfClass:[NSData class]]) {
        data = value;
    } else if ([value isKindOfClass:[NSString class]]) {
        data = [value dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]) {
        NSArray *array;
        if ([value isKindOfClass:[NSSet class]]) {
            array = value;
        } else {
            array = [(NSSet *)value allObjects];
        }
        
        NSError *error;
        NSArray *dictArray = [NSObject mj_keyValuesArrayWithObjectArray:array];
        data = [NSJSONSerialization dataWithJSONObject:dictArray options:NSJSONWritingPrettyPrinted error:&error];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSError *error;
        data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&error];
    } else {
        data = [value mj_JSONData];
    }
    if (shouldSaveFile) {
        JRBaseDBUtils *base = [[self alloc] init];
        if ([base isKindOfClass:NSClassFromString(@"JRBaseCache")]) {
            *shouldSaveFile = (data.length > jr_sqlite_max_bit);
        }
    }
    return data;
}

/** 保存单个对象 */
+ (void)saveValue:(id)value forKey:(NSString *)key {
    NSString *tableName = NSStringFromClass(self.class);
    BOOL shouldSaveFile = NO;
    id sqlValue = [self toSqlValue:value shouldSaveFile:&shouldSaveFile];
    if (shouldSaveFile) {
        [JRBigValue saveValue:sqlValue forKey:key];
    } else {
        [JRBigValue deleteValueForKey:key];
    }
    
    NSString *valueClassName = [self getClassName:value];
    NSArray *insertValues = @[key,(shouldSaveFile ? [NSNull null] : sqlValue), valueClassName];
    
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    [jrDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(sqlKey,sqlValue,className) VALUES (?,?,?);", tableName];
        BOOL res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        NSLog(res?@"插入成功":@"插入失败");
    }];
}

/** 更新单个对象 */
+ (void)updateValue:(id)value forKey:(NSString *)key  {
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    [jrDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE sqlKey = '%@'",tableName,key];
        FMResultSet *resultSet = [db executeQuery:sql];
        int pk = 0;
        while ([resultSet next]) {
            pk = [resultSet intForColumn:@"pk"];
            [resultSet close];
            break;
        }
        
        if (pk <= 0) {
            return;
        }
        
        BOOL shouldSaveFile = NO;
        id sqlValue = [self toSqlValue:value shouldSaveFile:&shouldSaveFile];
        if (shouldSaveFile) {
            [JRBigValue saveValue:sqlValue forKey:key];
        } else {
            [JRBigValue deleteValueForKey:key];
        }
        NSString *valueClassName = [self getClassName:value];
        NSArray *updateValues = @[key, (shouldSaveFile ? [NSNull null] : sqlValue), valueClassName];
        sql = [NSString stringWithFormat:@"UPDATE %@ SET sqlKey=?, sqlValue=?, className=? WHERE sqlKey = '%@'", tableName, key];
        BOOL res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        NSLog(res?@"更新成功":@"更新失败");
    }];
}

+ (NSString *)getClassName:(id)value {
    if ([value isKindOfClass:[NSNumber class]]) {
        return @"NSNumber";
    }
    if ([value isKindOfClass:[NSData class]]) {
        return @"NSMutableData";
    }
    if ([value isKindOfClass:[NSString class]]) {
        return @"NSString";
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return @"NSMutableArray";
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return @"NSMutableDictionary";
    }
    if ([value isKindOfClass:[NSSet class]]) {
        return @"NSMutableSet";
    }
    return NSStringFromClass([value class]);
}

/** 查找单个对象 */
+ (id)findValueForKey:(NSString *)key {
    __block NSString *className;
    __block id sqlValue = [JRBigValue findValueForKey:key];//先找文件
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    [jrDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE sqlKey = '%@'",tableName,key];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            className = [resultSet stringForColumn:@"className"];
            if (!sqlValue) {
                if ([className isEqualToString:@"NSNumber"]) {
                    sqlValue = @([resultSet longLongIntForColumn:@"sqlValue"]);
                } else {
                    sqlValue = [resultSet dataForColumn:@"sqlValue"];
                }
            }
            
            [resultSet close];
            break;
        }
    }];
    if (!sqlValue || !className.length) {
        return nil;
    }
    
    if ([className isEqualToString:@"NSNumber"]) {
        return sqlValue;
    }
    if ([className isEqualToString:@"NSString"]) {
        return [[NSString alloc] initWithData:sqlValue encoding:NSUTF8StringEncoding];
    }
    
    if ([className isEqualToString:@"NSMutableData"]) {
        return [NSMutableData dataWithData:sqlValue];
    }
    
    NSError *error;
    id jsonData = [NSJSONSerialization JSONObjectWithData:sqlValue options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    
    if ([className isEqualToString:@"NSMutableDictionary"]) {
        return [NSMutableDictionary dictionaryWithDictionary:jsonData];
    }
    if ([className isEqualToString:@"NSMutableArray"] || [className isEqualToString:@"NSMutableSet"]) {
        Class arrayClass = [[self class] objectClassInArray];
        id value;
        if (arrayClass) {
            value = [arrayClass mj_objectArrayWithKeyValuesArray:jsonData];
        } else {
            value = [NSMutableArray arrayWithArray:jsonData];
        }
        
        if ([className isEqualToString:@"NSMutableSet"]) {
            value = [NSMutableSet setWithArray:value];
        }
        return value;
    } else {
        return [NSClassFromString(className) mj_objectWithKeyValues:jsonData];
    }

    return nil;
}

/** 删除单个对象 */
+ (void)deleteValueForKey:(NSString *)key {
    [JRBigValue deleteValueForKey:key];
    
    JRDBHelper *jrDB = [JRDBHelper shareInstance];
    [jrDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE sqlKey = '%@'",tableName,key];
        FMResultSet *resultSet = [db executeQuery:sql];
        int pk = 0;
        while ([resultSet next]) {
            pk = [resultSet intForColumn:@"pk"];
            [resultSet close];
            break;
        }
        
        if (pk <= 0) {
            return;
        }
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE sqlKey = ?",tableName];
        BOOL res = [db executeUpdate:sql withArgumentsInArray:@[key]];
        NSLog(res?@"删除成功":@"删除失败");
    }];
}



//如果子类中有一些property是数组，那么这个方法必须在子类中重写
+ (Class)objectClassInArray {
    return nil;
}


@end







