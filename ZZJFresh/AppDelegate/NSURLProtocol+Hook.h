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

typedef enum : NSUInteger {
    LogLevel_0,
    LogLevel_1,
    LogLevel_2,
    LogLevel_None = 99
} LogLevel;

@interface HKURLProtocol : NSURLProtocol

+ (BOOL)hk_registerClass;
+ (void)hk_unregisterClass;
/*
 log: 日志等级，默认LogLevel_0
 reset: 每次重启xcode是否重制日志文件，默认NO
 */
+ (void)setLogLevel:(LogLevel)log initResetLog:(BOOL)reset;
//host拦截名单
+ (void)domainHookList:(NSArray<NSString*> *)array;
//host过滤名单
+ (void)domainFilterList:(NSArray<NSString*> *)array;

@end

NS_ASSUME_NONNULL_END
