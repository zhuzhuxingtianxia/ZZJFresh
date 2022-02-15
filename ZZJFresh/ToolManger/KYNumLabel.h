//
//  KYNumLabel.h
//  ZZJFresh
//
//  Created by ZZJ on 2022/2/15.
//  Copyright © 2022 Jion. All rights reserved.
// 金额数字滚动动画

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYNumLabel : UIView

+(instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)textColor;
+(instancetype)initWithNumArr:(NSString *)numStr font:(UIFont *)font textColor:(UIColor *)textColor;

-(void)animateShowWithDuration:(double)duration;


@end

NS_ASSUME_NONNULL_END
