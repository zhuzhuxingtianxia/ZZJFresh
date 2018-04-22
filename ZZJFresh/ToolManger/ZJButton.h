//
//  ZJButton.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/4/10.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ZJButtonImageAlignmentType) {
    ZJButtonImageAlignmentTypeLeft   = 0,
    ZJButtonImageAlignmentTypeTop    = 1,
    ZJButtonImageAlignmentTypeBottom = 2,
    ZJButtonImageAlignmentTypeRight  = 3,
};

/**
 自定义图片方向的Button(支持xib)
 
 * imageAlignmentType 设定图片方向，为可在xib中直观显示故用NSInteger类型
 * spaceBetweenTitleAndImage 设定图片和文字距离
 */

//IB_DESIGNABLE
@interface ZJButton : UIButton
@property (nonatomic,assign) IBInspectable NSInteger imageAlignmentType;

@property (nonatomic,assign) IBInspectable CGFloat spaceTitleAndImage;

@end
