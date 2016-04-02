//
//  MIAJPushDelegate.m
//  e-friends
//
//  Created by 杨鹏 on 16/3/31.
//  Copyright © 2016年 上海名扬科技股份有限公司. All rights reserved.
//

#import "MIAJPushDelegate.h"
static MIAJPushDelegate *shareJPushInstance = nil;

@implementation MIAJPushDelegate

+(MIAJPushDelegate*)shareJPushDelegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareJPushInstance = [[MIAJPushDelegate alloc] init];
    });
    
    return shareJPushInstance;
}

#pragma mark -
#pragma mark 远程通知

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions appKey:(NSString *)appKey channel:(NSString *)channel apsForProduction:(BOOL)isProduction {
    //-------------------------推送通知---------------------
    //apns
    // Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    //[JPUSHService setupWithOption:launchOptions appKey:@"8452f1c44a89673735a30b05" channel:@"InHouse" apsForProduction:YES];
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
    [self jpushInit];
    
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]) {
        //用户点击本地通知导致app被启动运行
        if ([self.delegate respondsToSelector:@selector(applicationlaunchLocalKey:)]) {
            [self.delegate applicationlaunchLocalKey:launchOptions];
        }
    }
    else if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        //用户点击apn通知导致app被启动运行
        if ([self.delegate respondsToSelector:@selector(applicationlaunchRemoteKey:)]) {
            [self.delegate applicationlaunchRemoteKey:launchOptions];
        }
    }
    return YES;
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"jpush已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"jpush未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"jpush已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"jpsh已登录");
    [JPUSHService registrationID];
    NSLog(@"registrationID %@",[JPUSHService registrationID]);
}

//应用内消息回调
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    if ([self.delegate respondsToSelector:@selector(handleJpushDefineMsg:)]) {
        [self.delegate handleJpushDefineMsg:userInfo];
    }
    else {
        [self handleJpushDefineMsg:userInfo];
    }
}

- (void)serviceError:(NSNotification *)notification {
    NSLog(@"jpush错误");
}

- (void)handleJpushDefineMsg:(NSDictionary *)userInfo
{
    //处理消息
    if ([userInfo.allKeys containsObject:@"content"]) {
        NSLog(@"recriveMES:%@",userInfo);
    }
}

- (void)jpushInit
{
    // 应用内消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
    
    // Required,apns通知,本地通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        NSMutableSet *categorie = [NSMutableSet set];
        
        //1.创建动作
        UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
        action.identifier = @"action";//按钮的标示
        action.title=@"拒绝";//按钮的标题
        action.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序
        action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action.destructive = NO;  //YES显示为红色，NO显示为蓝色，默认为蓝色
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2";
        action2.title=@"接受";
        action2.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        action.authenticationRequired = YES;
        action.destructive = YES;
        
        UIMutableUserNotificationAction *replyAction = [[UIMutableUserNotificationAction alloc]init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            replyAction.identifier = @"reply";
            replyAction.title = @"回复";
            replyAction.activationMode = UIUserNotificationActivationModeBackground;
            replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
            replyAction.authenticationRequired = YES;
            replyAction.destructive = YES;
        }
        
        //2.创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        //{"aps":{"alert":"example", "sound":"default", "badge": 1, "category":"identifier"}}
        categorys.identifier = @"identifier";//这组动作的唯一标示,推送通知的时候也是根据这个来区分｜这个要和服务器推送过来的数据一致
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            [categorys setActions:@[replyAction] forContext:UIUserNotificationActionContextDefault];
        }
        else {
            //ios >= 8.0 <9.0
            [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
        }
        //3.添加到set
        [categorie addObject:categorys];
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:categorie];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)                      categories:nil];
    }
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required, apns
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6, apns
    NSLog(@"%@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
}

//apn消息回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required, apns
    NSLog(@"%@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        if ([self.delegate respondsToSelector:@selector(handleRemoteNotification:)]) {
            [self.delegate handleRemoteNotification:userInfo];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到推送消息"
                                                            message:userInfo[@"aps"][@"alert"]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",  nil];
            [alert show];
        }
    }
    else {
        //点击远程推送通知后处理的函数
        if ([self.delegate respondsToSelector:@selector(remoteNotificationClick:)]) {
            [self.delegate remoteNotificationClick:userInfo];
        }
    }
}
    
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    //Optional, apns
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:@"action"]) {
        //拒绝按钮被按下
        if ([self.delegate respondsToSelector:@selector(actionleftRemoteNotification:)]) {
            [self.delegate actionleftRemoteNotification:userInfo];
        }
    }
    else if ([identifier isEqualToString:@"action2"]) {
        //接受按钮被按下
        if ([self.delegate respondsToSelector:@selector(actionrightRemoteNotification:)]) {
            [self.delegate actionrightRemoteNotification:userInfo];
        }
    }
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(nonnull NSDictionary *)userInfo withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler {
    if ([identifier isEqualToString:@"reply"]) {
        //NSString *response = responseInfo[UIUserNotificationActionResponseTypedTextKey];
        //对输入的文字作处理
        if ([self.delegate respondsToSelector:@selector(actiontextRemoteNotification:withResponseInfo:)]) {
            [self.delegate actiontextRemoteNotification:userInfo withResponseInfo:responseInfo];
        }
    }
    completionHandler();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSNotificationCenter defaultCenter] removeObserver:kJPFNetworkDidSetupNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kJPFNetworkDidCloseNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kJPFNetworkDidLoginNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kJPFNetworkDidRegisterNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kJPFNetworkDidReceiveMessageNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:kJPFServiceErrorNotification];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    //获取最新消息，以及未读数,这个函数会讲服务器中的未读消息数设为0
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //获取最新消息，以及未读数
    [JPUSHService resetBadge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark -
#pragma mark 本地通知
-(void)addLocalNotification:(NSDate *)fireDate
                  alertBody:(NSString *)alertBody
                      badge:(int)badge
                alertAction:(NSString *)alertAction
              identifierKey:(NSString *)notificationKey
                   userInfo:(NSDictionary *)userInfo
                  soundName:(NSString *)soundName
                     region:(CLRegion *)region
         regionTriggersOnce:(BOOL)regionTriggersOnce
                   category:(NSString *)category {
    //调用通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService setLocalNotification:fireDate//[NSDate dateWithTimeIntervalSinceNow:0.5]
                                 alertBody:alertBody//@"最近添加了诸多有趣的特性，是否立即体验？"
                                     badge:badge//0
                               alertAction:alertAction//nil
                             identifierKey:notificationKey//@"alert"   //本地通知标示
                                  userInfo:userInfo//@{@"id":@1,@"user":@"Kenshin Cui"}
                                 soundName:UILocalNotificationDefaultSoundName
                                    region:region//nil
                        regionTriggersOnce:regionTriggersOnce//YES
                                  category:@"identifier"];  //注册时category的标示 categorys.identifier ＝ @"identifier"
    }
    else {
        [JPUSHService setLocalNotification:fireDate//[NSDate dateWithTimeIntervalSinceNow:0.5]
                                 alertBody:alertBody//@"最近添加了诸多有趣的特性，是否立即体验？"
                                     badge:badge//0
                               alertAction:alertAction//nil
                             identifierKey:notificationKey//@"alert"  //本地通知标示
                                  userInfo:userInfo//@{@"id":@1,@"user":@"Kenshin Cui"}
                                 soundName:UILocalNotificationDefaultSoundName];
    }
}

- (void)clearAllLocalNotifications {
    [JPUSHService clearAllLocalNotifications];
}

- (nullable NSArray *)findLocalNotificationWithIdentifier:(nullable NSString *)notificationKey {
    return [JPUSHService findLocalNotificationWithIdentifier:notificationKey];
}

- (void)deleteLocalNotification:(nullable UILocalNotification *)localNotification {
    [JPUSHService deleteLocalNotification:localNotification];
}

- (void)deleteLocalNotificationWithIdentifierKey:(nullable NSString *)notificationKey {
    [JPUSHService deleteLocalNotificationWithIdentifierKey:notificationKey];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //API用来在APP前台运行时，仍然将通知显示出来。(样式为UIAlertView)
    NSLog(@"本地通知：%@", notification);
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:@"alert"]; //标示符为alert的本地通知在前台会弹出UIAlertView
    
    // 应用正处理前台状态下，处理本地推送的消息不会弹出消息框的本地消息
    if (application.applicationState == UIApplicationStateActive) {
        if ([self.delegate respondsToSelector:@selector(handleLocalNotification:)]) {
            [self.delegate handleLocalNotification:notification];
        }
    }
    else {
        //点击本地通知后处理的函数
        if ([self.delegate respondsToSelector:@selector(localNotificationClick:)]) {
            [self.delegate localNotificationClick:notification];
        }
    }
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)())completionHandler{
    if ([identifier isEqualToString:@"action"]) {
        //拒绝按钮被按下
        if ([self.delegate respondsToSelector:@selector(actionleftLocalNotification:)]) {
            [self.delegate actionleftLocalNotification:notification];
        }
    }
    else if ([identifier isEqualToString:@"action2"]) {
        //接受按钮被按下
        if ([self.delegate respondsToSelector:@selector(actionrightLocalNotification:)]) {
            [self.delegate actionrightLocalNotification:notification];
        }
    }
    completionHandler();
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)())completionHandler {
    if ([identifier isEqualToString:@"reply"]) {
        //NSString *response = responseInfo[UIUserNotificationActionResponseTypedTextKey];
        //对输入的文字作处理
        if ([self.delegate respondsToSelector:@selector(actiontextLocalNotification:withResponseInfo:)]) {
            [self.delegate actiontextLocalNotification:notification withResponseInfo:responseInfo];
        }
    }
    completionHandler();
}

- (void)setTags:(NSSet *)tags alias:(NSString *)alias fetchCompletionHandle:(void (^)(int iResCode, NSSet *iTags, NSString *iAlias))completionHandler {
    [JPUSHService setTags:tags alias:alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
        completionHandler(iResCode, iTags, iAlias);
    }];
}

@end
