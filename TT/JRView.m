//
//  JRView.m
//  TT
//
//  Created by wangchunxiang on 2016/12/23.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "JRView.h"
#import "JRHeader.h"

@implementation JRView
{
    JRHeader *header;
    UIView *topView;
    UIView *bottomView;
    UIScrollView *_scrollView;
    
    UIImageView *imageView1;
    UIImageView *imageView2;
    double touchBeginY;
    double contentOffSetY;
    double lastTouchY;
    double lastContentOffSetY;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];

        [self header];
        [self topView];
        [self bottomView];
        [self scrollView];
        
        [self bringSubviewToFront:header];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleSwipe:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)handleSwipe:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        touchBeginY = point.y;
        
        contentOffSetY = _scrollView.contentOffset.y;
        lastContentOffSetY = contentOffSetY;
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        double y = contentOffSetY + (touchBeginY - point.y);
        if (y < 0) {
            double dy = point.y - lastTouchY;
            double k = [self scrollViewK];
            y = lastContentOffSetY - k*dy;
        }
        
        lastTouchY = point.y;
        lastContentOffSetY = y;
        [_scrollView setContentOffset:CGPointMake(0, y) animated:NO];
    } else {
        //取消
        [self touchEndY:point.y];
    }
}

- (double)scrollViewK {
    double k = 1;
    if (lastContentOffSetY < 0) {
        int a = lastContentOffSetY/50 - 1;
        k = 1 + 0.3*a;
    }
    
    if (k < 0.1) {
        k = 0.1;
    }
    return k;
}

- (void)touchEndY:(double)y {
    
    if (_scrollView.contentOffset.y < 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        //减速度
        
    }
    [self scrollViewDidEndDecelerating:_scrollView];
}

- (void)header {
    header = [[JRHeader alloc] initWithFrame:CGRectMake(0, 0, 375, 64)];
    header.backgroundColor = [UIColor redColor];
    [self addSubview:header];
}

- (void)topView {
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 375, 100)];
    topView.backgroundColor = [UIColor greenColor];
    [self addSubview:topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 30)];
    label.text = @"21321";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [topView addSubview:label];
    
    label.backgroundColor = [UIColor purpleColor];
}

- (void)bottomView {
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 164, 375, 100+1900)];
    bottomView.backgroundColor = [UIColor yellowColor];
    [self addSubview:bottomView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn setTitle:@"fdsf" forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    btn.backgroundColor = [UIColor brownColor];
    [bottomView addSubview:btn];
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 375, 667)];
    imageView1.image = [UIImage imageNamed:@"1.png"];
    imageView1.userInteractionEnabled = YES;
    [bottomView addSubview:imageView1];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    [btn2 setTitle:@"_scrollView" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 3;
    btn2.backgroundColor = [UIColor magentaColor];
    [bottomView addSubview:btn2];
}

- (void)test:(id)sender {
    NSLog(@"%s %@",__FUNCTION__, sender);
}

- (void)scrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 264, 375, 667-264)];
    _scrollView.backgroundColor = [UIColor yellowColor];
    _scrollView.contentSize = CGSizeMake(375, 1900);
    _scrollView.delegate = self;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(110, 100, 100, 100)];
    view1.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(110, 500, 100, 100)];
    view2.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:view2];

    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(110, 1000, 100, 100)];
    view3.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:view3];
    

    
    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    imageView2.image = [UIImage imageNamed:@"1.png"];
    [_scrollView addSubview:imageView2];
    imageView2.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [btn setTitle:@"_scrollView" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 2;
    btn.backgroundColor = [UIColor magentaColor];
    [_scrollView addSubview:btn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float contentOffsetY = scrollView.contentOffset.y;

    if (contentOffsetY <= 0) {
        header.alpha = 1;
        header.backgroundColor = [UIColor redColor];
        
    }else if (contentOffsetY < 30) {
        header.alpha = (30 - contentOffsetY)/30;
        header.backgroundColor = [UIColor redColor];
    } else if (contentOffsetY <= 60) {
        header.alpha = (contentOffsetY - 30)/30;
        header.backgroundColor = [UIColor lightGrayColor];
    } else {
        header.alpha = 1;
        header.backgroundColor = [UIColor lightGrayColor];
    }
    CGRect frame = topView.frame;
    if (contentOffsetY <= 0) {
        frame.origin.y = 64;
        topView.alpha = 1;
    } else if (contentOffsetY < 300) {
        frame.origin.y = 64 - contentOffsetY/3;
        topView.alpha = (500 - contentOffsetY)/500;
    } else {
        frame.origin.y = 64 - 100;
        topView.alpha = 0;
    }
    
    topView.hidden = (contentOffsetY > 150);
    topView.frame = frame;
    
    frame = bottomView.frame;
    if (contentOffsetY > 0) {
        frame.origin.y = 164 - contentOffsetY;
    } else {
        frame.origin.y = 164;
    }
    bottomView.frame = frame;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float contentOffsetY = scrollView.contentOffset.y;
    if (contentOffsetY <= 0) {
        return;
    }
    if (contentOffsetY < 40) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (contentOffsetY < 100) {
        [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
}




@end
