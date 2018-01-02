//
//  UIFont+AutoLayout.m
//  BD
//
//  Created by Dao on 16/8/27.
//  Copyright © 2016年 淘菜猫. All rights reserved.
//

#import "UIFont+AutoLayout.h"

@implementation UIFont (AutoLayout)

+ (UIFont *)tcmFontOfSize:(CGFloat)Size
{

    if (IPHONE)
        return [UIFont systemFontOfSize:Size-2];
    else if (IPHONE_PLUS)
        return [UIFont systemFontOfSize:Size+2];
    
    return [UIFont systemFontOfSize:Size];
}

+ (UIFont *)tcmBFontOfSize:(CGFloat)Size
{

    if (IPHONE)
        return [UIFont boldSystemFontOfSize:Size-2];
    else if (IPHONE_PLUS)
        return [UIFont boldSystemFontOfSize:Size+2];
    
    return [UIFont boldSystemFontOfSize:Size];
}


+ (UIFont *)tcmFontOfiPhoneSize:(CGFloat)iPhoneSize iPhoneStdSize:(CGFloat)iPhoneStdSize iPhonePlusSize:(CGFloat)iPhonePlusSize
{
    if (IPHONE)
        return [UIFont systemFontOfSize:iPhoneSize];
    else if (IPHONE_PLUS)
        return [UIFont systemFontOfSize:iPhonePlusSize];
    
    return [UIFont systemFontOfSize:iPhoneStdSize];
}


+ (UIFont *)tcmBFontOfiPhoneSize:(CGFloat)iPhoneSize iPhoneStdSize:(CGFloat)iPhoneStdSize iPhonePlusSize:(CGFloat)iPhonePlusSize
{
    
    
    if (IPHONE)
        return [UIFont boldSystemFontOfSize:iPhoneSize];
    else if (IPHONE_PLUS)
        return [UIFont boldSystemFontOfSize:iPhonePlusSize];
    
    return [UIFont boldSystemFontOfSize:iPhoneStdSize];
}

@end
