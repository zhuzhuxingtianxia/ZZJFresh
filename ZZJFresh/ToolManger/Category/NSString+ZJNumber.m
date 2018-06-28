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
       NSString *lastString = delLastZero(self);
       return lastString;
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
