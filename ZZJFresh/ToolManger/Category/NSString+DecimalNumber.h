//
//  NSString+DecimalNumber.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/5/15.
//  Copyright © 2018年 Jion. All rights reserved.
//  链式方法可直接打点调用

#import <Foundation/Foundation.h>

@interface NSString (DecimalNumber)
/**
 小数
 
 @return 小数
 */
- (NSDecimalNumber *)decimalNumber;
/**
 加法。
 用法: str = @"3".addingBy(@"5");
 
 string 加数
 @return 和
 */
- (NSString *(^)(NSString *string))addingBy;
/**
 减法
 
 string 减数
 @return 差
 */
- (NSString *(^)(NSString *string))subtractingBy;
/**
 乘法
 
 string 乘数
 @return 积
 */
- (NSString *(^)(NSString *string))multiplyingBy;
/**
 除法
 
 string 除数，⚠️需要注意是零的情况
 @return 商
 */
- (NSString *(^)(NSString *string))dividingBy;

/**
 乘方指数,例如：2的（3）次方 = 8
 4的（1/2.0）次方 = 4的平方根 = 2
 2的（-2）次方 = 1/2.0的2次方 = 0.25
 power n次方数
 @return 幂
 */
- (NSString *(^)(CGFloat power))raisingToPower;
/*
 乘以10的power次方，例如：“2”*（10的3次方）= 2x1000
 
 “2”*（10的-2次方）= 0.02
 
 power 对数
 @return 结果
 */
- (NSString *(^)(short power))multiplyingByPowerOf10;

/**
 操作后设置取舍模式
 
 roundingMode 取舍模式，scale 保留几位小数
 @return 取舍的结果
 */
- (NSString *(^)(NSRoundingMode roundingMode,short scale))endRoundingMode;

@end
