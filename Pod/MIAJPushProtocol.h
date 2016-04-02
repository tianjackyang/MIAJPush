//
//  MIAJPushProtocol.h
//  e-friends
//
//  Created by 杨鹏 on 16/3/31.
//  Copyright © 2016年 上海名扬科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MIAJPushProtocol <NSObject>
@required

@optional
//用户点击本地通知导致app被启动运行
- (void)applicationlaunchLocalKey:(NSDictionary *)launchOptions;
//用户点击apn通知导致app被启动运行
- (void)applicationlaunchRemoteKey:(NSDictionary *)launchOptions;
//处理极光推送自定义消息（应用内消息）的函数
- (void)handleJpushDefineMsg:(NSDictionary *)userInfo;
// 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
- (void)handleRemoteNotification:(NSDictionary *)remoteInfo;
// 远程通知左边action按钮被按下的处理函数
- (void)actionleftRemoteNotification:(NSDictionary *)remoteInfo;
// 远程通知右边action按钮被按下的处理函数
- (void)actionrightRemoteNotification:(NSDictionary *)remoteInfo;
// 远程通知输入文字action按钮被处理
- (void)actiontextRemoteNotification:(NSDictionary *)remoteInfo withResponseInfo:(NSDictionary *)responseInfo;
//点击远程通知区域触发的函数
- (void)remoteNotificationClick:(NSDictionary *)userInfo;
// 本地通知左边action按钮被按下的处理函数
- (void)actionleftLocalNotification:(UILocalNotification *)localInfo;
// 本地通知右边action按钮被按下的处理函数
- (void)actionrightLocalNotification:(UILocalNotification *)localInfo;
// 本地通知输入文字action按钮被处理
- (void)actiontextLocalNotification:(UILocalNotification *)localInfo withResponseInfo:(NSDictionary *)responseInfo;
// 应用正处理前台状态下，处理本地推送的消息
- (void)handleLocalNotification:(UILocalNotification *)localInfo;
//点击远程通知区域触发的函数
- (void)localNotificationClick:(UILocalNotification *)localInfo;
@end
