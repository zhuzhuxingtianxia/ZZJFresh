//
//  UIView+TransformPI.h
//  Buyer
//
//  Created by ZZJ on 2018/3/29.
//  Copyright © 2018年 淘菜猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TransformPI)

/**
 对view的layer做180度旋转，没有动画效果
 不设置或为NO这为原来的视图
 */
@property(nonatomic,assign)BOOL  isTransformPI;
/**
 对view做180度旋转
 
 @param animation 是否动画
 */
-(void)transformPIAnimation:(BOOL)animation;
/**
 对view做90度旋转
 
 @param animation 是否动画
 */
-(void)transformPI_2Animation:(BOOL)animation;
/**
 视图layer做一个上下的3D旋转
 
 @param rotate 是否旋转
 */
- (void)transform3DRotate:(BOOL)rotate;

@end
