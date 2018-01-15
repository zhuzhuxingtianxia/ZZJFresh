//
//  TCMNetWork.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/29.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "TCMNetWork.h"

static NSString *getJsonStringByDictionary(NSDictionary *dictionary,NSStringEncoding encoding);

@implementation TCMNetWork
//模拟请求
+(void)sendAsyncPostHTTPRequestTo:(NSString *)interface
                        withToken:(NSString *)token
                      withFormTag:(NSString *)tag
                      formContent:(NSDictionary *)contentDic
                completionHandler:(void (^)(id objc, NSError* connectionError)) handler{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:interface ofType:nil];
        if (!path) {
            NSLog(@"没有找到模拟文件");
            NSError *error = [[NSError alloc] initWithDomain:@"没有找到模拟文件" code:-1 userInfo:nil];
            handler(nil,error);
            return ;
        }
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (data && json==nil) {
            NSLog(@"Json格式错误");
            NSError *error = [[NSError alloc] initWithDomain:@"Json格式错误" code:-1 userInfo:nil];
            handler(nil,error);
            return;
        }
        if ([json[kRequestFlag] isEqualToString:kRequestFlagSuccess]) {
            handler(json[kResponseList],nil);
            
        }else{
            if (json[kRequestInfo]) {
                NSError *error = [[NSError alloc] initWithDomain:json[kRequestInfo] code:-1 userInfo:nil];
                handler(nil,error);
            }
        }
        
    });

    
}

#pragma mark -- Private
static NSString *getJsonStringByDictionary(NSDictionary *dictionary,NSStringEncoding encoding){
    if(!dictionary)return nil;
    if(!encoding)return nil;
    NSData *JSONData = getJSONDataFromObject(dictionary);
    return [[NSString alloc] initWithData:JSONData encoding:encoding];
}

static NSData *getJSONDataFromObject(id obj){
    if(!obj)return nil;
    
    if([NSJSONSerialization isValidJSONObject:obj]){
        
        NSError *error = nil;
        
        return [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        
        
    }
    
    return nil;
}



@end
