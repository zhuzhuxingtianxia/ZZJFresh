//
//  UIFont+AutoLayout.h
//  BD
//
//  Created by Dao on 16/8/27.
//  Copyright © 2016年 淘菜猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AutoLayout)

+ (UIFont *)tcmFontOfSize:(CGFloat)Size;
+ (UIFont *)tcmBFontOfSize:(CGFloat)Size;

+ (UIFont *)tcmFontOfiPhoneSize:(CGFloat)iPhoneSize iPhoneStdSize:(CGFloat)iPhoneStdSize iPhonePlusSize:(CGFloat)iPhonePlusSize;
+ (UIFont *)tcmBFontOfiPhoneSize:(CGFloat)iPhoneSize iPhoneStdSize:(CGFloat)iPhoneStdSize iPhonePlusSize:(CGFloat)iPhonePlusSize;

@end
