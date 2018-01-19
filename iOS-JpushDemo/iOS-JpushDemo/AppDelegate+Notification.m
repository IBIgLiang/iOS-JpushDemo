//
//  AppDelegate+Notification.m
//  iOS-JpushDemo
//
//  Created by zhangzhiliang on 2018/1/19.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

/**
 Local Notifications 通过定义 Content 和 Trigger 向  UNUserNotificationCenter 进行 request 这三部曲来实现。比如方法：jpushLocalNotificationTestWithCenter
 Remote Notifications 则向 APNs 发送 Notification Payload 。
 
 Service Extension：可以在手机「接收到推送之后、展示推送之前」对推送进行处理，更改、替换原有的内容。使用了这个玩意，你们公司原有发送推送的 payload 可以完全不变，而在客户端对接收到的内容（只有一条字符串）进行加工，从而适配 iOS 10 的展示效果（标题+副标题+内容）。
 */

#import "AppDelegate+Notification.h"
#import <UserNotifications/UserNotifications.h>

#define JPUSH_ACTION_IDENTIFIER @"reply"
#define JPUSH_CATEGORY_IDENTIFIER @"message"

@implementation AppDelegate (Notification)

- (void)registerJpushWithApplication:(UIApplication *)application {
    if (@available(iOS 10.0, *)) {
        //注册推送
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"register success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
            
        }];
        
        UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:JPUSH_ACTION_IDENTIFIER title:@"回复" options:UNNotificationActionOptionNone];
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:JPUSH_CATEGORY_IDENTIFIER actions:@[action] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
        [center setNotificationCategories:[NSSet setWithArray:@[category]]];
        //本地推送测试
        [self jpushLocalNotificationTestWithCenter:center];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
}

- (void)jpushLocalNotificationTestWithCenter:(UNUserNotificationCenter *)center {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Jpush本地推送测试";
    content.subtitle = @"BG-666";
    content.body = @"你成功了吗？";
    content.badge = @1;
    content.categoryIdentifier = JPUSH_CATEGORY_IDENTIFIER;
    /**
     Triggers:包括三种：
     UNTimeIntervalNotificationTrigger： 设置一段时间后提醒，可以重复提醒
     UNCalendarNotificationTrigger：按日历提醒，例如每周几 几点 提醒
     UNLocationNotificationTrigger：按地点提醒
     */
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    NSString *requestIdentifier = @"sampleRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger1];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"ok");
        }
    }];
    
//    删除推送
//    [center removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];
}

//通过实现协议，使 App 处于前台时捕捉并处理即将触发的推送;让它只显示 alert 和 sound ,而忽略 badge 。
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

//用户点击这些 actions 以后，是启动 App、触发键盘、清除通知或是有其他的响应，这些全部只需要实现协议 UNUserNotificationCenterDelegate 中的一个方法就可以控制
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
//    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
//    if ([categoryIdentifier isEqualToString:JPUSH_CATEGORY_IDENTIFIER]) {
//        if ([response.actionIdentifier isEqualToString:JPUSH_ACTION_IDENTIFIER]) {
//            //假设点击了输入内容的 UNTextInputNotificationAction 把 response 强转类型
//            UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
//            //获取输入内容
//            NSString *userText = textResponse.userText;
//            //发送 userText 给需要接收的方法
////            [ClassName handleUserText: userText];
//
//        }
//    }
    
    completionHandler();
}

@end
