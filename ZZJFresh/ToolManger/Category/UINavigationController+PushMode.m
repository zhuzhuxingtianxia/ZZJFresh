//
//  UINavigationController+PushMode.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/5/21.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "UINavigationController+PushMode.h"

@implementation UINavigationController (PushMode)
- (void)presentModeController:(UIViewController *)modeViewController animated:(BOOL)animated{
    self.interactivePopGestureRecognizer.enabled = NO;
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self pushViewController:modeViewController animated:NO];
    
}
- (void)dismissModeControllerAnimated:(BOOL)animated {
    CATransition* transition = [CATransition animation];
    if (animated) {
        transition.duration = .5f;
    }
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFade;
    //    transition.subtype = kCATransitionFromLeft;
    
    [self.view.layer addAnimation:transition forKey:nil];//添加Animation
    [self popViewControllerAnimated:NO];
    self.interactivePopGestureRecognizer.enabled = YES;
}

@end
