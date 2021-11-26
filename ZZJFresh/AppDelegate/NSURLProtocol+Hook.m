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


static NSString *const HKURLProtocolKey = @"kHKURLProtocolKey";

@interface HKURLProtocol ()<NSURLSessionDataDelegate>
@property(nonatomic, strong)NSURLSessionTask *task;
@end

@implementation HKURLProtocol

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


//进行NSURLSession和WKWebView请求过滤判断
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //判断是否已经处理过，防止无限循环
    if ([NSURLProtocol propertyForKey:HKURLProtocolKey inRequest:request] == nil) {
        return YES;
    }
    return NO;
}

//拦截处理
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
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

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"=====URL: %@ \n",dataTask.currentRequest.URL);
    
    [self writeToFileWith:data interface:dataTask.currentRequest.URL.path];
    
    [self.client URLProtocol:self didLoadData:data];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        [self.client URLProtocolDidFinishLoading:self];
    }
    
}

- (void)writeToFileWith:(NSData*)response interface:(NSString*)interface {
//    NSDictionary *pathDic = [[NSProcessInfo processInfo] environment];
//    NSLog(@"%@",pathDic);
    NSString *identifier = [[[self class] _bundleIdentifier] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    
#ifdef TARGET_IPHONE_SIMULATOR
    [self _writeSimulatorLog:response folderName:identifier interface:interface];
#else
    if (![self isDebuggerAttached]) {
        [self redirectLogToDocumentFolderWithName:identifier];
    }
    
#endif
    

}

- (void)_writeSimulatorLog:(NSData*)response
                folderName:(NSString*)folderName
                 interface:(NSString*)interface {
    
    if ([response isKindOfClass:[NSData class]]){
       
        NSString *path = NSHomeDirectory();
        path = [path substringToIndex:[path rangeOfString:@"/Library"].location];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/Desktop", path]]) {
            return;
        }
        path = [NSString stringWithFormat:@"%@/Desktop/%@", path,folderName];

        // 判断文件夹是否存在，如果不存在，则创建
        if (![fileManager fileExistsAtPath:path]) {

            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSLog(@"FileDir is exists.");
        }
        path = [NSString stringWithFormat:@"%@/%@", path, [interface stringByReplacingOccurrencesOfString:@"/" withString:@"_"]];

        [(NSData *)response writeToFile:path atomically:YES];
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
    NSLog(@"%s",__func__);
}

+ (NSString *)_bundleIdentifier{
    return [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey];
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
