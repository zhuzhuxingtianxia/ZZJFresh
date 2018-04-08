//
//  UIColor+HexConvert.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/4/8.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexConvert)
/**
 返回随机颜色
 */
+ (instancetype)randColor;

/**
 *  将16进制字符串转换成UIColor 可设置alpha值
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 *  将16进制字符串转换成UIColor
 */
+ (UIColor *)colorHexString:(NSString *)hexString;
/**
 *  将16进制数转换成UIColor
 */
+ (UIColor *)colorHexNumber:(unsigned long)hexNumber;
/**
 *  将16进制数转换成UIColor,可设置alpha值
 */
+ (UIColor *)colorHexNumber:(unsigned long)hexNumber alpha:(CGFloat)alpha;
@end
