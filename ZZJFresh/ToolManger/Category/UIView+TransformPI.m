//
//  UIView+TransformPI.m
//  Buyer
//
//  Created by ZZJ on 2018/3/29.
//  Copyright © 2018年 淘菜猫. All rights reserved.
//

#import "UIView+TransformPI.h"

@implementation UIView (TransformPI)
-(void)setIsTransformPI:(BOOL)isTransformPI{
    objc_setAssociatedObject(self, @selector(isTransformPI), [NSNumber numberWithBool:isTransformPI], OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (isTransformPI) {
        [self transformLayerAngle:M_PI];
    }else{
        [self transformLayerAngle:0];
    }
}
-(BOOL)isTransformPI{
    return [objc_getAssociatedObject(self, @selector(isTransformPI)) boolValue];
}

/**
 对view做180度旋转

 @param animation 是否动画
 */
-(void)transformPIAnimation:(BOOL)animation{
    [self transformViewAngle:M_PI animation:animation];
}
/**
 对view做90度旋转
 
 @param animation 是否动画
 */
-(void)transformPI_2Animation:(BOOL)animation{
    [self transformViewAngle:M_PI_2 animation:animation];
}

/**
 视图layer旋转

 @param angle 旋转的角度 范围-M_PI ～ M_PI
 */
-(void)transformLayerAngle:(CGFloat)angle{
    CALayer *layer = self.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / 500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle, 1.0f, 0.0f, 0.0f);
    layer.transform = rotationAndPerspectiveTransform;
}

/**
 视图旋转，若处于复位（或默认）状态则旋转，否则则复位

 @param angle 旋转的角度 例如：M_PI_2、M_PI、2*M_PI
 @param animation 是否采用动画
 */
-(void)transformViewAngle:(CGFloat)angle animation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.25 animations:^{
            [self transformViewAngle:angle];
        }];
        
    }else{
        [self transformViewAngle:angle];
    }
    
}

/**
 视图旋转，若处于复位（或默认）状态则旋转，否则则复位

 @param angle 旋转的角度
 */
-(void)transformViewAngle:(CGFloat)angle{
    if (CGAffineTransformIsIdentity(self.transform)) {
        self.transform = CGAffineTransformMakeRotation(angle);
    }else{
        self.transform = CGAffineTransformIdentity;
    }
}

/**
 视图layer做一个上下的3D旋转

 @param rotate 是否旋转
 */
- (void)transform3DRotate:(BOOL)rotate{
    [UIView animateWithDuration:.25 animations:^{
        self.layer.transform = CATransform3DRotate(self.layer.transform, rotate ? M_PI : -M_PI, 1.0f, 0.0f, 0.0f);
    }];
    
    /*
    [UIView transitionFromView:self toView:self.superview duration:.25 options:UIViewAnimationOptionTransitionFlipFromTop completion:^(BOOL finished) {
        
    }];
     */
    /*
    [UIView transitionWithView:self duration:.25 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
     */
}

@end
