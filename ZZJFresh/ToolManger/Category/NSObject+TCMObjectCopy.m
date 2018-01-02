//
//  NSObject+TCMObjectCopy.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "NSObject+TCMObjectCopy.h"
#import <objc/runtime.h>

@implementation NSObject (TCMObjectCopy)

-(instancetype)copyObjcet:(Class)aClass{
    id obj = [[aClass alloc] init];
    
    [self tcmCopyValue:obj];
    
    return obj;
}

/**
 实现copy
 
 @param tempModel 需要做copy的对象
 */
- (void)tcmCopyValue:(id)tempModel{
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        ///取出属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        NSString  *propertyString = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:propertyString];
        
        [tempModel setValue:propertyValue forKey:propertyString];
    }
    
}


@end
