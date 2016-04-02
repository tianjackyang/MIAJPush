//
//  AppDelegate.m
//  e-friends
//
//  Created by janven on 16/1/21.
//  Copyright © 2016年 上海帜讯信息技术股份有限公司. All rights reserved.
//

/*#import "AppDelegate.h"
#import "MIAJPushDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //-------------------------通知监控--------------------------
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didFinishLaunchingWithOptions:appKey:channel:apsForProduction:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didFinishLaunchingWithOptions:launchOptions appKey:@"8452f1c44a89673735a30b05"  channel:@"InHouse"  apsForProduction:YES];
    }
    
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
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(applicationWillEnterForeground:)]) {
        [[MIAJPushDelegate shareJPushDelegate] applicationWillEnterForeground:application];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(applicationDidBecomeActive:)]) {
        [[MIAJPushDelegate shareJPushDelegate] applicationDidBecomeActive:application];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(applicationWillTerminate:)]) {
        [[MIAJPushDelegate shareJPushDelegate] applicationWillTerminate:application];
    }
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[MIAAppPayDelegate sharePayDelegate] respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)]) {
        [[MIAAppPayDelegate sharePayDelegate] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didReceiveRemoteNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didRegisterUserNotificationSettings:notificationSettings];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:didReceiveLocalNotification:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application didReceiveLocalNotification:notification];
    }
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)())completionHandler {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:completionHandler:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:completionHandler];
    }
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler {
    if ([[MIAJPushDelegate shareJPushDelegate] respondsToSelector:@selector(application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:)]) {
        [[MIAJPushDelegate shareJPushDelegate] application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
    }
}

@end*/
