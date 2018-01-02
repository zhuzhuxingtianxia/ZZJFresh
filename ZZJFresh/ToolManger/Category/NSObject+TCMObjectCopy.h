//
//  NSObject+TCMObjectCopy.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TCMObjectCopy)

/**
 对象copy ，首先需要实现<NSCopying>协议

 @param aClass 要copy的类
 @return copy好的类的实例对象
 */
-(instancetype)copyObjcet:(Class)aClass;

@end
