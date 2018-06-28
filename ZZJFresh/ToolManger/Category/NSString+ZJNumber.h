//
//  NSString+ZJNumber.h
//  ZZJFresh
//
//  Created by ZZJ on 2018/6/28.
//  Copyright © 2018年 Jion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZJNumber)
/*
 去除小数中末尾的0
 例如：10.00->10,
      10.10->10.1,
      0.01000->0.01,
 */
-(NSString*)deleteLastZero;
@end
