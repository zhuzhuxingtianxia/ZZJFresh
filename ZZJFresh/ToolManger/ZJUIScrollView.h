//
//  ZJUIScrollView.h
//  ZZJFresh
//
//  Created by ZZJ on 2019/3/19.
//  Copyright © 2019 Jion. All rights reserved.
//
//AOP面向切面：https://juejin.im/post/5c86be73f265da2dd94ce3b3
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZJUIScrollViewAspect<NSObject>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface ZJUIScrollView : UIScrollView<ZJUIScrollViewAspect>

@end

NS_ASSUME_NONNULL_END
