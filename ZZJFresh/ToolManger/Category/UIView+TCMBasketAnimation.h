//
//  UIView+TCMBasketAnimation.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TCMBasketAnimation)<CAAnimationDelegate>

/**
 将商品添加到购物车的动画

 @param endView 购物车🛍️view
 @param animate 加入购物车后，购物车是否做动画效果
 */
- (void)addProductsToShopCarAnimation:(UIView*)endView cartAnimation:(BOOL)animate;
- (void)addProductsToShopCarAnimation:(UIView*)endView;

/**
 将当前视图在前景视图foregroundView移动到endPoint位置

 @param foregroundView 移动效果所在的前景视图
 @param endPoint 移动到的位置
 */
- (void)addToBasket:(UIView*)foregroundView moveToPoint:(CGPoint)endPoint;

//缩放动画
-(void)scaleBounceAnimation;

@end
