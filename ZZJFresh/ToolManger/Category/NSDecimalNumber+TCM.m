//
//  NSDecimalNumber+TCM.m
//  Buyer
//
//  Created by Dao on 2018/6/20.
//  Copyright © 2018 Taocaimall Inc. All rights reserved.
//

#import "NSDecimalNumber+TCM.h"

@implementation NSDecimalNumber (TCM)


- (NSDecimalNumber *)decimalNumberByAddingWithString:(NSString *)adding{
    return [self decimalNumberByAdding:[self deciamlNumberFromString:adding]];
}
- (NSDecimalNumber *)decimalNumberByAddingWithNumber:(double)adding{
    return [self decimalNumberByAdding:[self deciamlNumberFromString:@(adding).stringValue]];
}

- (NSDecimalNumber *)decimalNumberBySubtractingWithString:(NSString *)subtracting{
    return [self decimalNumberBySubtracting:[self deciamlNumberFromString:subtracting]];
}
- (NSDecimalNumber *)decimalNumberBySubtractingWithNumber:(double)subtracting{
    return [self decimalNumberBySubtracting:[self deciamlNumberFromString:@(subtracting).stringValue]];
}

- (NSDecimalNumber *)decimalNumberByMultiplyingByString:(NSString *)multiplying{
    return [self decimalNumberByMultiplyingBy:[self deciamlNumberFromString:multiplying]];
}
- (NSDecimalNumber *)decimalNumberByMultiplyingByNumber:(double)multiplying{
    return [self decimalNumberByMultiplyingBy:[self deciamlNumberFromString:@(multiplying).stringValue]];
}

- (NSDecimalNumber *)decimalNumberByDividingByString:(NSString *)dividing{
    return [self decimalNumberByDividingBy:[self deciamlNumberFromString:dividing]];
}
- (NSDecimalNumber *)decimalNumberByDividingByNumber:(double)dividing{
    return [self decimalNumberByDividingBy:[self deciamlNumberFromString:@(dividing).stringValue]];
}
- (NSDecimalNumber *)deciamlNumberFromString:(NSString *)string{
    return [NSDecimalNumber deciamlNumberFromString:string];
}

+ (NSDecimalNumber *)deciamlNumberFromString:(NSString *)string{
    if (string) {
        NSDecimalNumber *dec = [NSDecimalNumber decimalNumberWithString:string];
        return dec?:NSDecimalNumber.zero;
    }
    return NSDecimalNumber.zero;
}

@end


@implementation NSString (TCM)


- (NSDecimalNumber *)deciamlNumber{
    return [NSDecimalNumber decimalNumberWithString:self];
}

@end
