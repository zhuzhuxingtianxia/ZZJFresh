//
//  PresentBasketList.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "PresentBasketList.h"
#import "TCMFreshCell.h"
@interface PresentBasketList ()<UITableViewDataSource,UITableViewDelegate,TCMGoodsToBasketProtocol>
@property(nonatomic,strong)UIView  *topView;
@property(nonatomic,strong)UIButton  *clearBtn;
@property(nonatomic,strong)UITableView  *tableList;
@property(nonatomic,assign)CGFloat  tableH;
@end
@implementation PresentBasketList

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [_topView addSubview:self.clearBtn];
        [self addSubview:self.tableList];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0, 0, self.mj_w, 40);
    self.clearBtn.frame = CGRectMake(CGRectGetWidth(self.topView.frame) - 100, 0, 80, 40);
    CGFloat totalCellH = self.dataSource.count*self.tableList.rowHeight;
     CGFloat tableH = totalCellH > [UIScreen mainScreen].bounds.size.height*0.55 ? [UIScreen mainScreen].bounds.size.height*0.55:totalCellH;
    
    self.tableList.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.mj_w, tableH);
    
    self.mj_h = CGRectGetMaxY(self.tableList.frame);
    
    self.tableH = self.mj_h;
    
}

-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self.tableList reloadData];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[TCMFreshModel class]]){
        cell = [tableView dequeueReusableCellWithIdentifier:((TCMFreshModel*)model).cellIdentifier];
        ((TCMFreshCell*)cell).model = model;
        ((TCMFreshCell*)cell).deleagte = self;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
#pragma mark -- TCMGoodsToBasketProtocol
- (void)addProducts:(UIView *)goodsView goodsInfo:(id)goodsInfo completion:(void (^)(BOOL flag))finished{
    if (finished) {
        finished(YES);
        if ([self.deleagte respondsToSelector:@selector(addProducts:goodsInfo:completion:)]) {
            [self.deleagte addProducts:self goodsInfo:goodsInfo completion:^(BOOL flag) {
                
            }];
        }
    }
}
#pragma mark --Action
-(void)clearShopCatAction:(id)sender{
    if ([self.deleagte respondsToSelector:@selector(presentBasketList:handleType:)]) {
        [self.deleagte presentBasketList:self handleType:HandleTypeClearn];
    }
}

#pragma mark -- getter
-(UITableView*)tableList{
    if (!_tableList) {

        CGFloat height =  self.bounds.size.height - 50;
        
        _tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height) style:UITableViewStylePlain];
        _tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableList.dataSource = self;
        _tableList.delegate = self;
        _tableList.rowHeight = 85;
        [_tableList registerNib:[UINib nibWithNibName:@"TCMFreshCell" bundle:nil] forCellReuseIdentifier:@"TCMFreshCell"];
    }
    return _tableList;
}

-(UIView*)topView{
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _topView;
}

-(UIButton*)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setTitle:@"清空购物车" forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_clearBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearShopCatAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

@end
