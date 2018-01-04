//
//  UIView+TCMEdgeSlide.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "UIView+TCMEdgeSlide.h"
#import <objc/runtime.h>

@implementation UIView (TCMEdgeSlide)

- (void)setDuration:(NSTimeInterval)duration{
    objc_setAssociatedObject(self, @selector(duration), [NSNumber numberWithDouble:duration], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

- (NSTimeInterval)getDuration{
    return [objc_getAssociatedObject(self, @selector(duration)) doubleValue];
}

-(void)edgeSliseWithSupView:(UIView*)supView{
    
    [self edgeSliseWithSupView:supView animatedShake:NO];
}

-(void)edgeSliseWithSupView:(UIView*)supView shakeLoopDuration:(NSTimeInterval)duration{
    if (supView && self.superview != supView) {
        [supView addSubview:self];
    }
    if (duration > 0) {
        [self setDuration:duration];
        [self loopShakeBall];
    }
    //滑动手势
    UIPanGestureRecognizer *slisePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(slisePanAction:)];
    
    [self addGestureRecognizer:slisePan];
}

// 间隔duration秒循环抖动
-(void)loopShakeBall{
    //递归调用
    [self performSelector:@selector(loopShakeBall) withObject:nil afterDelay:[self getDuration]];
    [self shakeAnimation];
}

-(void)shakeAnimation{
    [self.layer removeAllAnimations];
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.25;
    keyAnimaion.repeatCount = 4;
    [self.layer addAnimation:keyAnimaion forKey:@"shake"];
    
}

-(void)edgeSliseWithSupView:(UIView*)supView animatedShake:(BOOL)isShake{
    if (supView && self.superview != supView) {
        [supView addSubview:self];
    }
    
    if (isShake) {
        //创建动画
        CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
        keyAnimaion.keyPath = @"transform.rotation";
        keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];//度数转弧度
        
        keyAnimaion.removedOnCompletion = NO;
        keyAnimaion.fillMode = kCAFillModeForwards;
        keyAnimaion.duration = 0.25;
        keyAnimaion.repeatCount = MAXFLOAT;
        [self.layer addAnimation:keyAnimaion forKey:@"shake"];
        
    }
    
    //滑动手势
    UIPanGestureRecognizer *slisePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(slisePanAction:)];
    
    [self addGestureRecognizer:slisePan];
}

//滑动
- (void)slisePanAction:(UIPanGestureRecognizer*)sender
{
    //得到偏移量
    CGPoint translation = [sender translationInView:self.superview];
    //通过2D仿射函数中与位移相关的函数来改变视图位置
    //tx,ty X,Y方向的位移
    self.transform = CGAffineTransformTranslate(self.transform, translation.x, translation.y);
    //设置偏移归位CGPointZero = CGPointMake(0,0)
    [sender setTranslation:CGPointZero inView:self.superview];
    CGRect frame = self.frame;
    CGRect supFrame = self.superview.frame;
    // 手势结束
    if (UIGestureRecognizerStateEnded == sender.state) {
        
        // 贴向两侧
        if (frame.origin.x + frame.size.width/2 < supFrame.size.width/2) {
            frame.origin.x = 5;
        }
        else{
            frame.origin.x = supFrame.size.width - frame.size.width - 5;
        }
        
        // 上下限制
        if (frame.origin.y < 0) {
            frame.origin.y = 5;
        }
        else if (frame.origin.y > supFrame.size.height - frame.size.height - 5 - 48){
            frame.origin.y = supFrame.size.height - frame.size.height - 5 - 48;
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.frame = frame;
            
        } completion:nil];
    }
}

//移除抖动动画
-(void)removeShakeAnimation{
    [self.layer removeAnimationForKey:@"shake"];
}

@end
