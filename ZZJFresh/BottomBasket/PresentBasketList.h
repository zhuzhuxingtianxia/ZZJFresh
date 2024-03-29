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
#import "BottomBasketView.h"
NS_ASSUME_NONNULL_BEGIN
@class PresentBasketList;
@protocol PresentBasketListDelegate <TCMGoodsToBasketProtocol>
@optional
/**
 视图中加入和减去商品的操作，仅BasketAddTypeSingle类型使用
 
 @param view BottomBasketView对象
 @param handleType 操作类型
 
 */
- (void)presentBasketList:(PresentBasketList *)view handleType:(HandleType)handleType;


@end
@interface PresentBasketList : UIView

/**
 展示数据
 */
@property(nonatomic,strong,nonnull)NSMutableArray  *dataSource;

/**
 加入购物车代理
 */
@property(nonatomic,weak)id <PresentBasketListDelegate> deleagte;

/**
 模态视图的高度
 */
@property(nonatomic,readonly)CGFloat  tableH;
@end
NS_ASSUME_NONNULL_END
