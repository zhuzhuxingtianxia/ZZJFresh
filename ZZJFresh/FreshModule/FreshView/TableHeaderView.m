//
//  TableHeaderView.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/15.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "TableHeaderView.h"
@interface TableHeaderView ()
@property(nonatomic,strong)UIImageView *imgView;
@end

@implementation TableHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
    }
    return self;
}
#pragma mark -- setter
-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
}

#pragma mark -- getter
-(UIImageView*)imgView{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.image = [UIImage imageNamed:@"defaultImage"];
    }
    
    return _imgView;
}

@end
