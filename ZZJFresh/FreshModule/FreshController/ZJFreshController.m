//
//  ZJFreshController.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/15.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "ZJFreshController.h"
// View
#import "TCMFreshCell.h"
#import "TCMFreshSectionCell.h"
#import "TCMSectionScrollView.h"
#import "TableHeaderView.h"
#import "BottomBasketView.h"
//NetWork
#import "TCMNetWork.h"

#import "TCMGoodsToBasketProtocol.h"
#import "UIView+TCMBasketAnimation.h"
#import "UIView+TCMEdgeSlide.h"
#import "UIView+TCMBorderSide.h"

@interface ZJFreshController ()<UITableViewDelegate,UITableViewDataSource,
           TCMGoodsToBasketProtocol,TCMSectionScrollViewDelegate,BottomBasketViewDelegate>
// 右下角悬浮按钮
@property(strong, nonatomic) UIButton  *moveTopButton;
/// 悬浮bar
@property (strong, nonatomic) TCMSectionScrollView *headerBar;
@property(nonatomic,strong)UITableView  *tableList;
@property(nonatomic,strong)TableHeaderView *headerView;
@property (nonatomic,strong)UIView  *footerView;
@property (nonatomic,strong)BottomBasketView *bastket;
// 保存数据容器
@property(nonatomic,strong)NSMutableArray *dataArray;
// 滑动区头标记容器
@property(nonatomic,strong)NSMutableArray *titlesArray;
@end

@implementation ZJFreshController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildView];
    
    [self loadNetWorkData];
}
-(void)buildView{
    
    self.navigationItem.rightBarButtonItem = [self getBarButtonItem];
    [self buildBottomBasket];
    [self.view addSubview:self.tableList];
    
    [self.tableList registerNib:[UINib nibWithNibName:@"TCMFreshSectionCell" bundle:nil] forCellReuseIdentifier:@"TCMFreshSectionCell"];
    [self.tableList registerNib:[UINib nibWithNibName:@"TCMFreshCell" bundle:nil] forCellReuseIdentifier:@"TCMFreshCell"];
    
    self.headerView = [[TableHeaderView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, TCM_StdLayout(126.0))];
    self.tableList.tableHeaderView = self.headerView;
    
    [self.moveTopButton edgeSliseWithSupView:self.view];
    
}

-(void)loadNetWorkData{
    [TCMNetWork sendAsyncPostHTTPRequestTo:@"activity_status_goods_2.json" withToken:nil withFormTag:nil formContent:@{} completionHandler:^(id objc, NSError *connectionError) {
        if ([objc isKindOfClass:[NSArray class]]){
            NSArray *dataArray = (NSArray *)objc;
            [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull subObj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([subObj isKindOfClass:[NSDictionary class]]){
                    TCMFreshActivityModel *activtyModel = [TCMFreshActivityModel new];
                    activtyModel.classify = subObj[@"classify"];
                    activtyModel.startIndex = self.dataArray.count;
                    activtyModel.activityIndex = idx;
                    //市场数组
                    NSArray *marketArray = subObj[@"objsList"];
                    marketArray = [TCMFreshMarketModel mj_objectArrayWithKeyValuesArray:marketArray];
                    for (NSInteger k = 0; k<marketArray.count; k++) {
                        TCMFreshMarketModel *marketModel = marketArray[k];
                        marketModel.cellIdentifier = @"TCMFreshSectionCell";
                        [self.dataArray addObject:marketModel];
                        for (NSInteger j = 0; j < marketModel.goods.count; j++) {
                            TCMFreshModel *freshModel = marketModel.goods[j];
                            freshModel.cellIdentifier = @"TCMFreshCell";
                            [self.dataArray addObject:freshModel];
                        }
                        activtyModel.endIndex = self.dataArray.count - 1;
                    }
                    
                    [self.titlesArray addObject:activtyModel];
                }
            }];
            
            if (self.titlesArray.count > 0) {
                TCMFreshActivityModel *activtyModel = self.titlesArray.lastObject;
                CGFloat cellCout = (self.tableList.bounds.size.height - 2 * TCM_StdLayout(45.0))/85.0;
                NSInteger count = activtyModel.endIndex - activtyModel.startIndex;
                if (count < cellCout) {
                    CGFloat footerH = (cellCout - count) * 85 + 5;
                    self.footerView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, footerH);
                    self.tableList.tableFooterView = self.footerView;
                }
            }
            
            [self.tableList reloadData];
        }
        
    }];
}

#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count > 0 && section == 0) {
        if (!_headerBar) {
            _headerBar = [[TCMSectionScrollView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, 45)];
            _headerBar.delegate = self;
        }
        self.headerBar.sourceArray = self.titlesArray;
        return self.headerBar;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count > 0 && section == 0) {
        return TCM_StdLayout(45.0);
    }else{
        return CGFLOAT_MIN;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     id model = self.dataArray[indexPath.row];
     if ([model isKindOfClass:[TCMFreshMarketModel class]]) {
         return 45;
     }else{
        return 85;
     }
     
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[TCMFreshMarketModel class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:((TCMFreshMarketModel*)model).cellIdentifier];
        ((TCMFreshSectionCell*)cell).model = model;
    }else if ([model isKindOfClass:[TCMFreshModel class]]){
        cell = [tableView dequeueReusableCellWithIdentifier:((TCMFreshModel*)model).cellIdentifier];
        ((TCMFreshCell*)cell).deleagte = self;
        ((TCMFreshCell*)cell).model = model;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    if ([model isKindOfClass:[TCMFreshModel class]]) {
        TCMFreshModel *freshModel = (TCMFreshModel*)model;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:freshModel.goods_name message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
#pragma mark -- BottomBasketViewDelegate
- (id)bottomBasketView:(BottomBasketView *)view handleType:(HandleType)handleType{
    id model = self.dataArray.firstObject;
    if ([model isKindOfClass:[TCMFreshMarketModel class]]) {
        model = ((TCMFreshMarketModel*)model).goods.firstObject;
    }
    return model;
}

- (void)bottomBasketView:(BottomBasketView *)view transferType:(TransferType)transferType{
    
}

#pragma  mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableList) {
        
        if (scrollView.contentOffset.y > TCM_StdLayout(126)) {
            self.moveTopButton.hidden = NO;
        }else{
            self.moveTopButton.hidden = YES;
        }
        
        if (scrollView.isDragging || scrollView.isDecelerating){
            NSIndexPath *indexPath = [self.tableList indexPathForRowAtPoint: CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + TCM_StdLayout(45.0))];
            if (indexPath) {
                for (TCMFreshActivityModel *activityModel in self.titlesArray) {
                    
                    if (indexPath.row >= activityModel.startIndex && indexPath.row <= activityModel.endIndex) {
                        _headerBar.selectIndex = activityModel.activityIndex;
                        break;
                    }
                }
            }
            
        }
        
    }
}

#pragma mark TCMSectionScrollViewDelegate
- (void)sectionScrollView:(TCMSectionScrollView *)view didSelectIndex:(NSIndexPath *)indexPath{
    TCMFreshActivityModel *activityModel = self.titlesArray[indexPath.section];
    CGFloat cellH = 0;
    for (NSInteger k = 0; k < activityModel.startIndex; k++) {
        id model = self.dataArray[k];
        UITableViewCell *cell;
        if ([model isKindOfClass:[TCMFreshMarketModel class]]) {
            cell = [self.tableList dequeueReusableCellWithIdentifier:((TCMFreshMarketModel*)model).cellIdentifier];
        }else if ([model isKindOfClass:[TCMFreshModel class]]){
            cell = [self.tableList dequeueReusableCellWithIdentifier:((TCMFreshModel*)model).cellIdentifier];
        }
        cellH += cell.bounds.size.height;
       
    }
    
    [self.tableList setContentOffset:CGPointMake(0, cellH + TCM_StdLayout(126)) animated:YES];
    
}
#pragma mark -- TCMGoodsToBasketProtocol
- (void)addProducts:(UIView *)goodsView goodsInfo:(id)goodsInfo completion:(void (^)(BOOL))finished{
    NSLog(@"TCMGoodsToBasketProtocol");
    /*
    [goodsView addProductsToShopCarAnimation:self.navigationItem.rightBarButtonItem.customView cartAnimation:YES completion:^(BOOL flag) {
        if (finished) {
            finished(flag);
        }
    }];
    */
    [goodsView addProductsToShopCarAnimation:(UIView*)_bastket.basktLogoBtn completion:^(BOOL flag) {
        if (finished) {
            [_bastket addObject:goodsInfo];
            finished(flag);
        }
    }];
    
}

#pragma mark -- Action
-(void)moveTableToTop:(UIButton*)sender{
    _headerBar.selectIndex = 0;
    [self.tableList setContentOffset:CGPointZero animated:YES];
}

#pragma mark -- getter
-(UIButton*)moveTopButton{
    if (!_moveTopButton) {
        _moveTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"home_dig"];
        [_moveTopButton setImage:image forState:UIControlStateNormal];
        CGFloat bottomH = IPHONE_X ? 34 : 0;
        CGFloat navH = IPHONE_X ? 88 : 64;
        CGFloat height = self.tabBarController.tabBar ? IPHONE_SCREEN_HEIGHT - image.size.height - 50 - self.tabBarController.tabBar.bounds.size.height - bottomH - navH: IPHONE_SCREEN_HEIGHT - image.size.height - 50 - navH - bottomH;
        
        _moveTopButton.frame = CGRectMake(IPHONE_SCREEN_WIDTH - image.size.width - 10, height, image.size.width, image.size.height);
        [_moveTopButton addTarget:self action:@selector(moveTableToTop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moveTopButton;
}

-(UIBarButtonItem*)getBarButtonItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"home_basket"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(gotoShoppingCartPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}
-(void)buildBottomBasket{
    _bastket = [BottomBasketView shareViewWithDelegate:self byType:BasketAddTypeSingle];
    
//    _bastket = [BottomBasketView shareViewWithDelegate:self byType:BasketAddTypeMultiple];
    _bastket.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _bastket.currentPrice = @"discount_price";
    [self.view addSubview:_bastket];
}
-(UITableView*)tableList{
    if (!_tableList) {
        
        CGFloat navH = IPHONE_X ? 88 : 64;
        CGFloat height = self.view.bounds.size.height - navH -IPHONE_HOME_INDICATOR_HEIGHT - 50;
        
        _tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height) style:UITableViewStylePlain];
        _tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableList.dataSource = self;
        _tableList.delegate = self;
    }
    return _tableList;
}
-(NSMutableArray *)titlesArray{
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UIView*)footerView{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
