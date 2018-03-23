//
//  BadgeButton.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeButton : UIControl
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, copy) NSString *image;

@property(nonatomic,assign)BOOL isAnimation;
@end
