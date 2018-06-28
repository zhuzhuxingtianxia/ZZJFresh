//
//  NSDecimalNumber+TCM.h
//  Buyer
//
//  Created by Dao on 2018/6/20.
//  Copyright © 2018 Taocaimall Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (TCM)

- (NSDecimalNumber *)decimalNumberByAddingWithString:(NSString *)adding;
- (NSDecimalNumber *)decimalNumberByAddingWithNumber:(double)adding;

- (NSDecimalNumber *)decimalNumberBySubtractingWithString:(NSString *)subtracting;
- (NSDecimalNumber *)decimalNumberBySubtractingWithNumber:(double)subtracting;

- (NSDecimalNumber *)decimalNumberByMultiplyingByString:(NSString *)multiplying;
- (NSDecimalNumber *)decimalNumberByMultiplyingByNumber:(double)multiplying;

- (NSDecimalNumber *)decimalNumberByDividingByString:(NSString *)dividing;
- (NSDecimalNumber *)decimalNumberByDividingByNumber:(double)dividing;


/**
 nullable
 */
- (NSDecimalNumber *)deciamlNumberFromString:(NSString *)string;
+ (NSDecimalNumber *)deciamlNumberFromString:(NSString *)string;
@end


@interface NSString (TCM)

@property (nonatomic, copy, readonly) NSDecimalNumber *deciamlNumber;

@end

