//
//  MyLayout.h
//  TT
//
//  Created by wangchunxiang on 2017/3/24.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define speed_page  1.0
#define mainScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MyLayout : UICollectionViewLayout

//这个int值存储有多少个item
@property(nonatomic,assign)int itemCount;

@end
