//
//  JRDBHelper.h
//  JRDBHelper
//
//  Created by wangchunxiang on 16/9/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FMDB.h"

@interface JRDBHelper : NSObject

//@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (JRDBHelper *)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;

@end
