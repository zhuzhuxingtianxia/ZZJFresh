//
//  BottomBasketView.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/22.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "BottomBasketView.h"
#import "BadgeButton.h"
#import "PresentBasketList.h"
@interface BottomBasketView ()<PresentBasketListDelegate>
{
    NSLayoutConstraint *_catConstraint;
    NSLayoutConstraint *_handleConstraint;
    NSLayoutConstraint *_tableHeightConstraint;
    NSInteger  _totalCount;
    CGFloat    _totalPrice;
}
@property(nonatomic,strong)BadgeButton  *basktLogoBtn;
@property(nonatomic,strong)UIButton  *addBasketBtn;
@property(nonatomic,strong)UIButton  *settlementBtn;
//
@property(nonatomic,strong)UIButton  *addToBtn;
@property(nonatomic,strong)UIButton  *reduceBtn;
@property(nonatomic,strong)UILabel   *countLabel;
@property(nonatomic,strong)UIView    *handleView;
//
@property(nonatomic,strong)UILabel   *priceLabel;
@property(nonatomic,strong)UILabel   *infoLabel;
@property(nonatomic,strong)UILabel   *noneLabel;
//
@property(nonatomic,strong)UIControl  *dismissControl;
@property(nonatomic,strong)PresentBasketList *tableList;
//
@property(nonatomic,weak)id<BottomBasketViewDelegate> delegate;
@property(nonatomic,assign)BasketAddType  basketAddType;
/**
 购物车数据源
 */
@property(nonatomic,strong)NSMutableArray *dataSource;
@end
@implementation BottomBasketView
+(instancetype)shareViewWithDelegate:(id)delegate byType:(BasketAddType)basketAddType{
    CGFloat navH = IPHONE_X ? 88 : 64;
    CGFloat y = [UIScreen mainScreen].bounds.size.height - 50 - IPHONE_HOME_INDICATOR_HEIGHT-navH;
    
    BottomBasketView *basketView = [[BottomBasketView alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 50)];
    basketView.basketAddType = basketAddType;
    basketView.delegate = delegate;
    return basketView;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.Id = @"Id";
        self.currentPrice = @"currentPrice";
        self.count = @"count";
    }
    return self;
}

-(void)setBasketAddType:(BasketAddType)basketAddType{
    _basketAddType = basketAddType;
    [self buildLayout];
}

-(void)addObject:(id)anObject{
    if (anObject) {
        [self mergeShopping:anObject type:HandleTypeAdd];
        [self changeWidgetStatus];
    }
}
-(void)reduceObject:(id)anObject{
    if (anObject) {
        [self mergeShopping:anObject type:HandleTypeReduce];
        [self changeWidgetStatus];
    }
}

-(void)buildLayout{
    [self buildLeftLayout];
    
    [self buildRightLayout];
}

-(void)buildLeftLayout{
    //购物车logo🚗
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[basktLogoBtn(50)]" options:0 metrics:@{} views:@{@"basktLogoBtn":self.basktLogoBtn}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[basktLogoBtn]-5-|" options:0 metrics:@{} views:@{@"basktLogoBtn":self.basktLogoBtn}]];
    //购物车为空的提示
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[basktLogoBtn]-5-[noneLabel]" options:0 metrics:@{} views:@{@"basktLogoBtn":self.basktLogoBtn,@"noneLabel":self.noneLabel}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.noneLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    //价格、说明
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[basktLogoBtn]-10-[priceLabel]" options:0 metrics:@{} views:@{@"basktLogoBtn":self.basktLogoBtn,@"priceLabel":self.priceLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[basktLogoBtn]-10-[infoLabel]" options:0 metrics:@{} views:@{@"basktLogoBtn":self.basktLogoBtn,@"infoLabel":self.infoLabel}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[priceLabel][infoLabel(==priceLabel)]|" options:0 metrics:@{} views:@{@"priceLabel":self.priceLabel,@"infoLabel":self.infoLabel}]];
    
}
-(void)buildRightLayout{
    CGFloat settlementWith = 0;
    CGFloat addBasketWith = 0;
    if (_basketAddType == BasketAddTypeSingle) {
        settlementWith = 60;
        addBasketWith = 90;
    }else if (_basketAddType == BasketAddTypeMultiple){
        settlementWith = 90;
        addBasketWith = 0;
    }else{
        
    }
    
    //结算
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[settlementBtn(with)]-0-|" options:0 metrics:@{@"with":@(settlementWith)} views:@{@"settlementBtn":self.settlementBtn}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[settlementBtn]|" options:0 metrics:@{} views:@{@"settlementBtn":self.settlementBtn}]];
    
    //单品改变数量的视图
    NSArray *handleLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[handleView(with)]-10-[settlementBtn]" options:0 metrics:@{@"with":@(0)} views:@{@"settlementBtn":self.settlementBtn,@"handleView":self.handleView}];
    _handleConstraint = [self constraintLayout:handleLayoutArray layoutAttribute:NSLayoutAttributeWidth];
    [self addConstraints:handleLayoutArray];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[handleView]|" options:0 metrics:@{} views:@{@"handleView":self.handleView}]];
    
    //加入购物车
    NSArray *catLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[addBasketBtn(with)][settlementBtn]" options:0 metrics:@{@"with":@(addBasketWith)} views:@{@"settlementBtn":self.settlementBtn,@"addBasketBtn":self.addBasketBtn}];
    _catConstraint = [self constraintLayout:catLayoutArray layoutAttribute:NSLayoutAttributeWidth];
    [self addConstraints:catLayoutArray];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[addBasketBtn]|" options:0 metrics:@{} views:@{@"addBasketBtn":self.addBasketBtn}]];
}

#pragma mark --TCMGoodsToBasketProtocol
- (void)addProducts:(UIView *)goodsView goodsInfo:(id)goodsInfo completion:(void (^)(BOOL flag))finished{
    [self addObject:goodsInfo];
    
}
#pragma mark -- PresentBasketListDelegate
- (void)presentBasketList:(PresentBasketList *)view handleType:(HandleType)handleType{
    //服务器交互删除所有数据
    [self.dataSource removeAllObjects];
    _totalCount = [self shopTotalCount];
    _totalPrice = [self shopTotalPrice];
    
    [self changeWidgetStatus];
    [self animatedOut];
}

#pragma mark -- Action
//加入购物车
-(void)addBasktAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(bottomBasketView:handleType:)]) {
       id obj = [self.delegate bottomBasketView:self handleType:HandleTypeAdd];
        if (obj) {
            [self addObject:obj];
        }
        
    }
    
}
//从购物车减去
-(void)reduceBasktAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(bottomBasketView:handleType:)]) {
        id obj =[self.delegate bottomBasketView:self handleType:HandleTypeReduce];
        if (obj) {
            [self reduceObject:obj];
        }
        
    }
    
}
//展示购物车商品
-(void)basktLogoAction:(UIButton*)sender{
   
    if (sender.selected) {
        [self animatedOut];
    }else{
        if ([self.delegate respondsToSelector:@selector(bottomBasketView:transferType:)]) {
            [self.delegate bottomBasketView:self transferType:TransferTypePresent];
        }
        
        [self animatedIn];
    }
    
}
//去结算
-(void)settlementClickAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(bottomBasketView:transferType:)]) {
        [self.delegate bottomBasketView:self transferType:TransferTypePush];
    }
}
//隐藏蒙蔽层
-(void)touchForDismissSelf:(id)sender{
    [self animatedOut];
}
#pragma mark -- Private method

-(void)changeWidgetStatus{
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",_totalCount];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_totalPrice];
    if (_totalCount>0) {
        [self.basktLogoBtn setBadge:[NSString stringWithFormat:@"%ld",_totalCount]];
    }else{
       [self.basktLogoBtn setBadge:nil];
    }
    
    if (self.dataSource.count>0) {
        //改变logo状态
        self.basktLogoBtn.enabled = YES;
        [_basktLogoBtn setImage:@"home_basket@2x"];
        //改变结算状态
        self.settlementBtn.enabled = YES;
        self.settlementBtn.backgroundColor = [UIColor redColor];
        //改变信息状态
        self.noneLabel.hidden = YES;
        self.priceLabel.hidden = NO;
        self.infoLabel.hidden = NO;
    }else{
        self.basktLogoBtn.enabled = NO;
        [_basktLogoBtn setImage:@"home_basket_on@2x"];
        _settlementBtn.backgroundColor = RGB(220, 220, 220);
        _settlementBtn.enabled = NO;
        
        self.noneLabel.hidden = NO;
        self.priceLabel.hidden = YES;
        self.infoLabel.hidden = YES;
    }
    
    //单品
    if (_basketAddType == BasketAddTypeSingle){
        
        if (self.dataSource.count > 0) {
            
            if (_catConstraint.constant != 0) {
                _settlementBtn.backgroundColor = RGB(220, 220, 220);
            }
            _catConstraint.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                _handleConstraint.constant = 100;
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.settlementBtn.backgroundColor = [UIColor redColor];
            }];
        }else{
            _handleConstraint.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                _catConstraint.constant = 90;
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }
}
//同一个商品的合并
-(void)mergeShopping:(id)ojc type:(HandleType)addOrReduce{
    
    for (id subObj in self.dataSource) {
        if ([subObj valueForKey:self.Id] == [ojc valueForKey:self.Id]) {
            NSInteger counts = [[subObj valueForKey:self.count] integerValue];
            if (addOrReduce == HandleTypeAdd) {
                counts = counts+1;
                ojc = nil;
            }else if (addOrReduce == HandleTypeReduce && counts > 0){
                counts = counts-1;
                ojc = nil;
            }
            [subObj setValue:[NSString stringWithFormat:@"%ld",counts] forKey:self.count];
            
            if (counts <= 0) {
                [self.dataSource removeObject:subObj];
            }
            
            break;
        }
    }
    
    if (ojc && addOrReduce == HandleTypeAdd) {
        NSInteger counts = [[ojc valueForKey:self.count] integerValue];
        if (counts < 1) {
            [ojc setValue:[NSString stringWithFormat:@"1"] forKey:self.count];
        }
        [self.dataSource addObject:ojc];
    }
    
    _totalCount = [self shopTotalCount];
    _totalPrice = [self shopTotalPrice];
    
}

-(NSInteger)shopTotalCount{
    NSInteger totalCounts = 0;
    for (id subObj in self.dataSource) {
        NSInteger counts = [[subObj valueForKey:self.count] integerValue];
        totalCounts += counts;
    }
    
    return totalCounts;
}

-(CGFloat)shopTotalPrice{
    CGFloat shopTotalPrice = 0;
    NSDecimalNumber *totalPriceNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (id subObj in self.dataSource) {
        NSDecimalNumber *priceNumber = [NSDecimalNumber decimalNumberWithString:[subObj valueForKey:self.currentPrice]];
        NSDecimalNumber *countNumber = [NSDecimalNumber decimalNumberWithString:[subObj valueForKey:self.count]];
        
        NSDecimalNumber *singleShopTotalPrice = [priceNumber decimalNumberByMultiplyingBy:countNumber];
       totalPriceNumber = [totalPriceNumber decimalNumberByAdding:singleShopTotalPrice];
        
    }
    shopTotalPrice = totalPriceNumber.doubleValue;
    return shopTotalPrice;
}

-(NSLayoutConstraint*)constraintLayout:(NSArray<NSLayoutConstraint*>*)layouts layoutAttribute:(NSLayoutAttribute)attribute{
    NSLayoutConstraint *layoutConstraint;
    for (NSLayoutConstraint *constraint in layouts) {
        if (constraint.firstAttribute == attribute) {
            layoutConstraint = constraint;
        }else if (constraint.secondAttribute == attribute){
            layoutConstraint = constraint;
        }
    }
    return layoutConstraint;
}
- (void)animatedIn{
    UIViewController *vc = (UIViewController*)self.delegate;
    
    if (vc.navigationController) {
        vc.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.dismissControl.bounds = [UIScreen mainScreen].bounds;
        self.dismissControl.mj_x = 0;
        self.dismissControl.mj_y = -self.mj_h;
        [vc.navigationController.view addSubview:self.dismissControl];
        
        self.tableList.dataSource = self.dataSource;
        [self.dismissControl addSubview:self.tableList];
        [self.dismissControl addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableList]|" options:0 metrics:@{} views:@{@"tableList":self.tableList}]];
        NSArray *tableLayoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableList(height)]|" options:0 metrics:@{@"height":@0} views:@{@"tableList":self.tableList}];
        _tableHeightConstraint = [self constraintLayout:tableLayoutArray layoutAttribute:NSLayoutAttributeHeight];
        [self.dismissControl addConstraints:tableLayoutArray];
        [self.dismissControl layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.basktLogoBtn.selected = !self.basktLogoBtn.selected;
            
            _tableHeightConstraint.constant = _tableList.tableH;
            [self.dismissControl layoutIfNeeded];
        }];
    }
}
//隐藏购物车列表
- (void)animatedOut {
    [UIView animateWithDuration:.3 animations:^{
        _tableHeightConstraint.constant = 0;
        [self.dismissControl layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.basktLogoBtn.selected = !self.basktLogoBtn.selected;
            UIViewController *vc = (UIViewController*)self.delegate;
            if (vc.navigationController) {
                vc.navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
            [_tableList removeFromSuperview];
            if (_dismissControl){
                [_dismissControl removeFromSuperview];
            }
        }
    }];
}

#pragma mark -- getter
-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(BadgeButton*)basktLogoBtn{
    if (!_basktLogoBtn) {
        _basktLogoBtn = [BadgeButton new];
        _basktLogoBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _basktLogoBtn.enabled = NO;
        _basktLogoBtn.isAnimation = YES;
        [_basktLogoBtn setImage:@"home_basket_on@2x"];
        [_basktLogoBtn addTarget:self action:@selector(basktLogoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_basktLogoBtn];
    }
    return _basktLogoBtn;
}
-(UIButton*)addBasketBtn{
    if (!_addBasketBtn) {
        _addBasketBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBasketBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _addBasketBtn.backgroundColor = [UIColor redColor];
        [_addBasketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBasketBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addBasketBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addBasketBtn addTarget:self action:@selector(addBasktAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addBasketBtn];
    }
    return _addBasketBtn;
}
-(UIButton*)settlementBtn{
    if (!_settlementBtn) {
        _settlementBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _settlementBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _settlementBtn.backgroundColor = RGB(220, 220, 220);
        _settlementBtn.enabled = NO;
        [_settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _settlementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_settlementBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_settlementBtn addTarget:self action:@selector(settlementClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_settlementBtn];
    }
    return _settlementBtn;
}

-(UIView*)handleView{
    if (!_handleView) {
        _handleView = [UIView new];
        _handleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_handleView];
        
        [_handleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[reduceBtn][countLabel][addToBtn]|" options:0 metrics:@{} views:@{@"reduceBtn":self.reduceBtn,@"countLabel":self.countLabel,@"addToBtn":self.addToBtn}]];
        [_handleView addConstraint:[NSLayoutConstraint constraintWithItem:self.reduceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_handleView attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
        [_handleView addConstraint:[NSLayoutConstraint constraintWithItem:self.addToBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_handleView attribute:NSLayoutAttributeWidth multiplier:0.3 constant:0]];
        [_handleView addConstraint:[NSLayoutConstraint constraintWithItem:self.countLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_handleView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [_handleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[reduceBtn]|" options:0 metrics:@{} views:@{@"reduceBtn":self.reduceBtn}]];
        [_handleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[countLabel]|" options:0 metrics:@{} views:@{@"countLabel":self.countLabel}]];
        [_handleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[addToBtn]|" options:0 metrics:@{} views:@{@"addToBtn":self.addToBtn}]];
    }
    return _handleView;
}

-(UIButton*)addToBtn{
    if (!_addToBtn) {
        _addToBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addToBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_addToBtn setImage:[UIImage imageNamed:@"store_da"] forState:UIControlStateNormal];
        [_addToBtn addTarget:self action:@selector(addBasktAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.handleView addSubview:_addToBtn];
    }
    return _addToBtn;
}

-(UIButton*)reduceBtn{
    if (!_reduceBtn) {
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduceBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_reduceBtn setImage:[UIImage imageNamed:@"store_huijia"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceBasktAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.handleView addSubview:_reduceBtn];
    }
    return _reduceBtn;
}
-(UILabel*)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.text = @"1";
        [self.handleView addSubview:_countLabel];
    }
    return _countLabel;
}
-(UILabel*)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _priceLabel.hidden = YES;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.text = @"¥10.00";
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}
-(UILabel*)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _infoLabel.hidden = YES;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [UIColor orangeColor];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.text = @"配送费3元、免配送费";
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}
-(UILabel*)noneLabel{
    if (!_noneLabel) {
        _noneLabel = [UILabel new];
        _noneLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noneLabel.textAlignment = NSTextAlignmentCenter;
        _noneLabel.textColor = [UIColor lightGrayColor];
        _noneLabel.font = [UIFont systemFontOfSize:12];
        _noneLabel.text = @"购物车是空的";
        [self addSubview:_noneLabel];
    }
    return _noneLabel;
}

-(PresentBasketList*)tableList{
    if (!_tableList) {
        _tableList = [PresentBasketList new];
        _tableList.translatesAutoresizingMaskIntoConstraints = NO;
        _tableList.deleagte = self;
    }
    return _tableList;
}

-(UIControl*)dismissControl{
    if (!_dismissControl) {
        _dismissControl = [[UIControl alloc]init];
        _dismissControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _dismissControl.clipsToBounds = YES;
        [_dismissControl addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissControl;
}

@end
