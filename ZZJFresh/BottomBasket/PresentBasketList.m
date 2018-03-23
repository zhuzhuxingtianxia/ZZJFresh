//
//  PresentBasketList.m
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import "PresentBasketList.h"
#import "TCMFreshCell.h"
@interface PresentBasketList ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView  *topView;
@property(nonatomic,strong)UITableView  *tableList;
@property(nonatomic,assign)CGFloat  tableH;
@end
@implementation PresentBasketList

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.tableList];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0, 0, self.mj_w, 40);
    self.tableList.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), self.mj_w, self.dataSource.count*self.tableList.rowHeight);
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
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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
        _topView.backgroundColor = [UIColor orangeColor];
    }
    return _topView;
}

@end
