//
//  UIControl+Delay.h
//  ZZJFresh
//
//  Created by ZZJ on 2020/12/1.
//  Copyright © 2020 Jion. All rights reserved.
// 避免 UIButton 频繁点击

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Delay)

/// 点击事件响应的时间间隔，不设置或者大于 0 时为默认时间间隔
@property (nonatomic, assign) NSTimeInterval clickInterval;
/// 是否忽略响应的时间间隔
@property (nonatomic, assign) BOOL ignoreClickInterval;
+ (void)kk_exchangeClickMethod;

@end

NS_ASSUME_NONNULL_END
