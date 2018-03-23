//
//  BottomBasketView.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/3/22.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TransferType) {
    TransferTypePush,//push跳转
    TransferTypePresent,//模态弹出
};
typedef NS_ENUM(NSUInteger, HandleType) {
    HandleTypeUnkown,
    HandleTypeAdd,//单个添加
    HandleTypeReduce,//单个减去
    HandleTypeClearn,//全部清空
};
typedef NS_ENUM(NSUInteger, BasketAddType) {
    BasketAddTypeUnkown,//不知道的类型
    BasketAddTypeSingle,//单个类型，详情里面添加
    BasketAddTypeMultiple,//多种，从列表添加
};

NS_ASSUME_NONNULL_BEGIN

@class BottomBasketView,BadgeButton;
@protocol BottomBasketViewDelegate <NSObject>

/**
 视图中加入和减去商品的操作，仅BasketAddTypeSingle类型使用

 @param view BottomBasketView对象
 @param handleType 操作类型
 @return 返回要操作的对象
 */
- (id)bottomBasketView:(BottomBasketView *)view handleType:(HandleType)handleType;

- (void)bottomBasketView:(BottomBasketView *)view transferType:(TransferType)transferType;

@end

@interface BottomBasketView : UIView

/**
 构建底部购物车

 @param delegate 设置代理
 @param basketAddType 购物车类型：BasketAddTypeSingle商品详情加入购物车，
                                BasketAddTypeSingle商品列表加入购物车
 @return 返回一个底部视图
 */
+(instancetype)shareViewWithDelegate:(id)delegate byType:(BasketAddType)basketAddType;

/**
 添加对象到购物车

 @param anObject 要添加的对象
 */
-(void)addObject:(id)anObject;
/**
 购物车图标
 */
@property(nonatomic,readonly)BadgeButton  *basktLogoBtn;

@end
NS_ASSUME_NONNULL_END

