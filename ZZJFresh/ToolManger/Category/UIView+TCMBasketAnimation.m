//
//  UIView+TCMBasketAnimation.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "UIView+TCMBasketAnimation.h"
#import <objc/runtime.h>

@interface UIView (_TCMBasketAnimation)
@property(nonatomic,strong)CALayer  *transitionLayer;
@property(nonatomic,weak)UIView  *endView;
@property(nonatomic,assign)BOOL  animate;

@end

@implementation UIView (_TCMBasketAnimation)

- (void)setTransitionLayer:(CALayer *)transitionLayer{
    objc_setAssociatedObject(self, @selector(transitionLayer), transitionLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (CALayer *)transitionLayer{
    return (CALayer *)objc_getAssociatedObject(self, @selector(transitionLayer));
}

- (void)setEndView:(UIView *)endView{
    //对指定对象的弱引用
    objc_setAssociatedObject(self, @selector(endView), endView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)endView{
    
    return objc_getAssociatedObject(self, @selector(endView));
}

-(void)setAnimate:(BOOL)animate{
    objc_setAssociatedObject(self, @selector(animate), [NSNumber numberWithBool:animate], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(BOOL)animate{
    
    return [objc_getAssociatedObject(self, @selector(animate)) boolValue];
}

@end

@implementation UIView (TCMBasketAnimation)
- (void)addProductsToShopCarAnimation:(UIView*)endView{
    
    [self addProductsToShopCarAnimation:endView cartAnimation:NO];
    
}

- (void)addProductsToShopCarAnimation:(UIView*)endView cartAnimation:(BOOL)animate{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //endView.center
    CGPoint point = [endView.superview convertPoint:CGPointMake(endView.frame.origin.x + endView.frame.size.width/2, endView.frame.origin.y + endView.frame.size.height/2) toView:window];
    self.endView = endView;
    self.animate = animate;
    [self addToBasket:window moveToPoint:point];
    
}

- (void)addToBasket:(UIView*)foregroundView moveToPoint:(CGPoint)endPoint {
    //判断endPoint是否在foregroundView上
    
    CGRect frame = [self convertRect:self.bounds toView:foregroundView];
    CALayer *transitionLayer = [CALayer new];
    transitionLayer.frame = frame;
    transitionLayer.backgroundColor = self.backgroundColor.CGColor;
    transitionLayer.contents = self.layer.contents;
    //transitionLayer.contentsGravity = kCAGravityResizeAspect;
    [foregroundView.layer addSublayer:transitionLayer];
    self.transitionLayer = transitionLayer;
    
    CGPoint fromPoint = transitionLayer.position;
    
    // 修剪
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    [cornerRadiusAnimation setToValue:@(frame.size.width/2.0)];
    cornerRadiusAnimation.fillMode = kCAFillModeForwards;
    cornerRadiusAnimation.removedOnCompletion = NO;
    
    // 设置路径运动
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.calculationMode = kCAAnimationPaced;
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.removedOnCompletion = NO;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:fromPoint];
    if (endPoint.y > fromPoint.y) {
        [bezierPath addCurveToPoint:endPoint controlPoint1:CGPointMake(fromPoint.x, fromPoint.y - 30) controlPoint2:CGPointMake(endPoint.x, endPoint.y - 30)];
    }else{
        [bezierPath addCurveToPoint:endPoint controlPoint1:CGPointMake(fromPoint.x, fromPoint.y + 30) controlPoint2:CGPointMake(endPoint.x, endPoint.y + 30)];
    }
    
    pathAnimation.path = [bezierPath CGPath];
    
    //初始化透明度动画组件
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0.8;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = true;
    
    //初始化变换动画
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1.0)];
    
    //加载动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//    groupAnimation.fillMode = kCAFillModeForwards;
//    groupAnimation.removedOnCompletion = NO;
    [groupAnimation setAnimations:@[pathAnimation, opacityAnimation,transformAnimation]];
    groupAnimation.duration = 0.8;
    groupAnimation.delegate = self;
    
    
    [transitionLayer addAnimation:groupAnimation forKey:@"basketAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.animate) {
        [self.endView scaleBounceAnimation];
    }
    //动画完毕释放持有的对象
    [self.transitionLayer removeAllAnimations];
    [self.transitionLayer removeFromSuperlayer];
}

-(void)scaleBounceAnimation{
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = 0.6;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
}

@end
