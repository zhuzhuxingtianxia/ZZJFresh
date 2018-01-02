//
//  TCMFreshNode.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, TCMFreshCellType){
    TCMFreshCellTypeSection  =  1,
    TCMFreshCellTypeFresh    =  2
};

@interface TCMFreshNode : NSObject

@property(nonatomic,assign)TCMFreshCellType  freshCellType;

@property(nonatomic,strong)id  currentModel;

@end
