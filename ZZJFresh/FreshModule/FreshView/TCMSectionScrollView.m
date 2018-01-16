//
//  TCMSectionScrollView.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMSectionScrollView.h"
#import "TCMFreshModel.h"
#define Offset 5
@interface TCMSectionScrollView ()
@property(nonatomic,strong)UIScrollView  *scrollView;

@property(nonatomic,strong)NSMutableArray<UIButton *> *itemsArray;
@property(nonatomic,strong)UIButton *selectButton;

@end
@implementation TCMSectionScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self setup];
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    if (selectIndex >= self.itemsArray.count) return;
    if (_selectIndex != selectIndex) {
        _selectIndex = selectIndex;
        UIButton *button = self.itemsArray[selectIndex];
        
        if (self.selectButton != button) {
            self.selectButton.selected = NO;
            self.selectButton.backgroundColor = [UIColor clearColor];
        }
        
        button.selected = YES;
        button.backgroundColor = RGB(233, 5, 50);
        self.selectButton = button;
        
        [self animateItem:button click:NO];
    }
    
}

- (void)setSourceArray:(NSArray *)sourceArray{
    if (_sourceArray != sourceArray) {
        _sourceArray = sourceArray;
        UIView *lastView;
        for (NSInteger k = 0; k < _sourceArray.count; k ++) {
            TCMFreshActivityModel *model = _sourceArray[k];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = k;
            CGFloat itemW = (IPHONE_SCREEN_WIDTH-5*Offset)/4;
            CGFloat x = Offset + (itemW + Offset) * k;
            button.frame = CGRectMake(x, TCM_StdLayout(10), itemW, TCM_StdLayout(30));
            [button setTitle:model.classify forState:UIControlStateNormal];
            [button setTitleColor:Color_TEXT_NO_7 forState:UIControlStateNormal];
            [button setTitleColor:Color_TEXT_NO_1 forState:UIControlStateSelected];
            
            if (k == 0) {
                button.selected = YES;
                button.backgroundColor = RGB(233, 5, 50);
                self.selectButton = button;
            }else{
               button.backgroundColor = [UIColor clearColor];
            }
            
            button.titleLabel.font = TCM_Font(16);
            button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
            button.layer.masksToBounds = YES;
            
            [button addTarget:self action:@selector(didSelectItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.itemsArray addObject:button];
            [self.scrollView addSubview:button];
            
            lastView = button;
            
        }
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastView.frame) + Offset, TCM_StdLayout(45));
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

#pragma mark Action
- (void)didSelectItem:(UIButton*)sender{
    if (self.selectButton == sender) {
        return;
    }else{
        self.selectButton.selected = NO;
        self.selectButton.backgroundColor = [UIColor clearColor];
    }
    
    sender.selected = YES;
    sender.backgroundColor = RGB(233, 5, 50);
    self.selectButton = sender;
    
    [self animateItem:sender click:YES];
    
    _selectIndex = sender.tag;
    if ([self.delegate respondsToSelector:@selector(sectionScrollView:didSelectIndex:)]) {
        [self.delegate sectionScrollView:self didSelectIndex:[NSIndexPath indexPathForRow:0 inSection:_selectIndex]];
    }
}

-(void)animateItem:(UIButton *)sender click:(BOOL)isClick{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGPoint changePoint;
        CGFloat weight = sender.frame.size.width;
        
        
        
        if (sender.tag >= _sourceArray.count - (isClick ? 1 : 2)) {
            //不做偏移
            changePoint = _scrollView.contentOffset;
            
        }else if (sender.frame.origin.x >= _scrollView.bounds.size.width/2 && sender.tag > 1){
            
            changePoint = CGPointMake((sender.tag - (isClick ? 2 : 1))*(weight+Offset), 0);
            
            
        }else{
            changePoint = CGPointZero;
        }
        
        _scrollView.contentOffset = changePoint;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark  Getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.directionalLockEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        
    }
    return _scrollView;
}

- (NSMutableArray <UIButton *> *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

@end
