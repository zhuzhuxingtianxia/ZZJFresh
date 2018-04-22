//
//  ZJButton.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/4/10.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "ZJButton.h"

@implementation ZJButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = _spaceTitleAndImage;
    
    CGFloat titleW = CGRectGetWidth(self.titleLabel.bounds);
    CGFloat titleH = CGRectGetHeight(self.titleLabel.bounds);
    
    CGFloat imageW = CGRectGetWidth(self.imageView.bounds);
    CGFloat imageH = CGRectGetHeight(self.imageView.bounds);
    
    CGFloat btnCenterX = CGRectGetWidth(self.bounds)/2;
    CGFloat imageCenterX = btnCenterX - titleW/2;
    CGFloat titleCenterX = btnCenterX + imageW/2;
    
    switch (_imageAlignmentType){
        case ZJButtonImageAlignmentTypeTop:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(imageH/2+ space/2, -(titleCenterX-btnCenterX), -(imageH/2 + space/2), titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleH/2 + space/2), btnCenterX-imageCenterX, titleH/2+ space/2, -(btnCenterX-imageCenterX));
        }
            break;
            
        case ZJButtonImageAlignmentTypeBottom:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(imageH/2+ space/2), -(titleCenterX-btnCenterX), imageH/2 + space/2, titleCenterX-btnCenterX);
            self.imageEdgeInsets = UIEdgeInsetsMake(titleH/2 + space/2, btnCenterX-imageCenterX,-(titleH/2+ space/2), -(btnCenterX-imageCenterX));
        }
            break;
        case ZJButtonImageAlignmentTypeRight:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageW + space/2), 0, imageW + space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleW+space/2, 0, -(titleW+space/2));
        }
            break;
            
        default:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(0, space/2, 0,  -space/2);
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2, 0, space);
        }
            break;
    }
}

@end
