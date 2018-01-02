//
//  UIView+TCMEdgeSlide.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TCMEdgeSlide)
/**
 视图拖动停留在边缘
 
 @param supView 当前视图的父视图
 */
-(void)edgeSliseWithSupView:(UIView*)supView;
/**
 视图拖动停留在边缘

 @param supView 当前视图的父视图
 @param isShake 是否做抖动动画
 */
-(void)edgeSliseWithSupView:(UIView*)supView animatedShake:(BOOL)isShake;

//移除抖动动画
-(void)removeShakeAnimation;

@end
