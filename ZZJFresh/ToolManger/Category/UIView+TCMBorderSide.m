//
//  UIView+TCMBorderSide.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/2.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "UIView+TCMBorderSide.h"
#import <objc/runtime.h>

@implementation UIView (TCMBorderSide)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    
}
- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
    
}
- (void)setBorderColor:(UIColor*)borderColor {
    self.layer.borderColor = borderColor.CGColor;
    
}
- (UIColor*)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
    
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    
}
- (CGFloat)borderWidth {
    return self.layer.borderWidth;
    
}


- (void)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(TCMBorderSideType)borderSideType{
    
    if (borderSideType == TCMBorderSideTypeAll) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.CGColor;
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /// 左侧
            if (borderSideType & TCMBorderSideTypeLeft) {
                /// 左侧线路径
                [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) borderColor:color borderWidth:borderWidth]];
            }
            
            /// 右侧
            if (borderSideType & TCMBorderSideTypeRight) {
                /// 右侧线路径
                [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) borderColor:color borderWidth:borderWidth]];
            }
            
            /// top
            if (borderSideType & TCMBorderSideTypeTop) {
                /// top线路径
                [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) borderColor:color borderWidth:borderWidth]];
            }
            
            /// bottom
            if (borderSideType & TCMBorderSideTypeBottom) {
                /// bottom线路径
                [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) borderColor:color borderWidth:borderWidth]];
            }
            
        });
        
    }
    
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}

@end
