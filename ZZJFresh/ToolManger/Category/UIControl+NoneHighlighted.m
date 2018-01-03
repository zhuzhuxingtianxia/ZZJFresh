//
//  UIControl+NoneHighlighted.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/3.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "UIControl+NoneHighlighted.h"
#import <objc/runtime.h>

@implementation UIControl (NoneHighlighted)
/*
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setHighlighted:);
        SEL swizzledSelector = @selector(tcm_setHighlighted:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 如果交换类方法, 采用如下的方式:
        
        //交换实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}
*/
#pragma mark - Method Swizzling
- (void)tcm_setHighlighted:(BOOL)highlighted {
    [self tcm_setHighlighted:NO];
    
}


@end
