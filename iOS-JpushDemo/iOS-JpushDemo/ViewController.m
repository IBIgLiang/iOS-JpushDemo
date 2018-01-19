//
//  ViewController.m
//  iOS-JpushDemo
//
//  Created by zhangzhiliang on 2018/1/19.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)jpushLoaclNotificationTest {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Jpush本地推送测试";
    content.subtitle = @"BG-666";
    content.body = @"你成功了吗？";
    content.badge = @1;
    /**
     {
     "aps" : {
     "alert" : {
     "title" : "Jpush本地推送测试",
     "subtitle" : "BG-666",
     "body" : "你成功了吗？"
     },
     "badge" : 1
     },
     }
     */
    
    
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    NSString *requestIdentifier = @"sampleRequest";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self jpushLoaclNotificationTest];
}


@end
