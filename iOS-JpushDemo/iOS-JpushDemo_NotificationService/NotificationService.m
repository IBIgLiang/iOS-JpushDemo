//
//  NotificationService.m
//  iOS-JpushDemo_NotificationService
//
//  Created by zhangzhiliang on 2018/1/19.
//  Copyright © 2018年 zhangzhiliang. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    // didReceiveNotificationRequest 让你可以在后台处理接收到的推送，传递最终的内容给 contentHandler
    
    self.contentHandler = contentHandler;
    
    // 1.把推送内容转为可变类型
    self.bestAttemptContent = [request.content mutableCopy];
    
     // 2.获取 1 中自定义的字段 value
    NSString *urlStr = [request.content.userInfo valueForKey:@"your-attachment"];
    
    // 3.将文件夹名和后缀分割
    NSArray *urls = [urlStr componentsSeparatedByString:@"."];
    
    // 4.获取该文件在本地存储的 url
    NSURL *urlNative = [[NSBundle mainBundle] URLForResource:urls[0] withExtension:urls[1]];
    
    // 5.依据 url 创建 attachment
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:urlStr URL:urlNative options:nil error:nil];
    
    // 6.赋值 @[attachment] 给可变内容
    self.bestAttemptContent.attachments = @[attachment];
    
    // 7.处理该内容
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    
    //serviceExtensionTimeWillExpire 在你获得的一小段运行代码的时间即将结束的时候，如果仍然没有成功的传入内容，会走到这个方法，可以在这里传肯定不会出错的内容，或者他会默认传递原始的推送内容
    
    self.contentHandler(self.bestAttemptContent);
}

@end
