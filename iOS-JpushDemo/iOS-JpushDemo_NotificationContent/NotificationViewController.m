//
//  NotificationViewController.m
//  iOS-JpushDemo_NotificationContent
//
//  Created by zhangzhiliang on 2018/1/19.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = self.view.bounds.size;
    self.preferredContentSize = CGSizeMake(size.width, size.height/2);
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
}

@end
