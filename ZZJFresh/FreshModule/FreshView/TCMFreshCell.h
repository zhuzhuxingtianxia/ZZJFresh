//
//  TCMFreshCell.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
// Model
#import "TCMFreshModel.h"

// TCMGoodsToBasketProtocol
#import "TCMGoodsToBasketProtocol.h"

@interface TCMFreshCell : UITableViewCell 

@property(nonatomic,strong)TCMFreshModel *model;
@property(nonatomic,weak)id <TCMGoodsToBasketProtocol> deleagte;

@end
