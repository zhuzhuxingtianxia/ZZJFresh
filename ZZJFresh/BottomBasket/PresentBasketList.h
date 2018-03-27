//
//  PresentBasketList.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
// TCMGoodsToBasketProtocol
#import "TCMGoodsToBasketProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface PresentBasketList : UIView<TCMGoodsToBasketProtocol>

/**
 展示数据
 */
@property(nonatomic,strong,nonnull)NSMutableArray  *dataSource;

/**
 加入购物车代理
 */
@property(nonatomic,weak)id <TCMGoodsToBasketProtocol> deleagte;

/**
 模态视图的高度
 */
@property(nonatomic,readonly)CGFloat  tableH;
@end
NS_ASSUME_NONNULL_END
