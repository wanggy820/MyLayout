//
//  JRRefresh.h
//  TT
//
//  Created by wangchunxiang on 2016/12/19.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JRRefreshState) {
    JRRefreshStateNormal = 0,
    JRRefreshStatePulling,
    JRRefreshStateRefreshing,
};

@interface JRRefresh : UIView

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) JRRefreshState state;

@end
