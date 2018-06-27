//
//  UIImage+Additions.h
//  ASK
//
//  Created by ZZJ on 14-6-18.
//  Copyright (c) 2014年 ZZJ. All rights reserved.
//

#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, InputImageType) {
    InputImageType_White,
    InputImageType_Gray,
};

@interface UIImage (Additions)

+ (UIImage *)inputImageWithType:(InputImageType)type;

+ (UIImage *)fc_solidColorImageWithSize:(CGSize)size color:(UIColor *)solidColor;

/*
 * Return UIImage object with the assign color, the default size of the image is CGSize(1.0f,1.0f)
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*
 * Return UIImage object with the assign color and size
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)buttonImageWithName:(NSString *)imageName WithCapInsets:(UIEdgeInsets)insets;

/*
 * Convert UIView to UIImage object!
 */
+ (UIImage *)imageWithView:(UIView *)view;

+ (UIImage *)imageWithBundleName:(NSString *)strImage;


/**
 *
 *  图片自定义大小
 *  @param image 原图
 *  @param newSize 自定义小
 *  @return 新图
 */

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
//图片修改大小
- (UIImage*)imageWithScaledToSize:(CGSize)newSize;

/*
   图片裁剪
 */
- (void)drawInRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode clipsToBounds:(BOOL)clips;
/**
 *
 *  图片等比缩放
 *  @param scaleSize 缩放参数
 */
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize;


/**
 *
 *  @param size  图片最大kb.大于此size进行压缩
 */
+ (NSData *)autoScaleImage:(UIImage *)image MaxSize:(NSInteger)size;



/**
 *
 *  给图片添加模糊效果
 */
- (UIImage*)blurredImage:(CGFloat)blurAmount;
/**
 *
 *  设置圆角图片
 */
- (UIImage *)circleImage;


@end
