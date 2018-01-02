//
//  UIView+TCMBasketAnimation.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TCMBasketAnimation)<CAAnimationDelegate>

- (void)addProductsToShopCarAnimation:(UIView*)endView;

/**
 <#Description#>

 @param foregroundView <#foregroundView description#>
 @param point <#point description#>
 @param endPoint <#endPoint description#>
 */
- (void)addToBasket:(UIView*)foregroundView moveToPoint:(CGPoint)endPoint;
@end
