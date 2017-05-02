//
//  DDD.m
//  JRTest
//
//  Created by wangchunxiang on 2017/1/12.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "DDD.h"

@implementation DDD

- (instancetype)init {
    if (self = [super init]) {
        
//        [SVProgressHUD showWithStatus:@"test"];
//        [[AFHTTPSessionManager manager] GET:@"http://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            NSLog(@"=======%s",__func__);
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"=======%s",__func__);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"=======%s",__func__);
//        }];
//        
        
#ifdef __test__
        NSLog(@"define  __test__");
#else
      NSLog(@"no define __test__");
#endif
    }
    return self;
}

- (void)test {
    NSLog(@"=======%s",__func__);
}

@end
