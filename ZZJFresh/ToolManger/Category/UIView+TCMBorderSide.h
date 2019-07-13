//
//  UIView+TCMBorderSide.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/2.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 边框类型(位移枚举)
typedef NS_OPTIONS(NSUInteger, TCMBorderSideType) {
    TCMBorderSideTypeAll    = 1 << 0,
    TCMBorderSideTypeTop    = 1 << 1,
    TCMBorderSideTypeBottom = 1 << 2,
    TCMBorderSideTypeLeft   = 1 << 3,
    TCMBorderSideTypeRight  = 1 << 4,
};

#if !TARGET_INTERFACE_BUILDER

@interface UIView (TCMBorderSide)

/**
 设置view指定位置的边框
 
 @param color 边框颜色
 @param borderWidth 边框宽度
 @param borderSideType 边框类型 例子: TCMBorderSideTypeTop|TCMBorderSideTypeBottom
 */
- (void)borderForColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(TCMBorderSideType)borderSideType;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
//对应TCMBorderSideType
@property (nonatomic, assign) TCMBorderSideType borderType;
@end

#else // TARGET_INTERFACE_BUILDER

/**
 xib或Storyboard
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
//对应TCMBorderSideType
@property (nonatomic, assign) IBInspectable NSInteger borderType;

#endif // !TARGET_INTERFACE_BUILDER
