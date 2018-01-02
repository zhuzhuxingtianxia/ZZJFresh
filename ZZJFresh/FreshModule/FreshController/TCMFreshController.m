//
//  TCMFreshController.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMFreshController.h"

// View
#import "TCMFreshCell.h"
#import "TCMFreshSectionCell.h"
#import "TCMSectionScrollView.h"

//NetWork
#import "TCMNetWork.h"

#import "TCMGoodsToBasketProtocol.h"
#import "UIView+TCMBasketAnimation.h"
#import "UIView+TCMEdgeSlide.h"
#import "UIView+TCMBorderSide.h"

@interface TCMFreshController ()<UITableViewDelegate,UITableViewDataSource,TCMGoodsToBasketProtocol,TCMSectionScrollViewDelegate>

@property(weak, nonatomic) IBOutlet  UIButton  *moveTopButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIView    *headerView;
/// 悬浮bar
@property (weak, nonatomic) IBOutlet TCMSectionScrollView *headerBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barContraont;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 保存数据容器
@property(nonatomic,strong)NSMutableArray *dataArray;
// 滑动区头标记容器
@property(nonatomic,strong)NSMutableArray *titlesArray;

@end

@implementation TCMFreshController
#pragma mark  lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    [self loadNetWorkData];
}

-(void)buildView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"home_basket"] forState:UIControlStateNormal];
    //[button addTarget:self action:@selector(gotoShoppingCartPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.moveTopButton edgeSliseWithSupView:self.view];
    
    //设置bar的位置
    self.barContraont.constant = TCM_StdLayout(126);
    _headerBar.delegate = self;
    [_headerBar borderForColor:Color_Line_NO_3 borderWidth:0.5 borderType:TCMBorderSideTypeTop];
    _headerBar.hidden = YES;
    
    self.headerView.hidden = YES;
    self.headerView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, TCM_StdLayout(126) + TCM_StdLayout(45.0));
}

-(void)loadNetWorkData{
    [TCMNetWork sendAsyncPostHTTPRequestTo:@"activity_status_goods_2.json" withToken:@"" withFormTag:@"" formContent:@{} completionHandler:^(id objc, NSError *connectionError) {
        if ([objc isKindOfClass:[NSArray class]]) {
            
            self.headerView.hidden = NO;
            
            NSInteger index = 0;
            for (id subObj in (NSArray *)objc) {
                if ([subObj isKindOfClass:[NSDictionary class]]) {
                    TCMFreshActivityModel *activtyModel = [TCMFreshActivityModel new];
                    activtyModel.classify = subObj[@"classify"];
                    activtyModel.startIndex = index;
                    [self.titlesArray addObject:activtyModel];
                    
                    NSArray *marketArray = subObj[@"objsList"];
                    if (marketArray.count == 1) {
                        id dict = marketArray.firstObject;
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            TCMFreshMarketModel *marketModel = [TCMFreshMarketModel mj_objectWithKeyValues:dict];
                            
                            [self.dataArray addObject:marketModel];
                            
                        }
                    }
                    
                }
            }
             _headerBar.hidden = NO;
            _headerBar.sourceArray = self.titlesArray;
            [self.tableView reloadData];
        }
        
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TCMFreshMarketModel *marketModel = self.dataArray[section];
    TCMFreshSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMFreshSectionCell"];
    cell.model = marketModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TCM_StdLayout(45.0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TCMFreshMarketModel *marketModel = self.dataArray[section];
    return marketModel.goods.count;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TCMFreshMarketModel *marketModel = self.dataArray[indexPath.section];
    TCMFreshModel  *freshModel = marketModel.goods[indexPath.row];
    TCMFreshCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMFreshCell" forIndexPath:indexPath];
    cell.deleagte = self;
    cell.model = freshModel;
    return cell;
    
}

#pragma mark TCMSectionScrollViewDelegate
- (void)sectionScrollView:(TCMSectionScrollView *)view didSelectIndex:(NSIndexPath *)indexPath{
    
    CGFloat cellH = 0;
    for (NSInteger j = 0; j < indexPath.section; j++) {
        TCMFreshMarketModel *marketModel = self.dataArray[j];
        cellH += marketModel.goods.count * 85;
    }
    
    CGFloat sectionH = indexPath.section * TCM_StdLayout(45.0);
    
    [self.tableView setContentOffset:CGPointMake(0, cellH + sectionH + TCM_StdLayout(126)) animated:YES];
    
    // [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark Action
-(IBAction)moveTableToTop:(UIButton*)sender{
    _headerBar.selectIndex = 0;
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
}

#pragma mark TCMGoodsToBasketProtocol
- (void)addProducts:(UIView *)goodsView goodsInfo:(id)goodsInfo{
    NSLog(@"TCMGoodsToBasketProtocol");
    [goodsView addProductsToShopCarAnimation:self.navigationItem.rightBarButtonItem.customView];
}

#pragma  mark  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        if (_tableView.contentOffset.y >= TCM_StdLayout(126)) {
            self.barContraont.constant = 0;
        } else {
            self.barContraont.constant = TCM_StdLayout(126) - _tableView.contentOffset.y;
        }
        
        if (scrollView.contentOffset.y > TCM_StdLayout(126)) {
            self.moveTopButton.hidden = NO;
        }else{
            self.moveTopButton.hidden = YES;
        }
        
        if (scrollView.isDragging || scrollView.isDecelerating){
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + TCM_StdLayout(45.0))];
            
            if (indexPath.section != _headerBar.selectIndex) {
                _headerBar.selectIndex = indexPath.section;
                
            }
            
        }
        
    }
}

#pragma mark getter
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"安全释放");
}

@end
