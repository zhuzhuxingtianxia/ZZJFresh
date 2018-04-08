//
//  UIFont+AutoMatch.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/4/8.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "UIFont+AutoMatch.h"

@implementation UIFont (AutoMatch)
//以375尺寸为标准
+ (UIFont *)fontOfSize:(CGFloat)fontSize{
    CGFloat size = [UIScreen mainScreen].bounds.size.width/375.0 * fontSize;
    return [UIFont systemFontOfSize:size];
}
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize{
    CGFloat size = [UIScreen mainScreen].bounds.size.width/375.0 * fontSize;
    return [UIFont boldSystemFontOfSize:size];
}

@end
