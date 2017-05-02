//
//  MyLayout.m
//  TT
//
//  Created by wangchunxiang on 2017/3/24.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "MyLayout.h"



@implementation MyLayout
{
    NSMutableArray * _attributeAttay;
    float angle;
    CGFloat radius;
    CGPoint center;
    BOOL isPanTopLocation;   //手势是否在上半部分
    BOOL isFistPan;
}

- (instancetype) init {
    if (self = [super init]) {
        _attributeAttay = [[NSMutableArray alloc]init];
        isFistPan = YES;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    //获取item的个数

    if ([self.collectionView numberOfItemsInSection:0] == _itemCount) {
        return;
    }
    [_attributeAttay removeAllObjects];
    _itemCount = (int)[self.collectionView numberOfItemsInSection:0];
    //先设定大圆的半径 取长和宽最短的
    radius = MIN(self.collectionView.frame.size.width, self.collectionView.frame.size.height)/2;
    //计算圆心位置
    center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2);
    //设置每个item的大小为50*50 则半径为25
    for (int i=0; i<_itemCount; i++) {
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //设置item大小
        attris.size = CGSizeMake(50, 50);
        //计算每个item的圆心位置
        //计算每个item中心的坐标
        //算出的x y值还要减去item自身的半径大小
        float x = center.x+cos(2*M_PI/_itemCount*i)*(radius-25) + mainScreenWidth*4;
        float y = center.y+sin(2*M_PI/_itemCount*i)*(radius-25);
        attris.center = CGPointMake(x, y);
        [_attributeAttay addObject:attris];
    }
    
    UIPanGestureRecognizer *p = self.collectionView.panGestureRecognizer;
    [p addTarget:self action:@selector(panGestureRecognizer:)];
    
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [pan locationInView:self.collectionView];
        BOOL lastPanTopLocation = isPanTopLocation;
        isPanTopLocation = (point.y < self.collectionView.frame.size.height/2);
        
        if (isFistPan) {
            isFistPan = NO;
            return;
        }
        if (lastPanTopLocation != isPanTopLocation) {
            
            float contentOffsetX = angle*mainScreenWidth*speed_page/M_PI;
            if (isPanTopLocation) {//从下边变成上边
                self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - contentOffsetX, 0);
            } else {
                self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + contentOffsetX, 0);
            }
            NSLog(@"==begin==%f",self.collectionView.contentOffset.x);
            return;
        }
    } else if (pan.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"==end==%f",self.collectionView.contentOffset.x);
    }
    
    float contentOffsetX = self.collectionView.contentOffset.x-mainScreenWidth*speed_page;
    angle = 2*M_PI*contentOffsetX/(mainScreenWidth*speed_page);//
}
 

//设置内容区域的大小
- (CGSize)collectionViewContentSize{
    return CGSizeMake(mainScreenWidth*(speed_page+2), 400);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.collectionView.contentOffset.x <= 0) {
        self.collectionView.contentOffset = CGPointMake(mainScreenWidth*speed_page+self.collectionView.contentOffset.x, 0);
    }
    if (self.collectionView.contentOffset.x >= mainScreenWidth*(speed_page+1)) {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x-mainScreenWidth*speed_page, 0);
    }

    if (isPanTopLocation) {
        int i = 0;
        for (UICollectionViewLayoutAttributes *attris in _attributeAttay) {
            
            float x = center.x+cos(2*M_PI/_itemCount*i-angle)*(radius-25) + self.collectionView.contentOffset.x;
            float y = center.y+sin(2*M_PI/_itemCount*i-angle)*(radius-25);
            
            attris.center = CGPointMake(x, y);
            i++;
        }
    } else {
        int i = 0;
        for (UICollectionViewLayoutAttributes *attris in _attributeAttay) {
            
            float x = center.x+cos(2*M_PI/_itemCount*i+angle)*(radius-25) + self.collectionView.contentOffset.x;
            float y = center.y+sin(2*M_PI/_itemCount*i+angle)*(radius-25);
            
            attris.center = CGPointMake(x, y);
            i++;
        }
    }

    return _attributeAttay;
}



@end
