//
//  SDWebImageImageIOCoder+SDImageCoder.m
//  Buyer
//
//  Created by ZZJ on 2018/8/21.
//  Copyright © 2018年 Taocaimall Inc. All rights reserved.
//

#import "SDWebImageImageIOCoder+SDImageCoder.h"
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
/*
@interface SDWebImageImageIOCoder (Private)
+ (UIImageOrientation)sd_imageOrientationFromImageData:(nonnull NSData *)imageData;
@end
@implementation SDWebImageImageIOCoder (SDImageCoder)

+ (void)load{
    Method Method1 = class_getInstanceMethod(self, @selector(tcm_decodedImageWithData:));
    Method Method2 = class_getInstanceMethod(self, @selector(decodedImageWithData:));
    method_exchangeImplementations(Method1, Method2);
    
}

- (UIImage *)tcm_decodedImageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    UIImage *image = [[UIImage alloc] initWithData:data];
    
#if SD_MAC
    return image;
#else
    if (!image) {
        return nil;
    }
    image = [[UIImage alloc] initWithData:data];
    if (data.length/1024 > 256) {
        image = [self compressImageWith:image];
        if ([self usedMemory] > 200) {
            [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        }
    }
    UIImageOrientation orientation = [[self class] sd_imageOrientationFromImageData:data];
    if (orientation != UIImageOrientationUp) {
        image = [[UIImage alloc] initWithCGImage:image.CGImage scale:image.scale orientation:orientation];
    }
    
    return image;
#endif
}

-(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

//获取当前任务所占用的内存
- (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn =task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS ) {
        return NSNotFound;
        
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
    
}


@end
*/
