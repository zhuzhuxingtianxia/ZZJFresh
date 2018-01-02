//
//  TCMFreshModel.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMFreshModel.h"
#import "NSObject+TCMObjectCopy.h"

@implementation TCMFreshActivityModel

-(void)setObjsList:(NSArray<TCMFreshMarketModel *> *)objsList{
    
    _objsList = [TCMFreshMarketModel mj_objectArrayWithKeyValuesArray:objsList];
    
}

@end

//////////////////////////////////////////


@implementation TCMFreshMarketModel

-(void)setGoods:(NSArray<TCMFreshModel *> *)goods{
    
    _goods = [TCMFreshModel mj_objectArrayWithKeyValuesArray:goods];
    
}

@end

///////////////////////////////////////

@interface TCMFreshModel ()

@end

@implementation TCMFreshModel
// 实现编解码协议
MJExtensionCodingImplementation

//替换字段
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Id":@"id",
             @"userStatus":@"new_user_status"};
}

- (id)copyWithZone:(NSZone *)zone{
    
    TCMFreshModel *model = [self copyObjcet:self.class];
    return model;
}

/*
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self mj_encode:aCoder];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        [self mj_decode:aDecoder];
    }
    return self;
}
*/
@end
