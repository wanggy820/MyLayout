//
//  CYLBlockExecutor.h
//  TT
//
//  Created by wangchunxiang on 2016/11/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^voidBlock)(void);

@interface CYLBlockExecutor : NSObject

- (id)initWithBlock:(voidBlock)block;

@end
