//
//  NSString+DecimalNumber.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/5/15.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "NSString+DecimalNumber.h"

@implementation NSString (DecimalNumber)

- (NSDecimalNumber *)decimalNumber{
    return [NSDecimalNumber decimalNumberWithString:self.length > 0 ? self : @"0"];
}

- (NSString *(^)(NSString *string))addingBy {
    return ^id(NSString *string){
      NSString *stringValue = [self.decimalNumber decimalNumberByAdding:string.decimalNumber].stringValue;
        return stringValue;
    };
}

- (NSString *(^)(NSString *string))subtractingBy {
    return ^id(NSString *string){
        NSString *stringValue = [self.decimalNumber decimalNumberByMultiplyingBy:string.decimalNumber].stringValue;
        return stringValue;
    };
}

- (NSString *(^)(NSString *string))multiplyingBy {
    return ^id(NSString *string){
        NSString *stringValue = [self.decimalNumber decimalNumberByMultiplyingBy:string.decimalNumber].stringValue;
        return stringValue;
    };
}

- (NSString *(^)(NSString *string))dividingBy {
    return ^id(NSString *string){
        NSInteger tag = string.decimalNumber.doubleValue;
        NSAssert(tag != 0, @"除数不能为零");
        NSString *stringValue = [self.decimalNumber decimalNumberByDividingBy:string.decimalNumber].stringValue;
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
