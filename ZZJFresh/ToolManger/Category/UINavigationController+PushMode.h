//
//  UINavigationController+PushMode.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/5/21.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PushMode)

- (void)presentModeController:(UIViewController *)modeViewController animated:(BOOL)animated;

- (void)dismissModeControllerAnimated:(BOOL)animated;

@end
