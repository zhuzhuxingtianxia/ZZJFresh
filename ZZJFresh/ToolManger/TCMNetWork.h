//
//  TCMNetWork.h
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//
#define kRequestFlag         @"op_flag"
#define kRequestFlagSuccess  @"success"
#define kRequestInfo         @"info"
#define kResponseList        @"returnList"
#define kRequestModel        @"requestmodel"
#define KRequestFail         @"fail"
#define KRequestError        @"error"
#define KRequestNologin      @"noLogin"

#import <Foundation/Foundation.h>

@interface TCMNetWork : NSObject

+(void)sendAsyncPostHTTPRequestTo:(NSString *)interface
                        withToken:(NSString *)token
                      withFormTag:(NSString *)tag
                      formContent:(NSDictionary *)contentDic
                completionHandler:(void (^)(id objc, NSError* connectionError)) handler;

@end
