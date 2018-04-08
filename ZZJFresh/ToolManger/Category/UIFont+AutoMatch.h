//
//  UIFont+AutoMatch.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/4/8.
//  Copyright © 2018年 Jion. All rights reserved.
// 以375尺寸为标准的字体适配

#import <UIKit/UIKit.h>

@interface UIFont (AutoMatch)
+ (UIFont *)fontOfSize:(CGFloat)fontSize;

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize;

@end
