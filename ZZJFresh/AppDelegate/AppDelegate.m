//
//  AppDelegate.m
//  ZZJFresh
//
//  Created by ZZJ on 2017/12/28.
//  Copyright © 2017年 Jion. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+DecimalNumber.h"

@interface PP: NSObject
@end

@implementation PP

@end
@interface AppDelegate ()
@property (nonatomic, strong) NSString *strongString;
@property (nonatomic, weak)   NSString *weakString;

@property (nonatomic, strong) PP *strongPP;
@property (nonatomic, weak)   PP *weakPP;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _strongString = @"string1";
    _weakString =  _strongString;
    
    _strongString = nil;
    
    NSLog(@"%@", _weakString);//string1
    
    _strongPP = [[PP alloc] init];
    _weakPP = _strongPP;
    _strongPP = nil;
    NSLog(@"==%@",_weakPP);//nil

//    2.25*3.35+4.2*5.7
    NSString *string = @"2.25".multiplyingBy(@"3.35").addingBy(@"4.2".multiplyingBy(@"5.7")).endRoundingMode(NSRoundDown,2);
    NSLog(@"%@",string);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
