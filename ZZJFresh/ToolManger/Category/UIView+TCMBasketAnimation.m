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
@property(nonatomic,copy) void (^animationFinished)(BOOL flag);
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
static const void *kAnimationFinished = @"kAnimationFinishedKey";
-(void)setAnimationFinished:(void (^)(BOOL))animationFinished{
    objc_setAssociatedObject(self, kAnimationFinished, animationFinished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(BOOL))animationFinished{
    return objc_getAssociatedObject(self, kAnimationFinished);
}

@end

@implementation UIView (TCMBasketAnimation)
- (void)addProductsToShopCarAnimation:(UIView*)endView completion:(void (^)(BOOL flag))finished{
   
    [self addProductsToShopCarAnimation:endView cartAnimation:NO completion:^(BOOL flag) {
        if (finished) {
            finished(flag);
        }
        
    }];
    
}

- (void)addProductsToShopCarAnimation:(UIView*)endView cartAnimation:(BOOL)animate completion:(void (^)(BOOL flag))finished{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //endView.center
    CGPoint point = [endView.superview convertPoint:CGPointMake(endView.frame.origin.x + endView.frame.size.width/2, endView.frame.origin.y + endView.frame.size.height/2) toView:window];
    self.endView = endView;
    self.animate = animate;
    self.animationFinished = finished;
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
//    CABasicAnimation *cornerRadiusAnimation = [self cornerRadiusAnimationBySize:frame.size];
    
    // 设置路径运动
    CAKeyframeAnimation *pathAnimation = [self parabolaAnimation:fromPoint toPoint:endPoint];
    
    //初始化透明度动画组件
    CABasicAnimation *opacityAnimation = [self opacityAnimation];
    
    //初始化变换动画
    CABasicAnimation *transformAnimation = [self transformAnimation];
    
    //往下抛时旋转小动画
//    CABasicAnimation *rotateAnimation = [self rotationAnimation];
    //加载动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//    groupAnimation.fillMode = kCAFillModeForwards;
//    groupAnimation.removedOnCompletion = NO;
    [groupAnimation setAnimations:@[pathAnimation, opacityAnimation,transformAnimation]];
    groupAnimation.duration = 0.5;
    groupAnimation.delegate = self;
    
    
    [transitionLayer addAnimation:groupAnimation forKey:@"basketAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.animate) {
        [self.endView scaleBounceAnimation];
    }
    if (self.animationFinished) {
        self.animationFinished(flag);
    }
    //动画完毕释放持有的对象
    [self.transitionLayer removeAllAnimations];
    [self.transitionLayer removeFromSuperlayer];
}

//抛物线动画
-(CAKeyframeAnimation*)parabolaAnimation:(CGPoint)fromPoint toPoint:(CGPoint)endPoint{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    pathAnimation.calculationMode = kCAAnimationPaced;
    //    pathAnimation.fillMode = kCAFillModeForwards;
    //    pathAnimation.removedOnCompletion = NO;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:fromPoint];
    if (endPoint.y > fromPoint.y) {
        
        [bezierPath addCurveToPoint:endPoint controlPoint1:CGPointMake(fromPoint.x, fromPoint.y - 30) controlPoint2:CGPointMake(endPoint.x, fromPoint.y - 30)];
    }else{
        [bezierPath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(fromPoint.x, endPoint.y)];
        
    }
    
    pathAnimation.path = [bezierPath CGPath];
    
    return pathAnimation;
}

//变换动画
-(CABasicAnimation*)transformAnimation{
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1.0)];
    transformAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return transformAnimation;
}

//透明度动画
-(CABasicAnimation*)opacityAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0.8;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = true;
    return opacityAnimation;
}

//旋转动画
-(CABasicAnimation*)rotationAnimation{
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:12];
    
    return rotateAnimation;
}

//修剪成圆的动画
-(CABasicAnimation*)cornerRadiusAnimationBySize:(CGSize)size{
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    if (size.height>size.width) {
        [cornerRadiusAnimation setToValue:@(size.width/2.0)];
    }else{
       [cornerRadiusAnimation setToValue:@(size.height/2.0)];
    }
    
    cornerRadiusAnimation.fillMode = kCAFillModeForwards;
    cornerRadiusAnimation.removedOnCompletion = NO;
    
    return cornerRadiusAnimation;
}

#pragma mark -- Public
/*
 缩放动画
 */
-(void)scaleBounceAnimation{
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@1.0 ,@1.4, @0.9, @1.15, @0.95, @1.02, @1.0];
    bounceAnimation.duration = 0.6;
    bounceAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
}

@end
