//
//  NSString+DecimalNumber.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/5/15.
//  Copyright © 2018年 Jion. All rights reserved.
//
/*
 //mantissa：长整形；exponent：指数；flag：正负数
 NSDecimalNumber * amount0 = [[NSDecimalNumber alloc] initWithMantissa:42 exponent:-2 isNegative:NO];//0.42
 NSDecimalNumber * amount1 = [[NSDecimalNumber alloc] initWithMantissa:42 exponent:-2 isNegative:NO];//-4200
 
 
 //locale代表一种格式,对于这种格式可以参考一下例子去理解
 NSDictionary *locale0 = [NSDictionary dictionaryWithObject:@"," forKey:NSLocaleDecimalSeparator];    //以","当做小数点格式
 NSDecimalNumber * amount2 = [[NSDecimalNumber alloc] initWithString:@"42,68" locale:locale0];//42.68
 NSLocale *locale5 = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];//法国数据格式,法国的小数点是','逗号
 NSDecimalNumber * amount3 = [[NSDecimalNumber alloc] initWithString:@"42.68" locale:locale5];//42.68
 */

#import "NSString+DecimalNumber.h"
#import <math.h>

@implementation NSString (DecimalNumber)

- (NSDecimalNumber *)decimalNumber{
    return [NSDecimalNumber decimalNumberWithString:self.length > 0 ? self : @"0"];
}

- (NSString *(^)(NSString *string))addingBy {
    return ^id(NSString *string){
        if (!string) {
            string = @"0";
        }
      NSString *stringValue = [self.decimalNumber decimalNumberByAdding:string.decimalNumber].stringValue;
        return stringValue;
    };
}

- (NSString *(^)(NSString *string))subtractingBy {
    return ^id(NSString *string){
        if (!string) {
            string = @"0";
        }
        NSString *stringValue = [self.decimalNumber decimalNumberByMultiplyingBy:string.decimalNumber].stringValue;
        return stringValue;
    };
}

- (NSString *(^)(NSString *string))multiplyingBy {
    return ^id(NSString *string){
        if (!string) {
            string = @"1";
        }
        NSString *stringValue = [self.decimalNumber decimalNumberByMultiplyingBy:string.decimalNumber].stringValue;
        return stringValue;
    };
}

- (NSString *(^)(NSString *string))dividingBy {
    return ^id(NSString *string){
        if (!string) {
            string = @"1";
        }
        NSInteger tag = string.decimalNumber.doubleValue;
        NSAssert(tag != 0, @"除数不能为零");
        NSString *stringValue = [self.decimalNumber decimalNumberByDividingBy:string.decimalNumber].stringValue;
        return stringValue;
    };
}

/*
 指数
 */
- (NSString *(^)(CGFloat power))raisingToPower {
    
    return ^id(CGFloat power){
        NSString *stringValue;
        long double dnumber = powl(self.decimalNumber.doubleValue,power);
        stringValue = [NSNumber numberWithDouble:dnumber].stringValue;
        /*
        if (power < 0) {
           NSAssert(power < 0, @"次方数不能为负数");
        }else{
            stringValue = [self.decimalNumber decimalNumberByRaisingToPower:power].stringValue;
        }*/
       
        return stringValue;
    };
}
/*
 乘以10的power次方
 */
- (NSString *(^)(short power))multiplyingByPowerOf10 {
    
    return ^id(short power){
        NSString *stringValue = [self.decimalNumber decimalNumberByMultiplyingByPowerOf10:power].stringValue;
        return stringValue;
    };
}
/**
 操作后设置取舍模式
 
 roundingMode 取舍模式，scale 保留几位小数
 @return 取舍的结果
 */
- (NSString *(^)(NSRoundingMode roundingMode,short scale))endRoundingMode {
    return ^id(NSRoundingMode roundingMode,short scale){
        NSDecimalNumberHandler*roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
        NSString *stringValue = [self.decimalNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1"] withBehavior:roundUp].stringValue;
        
        return stringValue;
    };
}

@end
