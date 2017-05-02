//
//  JRBubbleView.m
//  TT
//
//  Created by wangchunxiang on 2017/2/6.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "JRBubbleView.h"

@implementation JRBubbleView
{
    UILabel *title;
    UIImageView *imageView;
}

//- (void)drawRect:(CGRect)rect {
//    
//    /*图片*/
//    UIImage *image = [UIImage imageNamed:@"1"];
////    [image drawInRect:CGRectMake(0, 0, 20, 20)];//在坐标中画出图片
//    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height) blendMode:kCGBlendModeNormal alpha:1];
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        title.backgroundColor = [UIColor redColor];
//        title.textColor = [UIColor whiteColor];
//        title.text = @"fdsfs";
//        title.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:title];
//
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:title.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(7,7)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//
//        maskLayer.frame = title.bounds;
//        maskLayer.path = maskPath.CGPath;
//        title.layer.mask = maskLayer;
        
        
        
        self.backgroundColor = [UIColor redColor];
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        UIImage *image = [UIImage imageNamed:@"1"];
//        image 
        imageView.image = [self imageToWhiteImage2:image radius:375/2.0 color:[UIColor greenColor] lineWidth:2];
    }
    return self;
}

- (UIImage *)imageToWhiteImage:(UIImage *)image radius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*radius, 2*radius), NO, [UIScreen mainScreen].scale);
    CGFloat x, y, width, height;
    if (image.size.width > image.size.height) {
        float rate = 2*radius/image.size.height;
        width = image.size.width*rate;
        height = 2*radius;
        x = (image.size.height - image.size.width)*rate/2;
        y = 0;
    } else {
        float rate = 2*radius/image.size.width;
        width = 2*radius;
        height = image.size.height*rate;
        x = 0;
        y = (image.size.width - image.size.height)*rate/2;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect bigRect = CGRectMake(0, 0, 2*radius, 2*radius);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, bigRect);
    CGContextFillPath(context);
    
    CGRect smallRect = CGRectMake(lineWidth, lineWidth, 2*(radius-lineWidth), 2*(radius-lineWidth));
    CGContextAddEllipseInRect(context, smallRect);
    CGContextClip(context);
    
    [image drawInRect:CGRectMake(x, y, width, height)];
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}

- (UIImage *)imageToWhiteImage2:(UIImage *)image radius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*radius, 2*radius), NO, [UIScreen mainScreen].scale);
    CGFloat x, y, width, height;
    if (image.size.width > image.size.height) {
        float rate = 2*radius/image.size.height;
        width = image.size.width*rate;
        height = 2*radius;
        x = (image.size.height - image.size.width)*rate/2;
        y = 0;
    } else {
        float rate = 2*radius/image.size.width;
        width = 2*radius;
        height = image.size.height*rate;
        x = 0;
        y = (image.size.width - image.size.height)*rate/2;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddArc(context, radius, radius, radius, 0, 2*M_PI, 0); //添加一个圆
    CGContextClip(context);
    
    [image drawInRect:CGRectMake(x, y, width, height)];
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    CGContextAddArc(context, radius, radius, radius, 0, 2*M_PI, 0); //添加一个圆
    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
    CGContextDrawPath(context, kCGPathEOFillStroke); //绘制路径加填充

    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImg;
}


@end
