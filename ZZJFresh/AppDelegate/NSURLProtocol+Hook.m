//
//  NSURLProtocol+Hook.m
//  ZZJFresh
//
//  Created by ZZJ on 2021/11/26.
//

/*
 AppDelegate里面注册后，即可对网络请求拦截
 [NSURLProtocol wk_registerScheme:@"http"];
 [NSURLProtocol wk_registerScheme:@"https"];
 
 在WKURLProtocol重写下面方法：
 //进行过滤判断
 + (BOOL)canInitWithRequest:(NSURLRequest *)request;
 //拦截处理
 + (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;

 */

#import "NSURLProtocol+Hook.h"
#import <WebKit/WebKit.h>
#include <unistd.h>
#include <sys/sysctl.h>

static void hk_exchangedMethod(SEL originalSelector, SEL swizzledSelector, Class class) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
static void hk_exchangedClassMethod(SEL originalSelector, SEL swizzledSelector, Class class) {
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(object_getClass(class),//此处获取元类对象
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@interface NSURLProtocol (Hook)
+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end

@implementation NSURLProtocol (Hook)
+ (void)wk_registerScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}
@end



@interface NSURLSessionConfiguration (Hook)

@end

@implementation NSURLSessionConfiguration (Hook)

+ (void)initialize
{
#ifdef DEBUG
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hk_exchangedClassMethod(@selector(defaultSessionConfiguration), @selector(hk_defaultSessionConfiguration), [self class]);
    });
    
#endif
}

//第三方请求框架拦截
+ (NSURLSessionConfiguration *)hk_defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration hk_defaultSessionConfiguration];
    NSMutableArray *array = [[config protocolClasses] mutableCopy];
    [array insertObject:[HKURLProtocol class] atIndex:0];
    config.protocolClasses = array;
    return  config;
}

@end


@interface NSURLRequest (HK)

@end

@implementation NSURLRequest (HK)

- (NSURLRequest *)cyl_getPostRequestIncludeBody {
    return [[self cyl_getMutablePostRequestIncludeBody] copy];
}
- (NSMutableURLRequest *)cyl_getMutablePostRequestIncludeBody {
    NSMutableURLRequest * req = [self mutableCopy];
    if ([self.HTTPMethod isEqualToString:@"POST"]) {
        if (!self.HTTPBody) {
            NSInteger maxLength = 1024;
            uint8_t d[maxLength];
            NSInputStream *stream = self.HTTPBodyStream;
            NSMutableData *data = [[NSMutableData alloc] init];
            [stream open];
            BOOL endOfStreamReached = NO;
            //不能用 [stream hasBytesAvailable]) 判断，处理图片文件的时候这里的[stream hasBytesAvailable]会始终返回YES，导致在while里面死循环。
            while (!endOfStreamReached) {
                NSInteger bytesRead = [stream read:d maxLength:maxLength];
                if (bytesRead == 0) { //文件读取到最后
                    endOfStreamReached = YES;
                } else if (bytesRead == -1) { //文件读取错误
                    endOfStreamReached = YES;
                } else if (stream.streamError == nil) {
                    [data appendBytes:(void *)d length:bytesRead];
                }
            }
            req.HTTPBody = [data copy];
            [stream close];
        }
        
    }
    return req;
}

@end


static NSString *const HKURLProtocolKey = @"kHKURLProtocolKey";

@interface HKURLProtocol ()<NSURLSessionDataDelegate>
@property(nonatomic, strong)NSURLSessionTask *task;
@property (class, nonatomic,assign)LogLevel  logLevel;
@property (class,nonatomic,assign)NSMutableSet *domainHookSet;
@property (class,nonatomic,assign)NSMutableSet *domainFilterSet;
@end

@implementation HKURLProtocol

@dynamic logLevel, domainHookSet, domainFilterSet;

static LogLevel _logLevel = LogLevel_0;
static NSMutableSet *_domainHookSet = nil;
static NSMutableSet *_domainFilterSet = nil;

#pragma mark --  Public

+ (BOOL)hk_registerClass {
    BOOL result = YES;
#ifdef DEBUG
    result = [NSURLProtocol registerClass:[HKURLProtocol class]];
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
#endif
    return result;
}

+ (void)hk_unregisterClass {
#ifdef DEBUG
    [NSURLProtocol unregisterClass:[HKURLProtocol class]];
    [NSURLProtocol wk_unregisterScheme:@"http"];
    [NSURLProtocol wk_unregisterScheme:@"https"];
#endif
}

+ (void)setLogLevel:(LogLevel)log initResetLog:(BOOL)reset {
    self.logLevel = log;
    if (reset) {
        NSString *logPath = [self getLogFolderPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
        }
    }
}

//host拦截名单
+ (void)domainHookList:(NSArray<NSString*> *)array {
    
    [self.domainHookSet addObjectsFromArray:array];
    
}
//host过滤名单
+ (void)domainFilterList:(NSArray<NSString*> *)array {
    
    [self.domainFilterSet addObjectsFromArray:array];
    
}

#pragma mark -- getter
+ (void)setLogLevel:(LogLevel)logLevel{
    _logLevel = logLevel;
}
+(LogLevel)logLevel {
    return _logLevel;
}

+(void)setDomainHookSet:(NSMutableSet *)domainHookSet {
    _domainHookSet = domainHookSet;
}
+(NSMutableSet *)domainHookSet {
    if (!_domainHookSet) {
        NSArray *defaltArray = @[];
        _domainHookSet = [[NSMutableSet alloc] initWithArray:defaltArray];
    }
    return _domainHookSet;
}

+(void)setDomainFilterSet:(NSMutableSet *)domainFilterSet{
    _domainFilterSet = domainFilterSet;
}
+(NSMutableSet *)domainFilterSet {
    if (!_domainFilterSet) {
        NSArray *defaltArray = @[];
        _domainFilterSet = [[NSMutableSet alloc] initWithArray:defaltArray];
    }
    return _domainFilterSet;
}

#pragma mark -- override

//进行NSURLSession和WKWebView请求过滤判断
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([self class].logLevel == LogLevel_None) {
        return NO;
    }
    
    //判断是否已经处理过，防止无限循环
    if ([NSURLProtocol propertyForKey:HKURLProtocolKey inRequest:request] == nil) {
        if (self.domainHookSet.count > 0) {
            BOOL isHook = [[self.domainHookSet allObjects] indexOfObjectPassingTest:^BOOL(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [request.URL.absoluteString containsString:obj];
            }] != NSNotFound;
            if (isHook) {
                return YES;
            }
            
            return NO;
        }
        
        if (self.domainFilterSet.count > 0) {
            BOOL isFilter = [[self.domainFilterSet allObjects] indexOfObjectPassingTest:^BOOL(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                return [request.URL.absoluteString containsString:obj];
            }] != NSNotFound;
            
            if (isFilter) {
                return NO;
            }
        }
        
        return YES;
    }
    return NO;
}

//拦截处理
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [[request cyl_getPostRequestIncludeBody] mutableCopy];
    //在此处可以做重定向处理
    
    return  mutableRequest;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    
    return [super requestIsCacheEquivalent:a toRequest:b];
}

-(void)startLoading {
    NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
    //给请求添加标记
    [NSURLProtocol setProperty:@YES forKey:HKURLProtocolKey inRequest:mutableRequest];
    
    [self hk_taskWithRequest:mutableRequest];
}

-(void)stopLoading {
    if (self.task) {
        [self.task cancel];
    }
}

-(void)hk_taskWithRequest:(NSMutableURLRequest*)mutableReqeust {
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    if (@available(iOS 13.0, *)) {
        queue.progress.totalUnitCount = 10;
    } else {
        queue.maxConcurrentOperationCount = 10;
    }
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
    self.task = [session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
}

#pragma mark -- NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if ([self class].logLevel != LogLevel_None) {
        
        NSLog(@"=====URL: %@ \n",dataTask.currentRequest.URL);
        
        NSData *dataRef = [self dataWithData:data request:dataTask.originalRequest];
        
        [self writeToFileWith:dataRef interface:dataTask.currentRequest.URL];
    }
    
    [self.client URLProtocol:self didLoadData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        [self.client URLProtocolDidFinishLoading:self];
    }
    
}

#pragma mark --- private

-(NSData *)dataWithData:(NSData*)data request:(NSURLRequest*)request {
    
    if ([self class].logLevel == LogLevel_1) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:request.URL.absoluteString forKey:@"URL"];
        [dict setValue:[self objctWithData:data] forKey:@"Response"];
        
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        
        return resultData;
        
    }else if([self class].logLevel == LogLevel_2){
        return data;
    }else {
        NSMutableString *log = [NSMutableString stringWithFormat:@"URL: %@\n",request.URL.absoluteString];
        [log appendFormat:@"Method: %@\n\n",request.HTTPMethod];
        if ([request.HTTPMethod isEqualToString:@"POST"] && request.HTTPBody.length > 2) {
            [log appendFormat:@"Body: %@\n\n",[self objctWithData:request.HTTPBody]];
        }
        
        [log appendFormat:@"Headers: %@\n\n", [self jsonStringWithObject:request.allHTTPHeaderFields]];
        
        [log appendFormat:@"Response:\n %@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        
        return  [log dataUsingEncoding:NSUTF8StringEncoding];
    }
    
}

-(id)objctWithData:(NSData *)data {
    if (!data) {
        return data;
    }
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([dataStr hasPrefix:@"{"] || [dataStr hasPrefix:@"["]) {
        NSError *error;
        id ojc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            return dataStr;
        }
        return ojc;
    }
    
    return dataStr;
    
}

-(NSString *)jsonStringWithObject:(id)obj {
    if (!obj) {
        return obj;
    }
    
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingFragmentsAllowed error:nil];
        if (data) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return obj;
}


- (void)writeToFileWith:(NSData*)response interface:(NSURL*)interface {
//    NSDictionary *pathDic = [[NSProcessInfo processInfo] environment];
//    NSLog(@"%@",pathDic);
    
    NSString *interfaceStr = [[interface.pathComponents subarrayWithRange:NSMakeRange(1, interface.pathComponents.count - 1)] componentsJoinedByString:@"_"];
#ifdef TARGET_IPHONE_SIMULATOR
    [self _writeSimulatorLog:response interface:interfaceStr];
#else
    if (![self isDebuggerAttached]) {
        [self redirectLogToDocumentFolderWithName:interfaceStr];
    }
    
#endif
    

}

- (void)_writeSimulatorLog:(NSData*)response
                 interface:(NSString*)interface {
    
    if ([response isKindOfClass:[NSData class]]){
       
        NSString *path = [[self class] getLogFolderPath];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 判断文件夹是否存在，如果不存在，则创建
        if (![fileManager fileExistsAtPath:path]) {

            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSLog(@"FileDir is exists.");
        }
        path = [NSString stringWithFormat:@"%@/%@", path, interface];
        
        if ([fileManager fileExistsAtPath:path]) {
            NSMutableData *lastData = [[NSMutableData alloc] initWithData:[NSData dataWithContentsOfFile:path]];
            [lastData appendData:[@"\n\n ---------------------------------------------------------\n\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [lastData appendData:response];
            response = lastData;
        }
        @synchronized (self) {
            [(NSData *)response writeToFile:path atomically:YES];
        }
        
    }
}

//⚠️：真机不连Xcode时使用
/*
 修改项目下的Info.plist,
 添加UIFileSharingEnabled键，并将键值设置为YES,
 添加之后会变成 Application supports iTunes file sharing 为 YES
 */
- (void)redirectLogToDocumentFolderWithName:(NSString*)fileName
{
    if (!fileName) { return; }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    fileName = [NSString stringWithFormat:@"%@.log",fileName];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];

    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
}


-(void)dealloc {
    [self class].domainHookSet = nil;
    [self class].domainFilterSet = nil;
    NSLog(@"%s",__func__);
}

+ (NSString *)_bundleIdentifier{
    return [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey];
}

+ (NSString*)getLogFolderPath {
    NSString *identifier = [[self _bundleIdentifier] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *path = NSHomeDirectory();
    path = [path substringToIndex:[path rangeOfString:@"/Library"].location];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Desktop", path]]) {
        NSAssert(NO, @"请在在模拟器环境下使用");
    }
    path = [NSString stringWithFormat:@"%@/Desktop/%@", path,identifier];
    
    return path;
    
}

/*
 是否调试器连接到当前进程，是则返回"YES"，否则返回"NO"否则
 */
- (BOOL)isDebuggerAttached {
  static BOOL debuggerIsAttached = NO;

  static dispatch_once_t debuggerPredicate;
  dispatch_once(&debuggerPredicate, ^{
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    int name[4];

    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid(); // from unistd.h, included by Foundation

    if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
      NSLog(@"[HockeySDK] ERROR: Checking for a running debugger via sysctl() failed: %s", strerror(errno));
      debuggerIsAttached = false;
    }

    if (!debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0)
      debuggerIsAttached = true;
  });

  return debuggerIsAttached;
}

@end
