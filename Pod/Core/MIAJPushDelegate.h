//
//  MIAJPushDelegate.h
//  e-friends
//
//  Created by 杨鹏 on 16/3/31.
//  Copyright © 2016年 上海名扬科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JPUSHService.h"
#import "MIAJPushProtocol.h"

@interface MIAJPushDelegate : NSObject <UIAlertViewDelegate>

@property (nonatomic,weak) id<MIAJPushProtocol> delegate;

+(nullable MIAJPushDelegate *)shareJPushDelegate;

- (BOOL)application:(nullable UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions appKey:(nullable NSString *)appKey channel:(nullable NSString *)channel apsForProduction:(BOOL)isProduction;

- (void)application:(nullable UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nullable NSData *)deviceToken;

- (void)application:(nullable UIApplication *)application didReceiveRemoteNotification:(nullable NSDictionary *)userInfo;

- (void)application:(nullable UIApplication *)application didReceiveRemoteNotification:(nullable NSDictionary *)userInfo fetchCompletionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler;

- (void)application:(nullable UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error;

- (void)application:(nullable UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nullable NSDictionary *)userInfo completionHandler:(nullable void (^)())completionHandler;

- (void)application:(nullable UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler;

- (void)applicationWillTerminate:(nullable UIApplication *)application;

-(void)application:(nullable UIApplication *)application didRegisterUserNotificationSettings:(nullable UIUserNotificationSettings *)notificationSettings;

-(void)applicationWillEnterForeground:(nullable UIApplication *)application;

- (void)applicationDidBecomeActive:(nullable UIApplication *)application;

- (void)application:(nullable UIApplication *)application didReceiveLocalNotification:(nullable UILocalNotification *)notification;

-(void)application:(nullable UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)())completionHandler;

-(void)application:(nullable UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler;

-(void)addLocalNotification:(nullable NSDate *)fireDate
                  alertBody:(nullable NSString *)alertBody
                      badge:(int)badge
                alertAction:(nullable NSString *)alertAction
              identifierKey:(nullable NSString *)notificationKey
                   userInfo:(nullable NSDictionary *)userInfo
                  soundName:(nullable NSString *)soundName
                     region:(nullable CLRegion *)region
         regionTriggersOnce:(BOOL)regionTriggersOnce
                   category:(nullable NSString *)category;

- (void)clearAllLocalNotifications;
- (nullable NSArray *)findLocalNotificationWithIdentifier:(nullable NSString *)notificationKey;
- (void)deleteLocalNotification:(nullable UILocalNotification *)localNotification;
- (void)deleteLocalNotificationWithIdentifierKey:(nullable NSString *)notificationKey;
- (void)setTags:(nullable NSSet *)tags alias:(nullable NSString *)alias fetchCompletionHandle:(nullable void (^)(int iResCode,  NSSet * _Nullable iTags, NSString * _Nullable iAlias))completionHandler;
@end
