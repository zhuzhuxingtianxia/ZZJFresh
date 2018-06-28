//
//  NSString+ZJNumber.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/6/28.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "NSString+ZJNumber.h"

@implementation NSString (ZJNumber)
-(NSString*)deleteLastZero {
    if ([self rangeOfString:@"."].location != NSNotFound) {
        NSArray *stringArray = [self componentsSeparatedByString:@"."];
        if (stringArray.count == 2) {
            NSString *lastString =  stringArray.lastObject;
            if ([lastString integerValue] > 0) {
                lastString = delLastZero(lastString);
                NSString *resultString = [stringArray.firstObject stringByAppendingFormat:@".%@",lastString];
                return resultString;
                
            }else{
                return stringArray.firstObject;
            }
        }
    }
    
    return self;
}

NSString *delLastZero(NSString *string) {
    NSString *lastPlace = [string substringFromIndex:string.length-1];
    if ([lastPlace integerValue] == 0) {
        string = [string substringToIndex:string.length-1];
        string = delLastZero(string);
    }
    return string;
}

@end
