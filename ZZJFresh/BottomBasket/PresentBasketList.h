//
//  PresentBasketList.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/23.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PresentBasketList : UIView

/**
 展示数据
 */
@property(nonatomic,strong,nonnull)NSMutableArray  *dataSource;

/**
 模态视图的高度
 */
@property(nonatomic,readonly)CGFloat  tableH;
@end
NS_ASSUME_NONNULL_END
