//
//  JRRefresh.m
//  TT
//
//  Created by wangchunxiang on 2016/12/19.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "JRRefresh.h"
//#import "UIImage+GIF.h"

@implementation JRRefresh
{
    BOOL canDisPlay;
    UIImageView *imageView;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    float y = self.scrollView.contentOffset.y;
    if (y == 0) {
        return;
    }
    [self updateCanDisplay];
    float endAngle = (-y*(90.0/16.0) - 90) * M_PI/ 180;//0 *  M_PI/ 180

    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画扇形和椭圆*/
    //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
    UIColor *aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, rect.size.width/2, rect.size.height/2);
    
    CGContextAddArc(context,  rect.size.width/2, rect.size.height/2, rect.size.height/2,  -90 *  M_PI/ 180, endAngle, 0);
    
    CGContextAddArc(context, 100, 20, 15, 0, 2*M_PI, 0); //添加一个圆
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}
/**
 *

 0 -- > -90
 -25 --> 0
 -50 --> 90
 -75 --> 180
 -100 --> 270
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.pan = self.scrollView.panGestureRecognizer;
        [self.pan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (canDisPlay) {
            [self setNeedsDisplay];
        }
        [self updateCanDisplay];
    } else if ([keyPath isEqualToString:@"state"]) {
        switch (self.scrollView.panGestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                NSLog(@"begin == %@",change);
                self.state = JRRefreshStatePulling;
                break;

            case UIGestureRecognizerStateEnded:
                NSLog(@"changed == %@",change);
                if (self.scrollView.contentOffset.y < -64) {
                    self.state = JRRefreshStateRefreshing;
                } else {
                    self.state = JRRefreshStateNormal;
                }
                
                break;
                
            default:
                self.state = JRRefreshStateNormal;
                NSLog(@"no == %@",change);
                break;
        }
    }
}

- (void)setState:(JRRefreshState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    
    if (state == JRRefreshStateRefreshing) {
        //刷新中
        [self imageView];
        self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endRefresh];
        });
    } else {
        imageView.hidden = YES;
    }
}

- (void)endRefresh {
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    imageView.hidden = YES;
}

- (UIImageView *)imageView {
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
//        UIImage *images = [UIImage sd_animatedGIFNamed:@"1"];
//        imageView.image = images;
        [self addSubview:imageView];
    }
    imageView.hidden = NO;
    return imageView;
}

- (void)updateCanDisplay {
    float y = self.scrollView.contentOffset.y;
    if (y <= 0 && y >= -self.frame.size.height) {
        canDisPlay = YES;
    } else {
        canDisPlay = NO;
    }
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self.pan removeObserver:self forKeyPath:@"state"];
    self.pan = nil;
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
}

@end
