//
//  TCMGoodsToBasketProtocol.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/1/1.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCMGoodsToBasketProtocol <NSObject>
@required

- (void)addProducts:(UIView *)goodsView goodsInfo:(id)goodsInfo;

@end
