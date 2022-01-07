//
//  TCMNavigationController.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerProtocol <NSObject>
@optional

-(void)popViewController;

@end

@interface UIViewController (Navigation)<UIViewControllerProtocol>

@end

@interface TCMNavigationController : UINavigationController

@end
