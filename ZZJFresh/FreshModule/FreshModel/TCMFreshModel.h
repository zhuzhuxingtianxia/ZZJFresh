//
//  TCMFreshModel.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@class TCMFreshModel;
@class TCMFreshMarketModel;

@interface TCMFreshActivityModel: NSObject
/** 活动名称 */
@property(nonatomic,copy)NSString *classify;
/** 初始索引 */
@property(nonatomic,assign)NSInteger startIndex;

/** 市场容器 */
@property(nonatomic,strong)NSArray<TCMFreshMarketModel *> *objsList;

@end

@interface TCMFreshMarketModel: NSObject
/** 市场ID */
@property(nonatomic,copy)NSString *market_id;
/** 市场名称 */
@property(nonatomic,copy)NSString *market_name;

/** 市场店铺商品集合 */
@property(nonatomic,strong)NSArray<TCMFreshModel *> *goods;

@end

/********************************/

@interface TCMFreshModel : NSObject <NSCopying,NSCoding>
/** 市场model */
@property(nonatomic,weak)TCMFreshMarketModel *marketModel;

/** 商品名称 */
@property(nonatomic,copy)NSString *goods_name;
/** 商品id */
@property(nonatomic,copy)NSString *Id;
/**用户状态 0 */
@property(nonatomic,copy)NSString *userStatus;
/** 单位 */
@property(nonatomic,copy)NSString *standard_description;
/** 店铺名字 */
@property(nonatomic,copy)NSString *store_name;
/** 店铺id */
@property(nonatomic,copy)NSString *store_id;

/** 商品库存 */
@property(nonatomic,copy)NSString *goods_inventory;
/** 商品默认价格 */
@property(nonatomic,copy)NSString *goods_original_price;
/** 交易状态 0 */
@property(nonatomic,copy)NSString *bargain_status;
/** 限制数量 */
@property(nonatomic,copy)NSString *restriction_count;
/** 折扣价 */
@property(nonatomic,copy)NSString *discount_price;
/** 商品图片资源url */
@property(nonatomic,copy)NSString *img;
/** 商品库存类型 2 */
@property(nonatomic,copy)NSString *goods_inventory_type;
/** 是否超出业务范围 false没超出 true超出 */
@property(nonatomic,assign)BOOL outBusiness;
/** 商品当前价格 */
@property(nonatomic,copy)NSString *goods_current_price;
/** 商品销量 */
@property(nonatomic,copy)NSString *goods_salenum;

/** 特殊状态 */
@property(nonatomic,copy)NSString *special_status;


@end
