//
//  NSURLProtocol+Hook.h
//  ZZJFresh
//
//  Created by ZZJ on 2021/11/26.
//
/*
 AppDelegate里面注册后，即可对网络请求拦截
 
 [NSURLProtocol hk_registerClass];
 
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

//对象方法交换
static void hk_exchangedMethod(SEL originalSelector, SEL swizzledSelector, Class class);
//类方法交换
static void hk_exchangedClassMethod(SEL originalSelector, SEL swizzledSelector, Class class);

@interface NSURLProtocol (Hook)
+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end

@interface HKURLProtocol : NSURLProtocol

+ (BOOL)hk_registerClass;
+ (void)hk_unregisterClass;

@end

@interface NSURLSessionConfiguration (Hook)

@end

NS_ASSUME_NONNULL_END
