//
//  JRHeader.m
//  TT
//
//  Created by wangchunxiang on 2016/12/28.
//  Copyright © 2016年 wangchunxiang. All rights reserved.
//

#import "JRHeader.h"

@implementation JRHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 100, 30)];
        label.text = @"header";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
        label.center = self.center;
        label.backgroundColor = [UIColor cyanColor];
        
    }
    return self;
}

- (void)test {

}

@end
