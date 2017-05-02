//
//  AppDelegate.m
//  TT
//
//  Created by wangchunxiang on 2016/11/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"



#ifdef DEBUG
//#import "FLEXManager.h"
#endif


#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <execinfo.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

//#import <Stock/StockSDK.h>
//#import "SDWebImageManager.h"

//#import <JRTest/JRTest.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    ViewController *vc = [[ViewController alloc] init];
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.window makeKeyAndVisible];
//    self.window.backgroundColor = [UIColor whiteColor];
    
//    [StockSDK setDelegate:self];
    

    
    return YES;
}

- (void)downLoadFile {
    // 1. 创建url
    NSString *urlStr = @"http://10.13.86.93:8080/TT/TT/demo.js";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *Url = [NSURL URLWithString:urlStr];
    
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Url];
    
    // 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 下载成功
            // 注意 location是下载后的临时保存路径, 需要将它移动到需要保存的位置
            NSError *saveError;
            // 创建一个自定义存储路径
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath = [cachePath stringByAppendingPathComponent:@"demo.js"];
            NSURL *saveURL = [NSURL fileURLWithPath:savePath];
            
            NSFileManager *manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:savePath]) {
                [manager removeItemAtPath:savePath error:&saveError];
            }
            // 文件复制到cache路径中
            [manager copyItemAtURL:location toURL:saveURL error:&saveError];
//            if (!saveError) {
//                NSLog(@"保存成功");
//                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//            } else {
//                [SVProgressHUD showErrorWithStatus:saveError.description];
//                NSLog(@"error is %@", saveError.localizedDescription);
//            }
        } else {
            NSLog(@"error is : %@", error.localizedDescription);
        }
    }];
    // 恢复线程, 启动任务
    [downLoadTask resume];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    [self downLoadFile];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
