//
//  BadgeButton.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "BadgeButton.h"
#import "UIView+TCMBasketAnimation.h"
@interface BadgeButton ()
@property (nonatomic ,strong, readonly) UILabel *badgeLabel;
@property (nonatomic ,strong, readonly) UIImageView *normalImgaeView;

@end
@implementation BadgeButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.font = TCM_Font(11.0);
        _badgeLabel.textColor = Color_TEXT_NO_1;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.backgroundColor = Color_Background_NO_9;
        _normalImgaeView = [[UIImageView alloc]init];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.normalImgaeView sizeToFit];
    [self.badgeLabel sizeToFit];
    _badgeLabel.mj_h += _badgeLabel.text.length ? 2 : 0;
    _badgeLabel.mj_w = _badgeLabel.mj_w < _badgeLabel.mj_h ? _badgeLabel.mj_h : _badgeLabel.mj_w;
    self.normalImgaeView.center = CGPointMake(self.bounds.size.width*.5, self.bounds.size.height*.5);
    self.badgeLabel.center = CGPointMake(CGRectGetMaxX(self.normalImgaeView.frame), CGRectGetMinY(self.normalImgaeView.frame));
    self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.size.height*.5;
    self.badgeLabel.layer.masksToBounds = YES;
    [self addSubview:self.normalImgaeView];
    [self addSubview:self.badgeLabel];
}

- (void)setBadge:(NSString *)badge{
    if ([self.badgeLabel.text integerValue] < [badge integerValue] && _isAnimation) {
        [self scaleBounceAnimation];
    }
    [self.badgeLabel setText:badge.intValue <= 0 ? nil : badge];
    [self setNeedsLayout];
}

- (void)setImage:(NSString *)image{
    [self.normalImgaeView setImage:[UIImage imageNamed:image]];
    [self setNeedsLayout];
}


@end
