//
//  Test.h
//  TT
//
//  Created by wangchunxiang on 2016/11/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "JRDBModel.h"
#import <objc/runtime.h>
//#import "CMProperty.h"
//#import "JRBaseDBUtils.h"

@interface TT : NSObject
@property (nonatomic, copy) NSString *name;
@end


@interface Test : NSObject
{
    @public
    NSString *ttt;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *dict;
@property (nonatomic, copy) NSArray<TT *> *array;
@property (nonatomic, assign) BOOL a;
@property (nonatomic, assign) int b;
@property (nonatomic, assign) long c;
@property (nonatomic, strong) TT *tt;




@property (nonatomic, copy) void(^test)(Test *t);

- (void)tttt;
@end

/Users/wangchunxiang/Desktop/TT/TT/ThirdViewController.h
