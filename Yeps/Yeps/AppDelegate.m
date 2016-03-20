//
//  AppDelegate.m
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "UnLoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "UserTool.h"

static NSString *appKey = @"fd4eeefc6a44";
static NSString *appSecret = @"4f3872cc0e37ea40dbcbf23750985769";
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    注册短信验证
    [SMSSDK registerApp:appKey withSecret:appSecret];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (![UserTool getAccessToken]) {
        MainNavigationController *nav = [[MainNavigationController alloc] init];
        UnLoginViewController *unLoginVC = [[UnLoginViewController alloc] init];
        [nav pushViewController:unLoginVC animated:NO];
        self.window.rootViewController = nav;
    } else {
        MainTabBarController *mainVC = [[MainTabBarController alloc] init];
        self.window.rootViewController = mainVC;
    }
    
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

@end
