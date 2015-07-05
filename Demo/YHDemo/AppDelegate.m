//
//  AppDelegate.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AppDelegate.h"

//三屏滑动demo
#import "YHPanTransitionViewController.h"
#import "YHCenterViewController.h"
#import "YHLeftViewController.h"
#import "YHRightViewController.h"

//自定义nav，滑动返回上一层
#import "YHPopWithPanNavigationController.h"
#import "YHPanPopViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*!
     三屏切换效果，如果要演示其他切换效果的demo可更改rootVC
     除上述demo外，其他demo统一在getTransitionVC方法中配置，左侧视图为demo选择区域，中间视图为demo显示区域，通过切换中间视图来显示不用demo
     */
#ifdef kYHPanTransitionViewController
    self.rootVC = [self getTransitionVC];
#endif
    
    /*!
     自定义UINavigationController，滑动返回上一级
     */
#ifdef kYHPopWithPanNavigationController
    self.rootVC = [self getPopNav];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Method

- (YHPanTransitionViewController *)getTransitionVC
{
//    NSDictionary *demoDic = @{@"Runloop-Demo1": @"YHRunloopDemo1ViewController",
//                              @"Runloop-Demo2": @"YHRunloopDemo2ViewController",
//                              @"Runloop-Demo3": @"YHRunloopDemo3ViewController",
//                              @"Runloop-Demo4": @"YHRunloopDemo4ViewController",
//                              @"RunTime-Demo1": @"YHRunTimeDemo1ViewController",
//                              @"RunTime-Demo2": @"YHRunTimeDemo2ViewController"};
    NSMutableDictionary *demoDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Demo_List" ofType:@"plist"]];
    
    YHLeftViewController *leftVC = [[YHLeftViewController alloc] initWithDemoDic:demoDic];
    YHCenterViewController *centerVC = [[YHCenterViewController alloc] init];
    self.rootNav = [[UINavigationController alloc] initWithRootViewController:centerVC];
    YHRightViewController *rightVC = [[YHRightViewController alloc] init];
    
    YHPanTransitionViewController *transitionVC = [[YHPanTransitionViewController alloc] initWithCenterViewController:self.rootNav leftViewController:leftVC rightViewController:rightVC];
    return transitionVC;
}

- (YHPopWithPanNavigationController *)getPopNav{
    YHPopWithPanNavigationController *panNav = [[YHPopWithPanNavigationController alloc] initWithRootViewController:[[YHPanPopViewController alloc] init]];
    return panNav;
}

@end
