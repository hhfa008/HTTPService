//
//  HUD+AFNetworking.m
//  HTTPService
//
//  Created by hhfa on 2017/10/23.
//  Copyright © 2017年 hhfa. All rights reserved.
//

#import "HUD+AFNetworking.h"
#import <objc/runtime.h>
#import "AFURLSessionManager.h"

@interface AFHUDNotificationObserver : NSObject
@property (readonly, nonatomic, weak) HUD *activityIndicatorView;
- (instancetype)initWithHUD:(HUD *)activityIndicatorView;

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;

@end

@implementation HUD (AFNetworking)


- (AFHUDNotificationObserver *)af_notificationObserver {
    AFHUDNotificationObserver *notificationObserver = objc_getAssociatedObject(self, @selector(af_notificationObserver));
    if (notificationObserver == nil) {
        notificationObserver = [[AFHUDNotificationObserver alloc] initWithHUD:self];
        objc_setAssociatedObject(self, @selector(af_notificationObserver), notificationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return notificationObserver;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    [[self af_notificationObserver] setAnimatingWithStateOfTask:task];
}

@end

@implementation AFHUDNotificationObserver

- (instancetype)initWithHUD:(HUD *)activityIndicatorView
{
    self = [super init];
    if (self) {
        _activityIndicatorView = activityIndicatorView;
    }
    return self;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    
    if (task) {
        if (task.state != NSURLSessionTaskStateCompleted) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
            if (task.state == NSURLSessionTaskStateRunning) {
                [self.activityIndicatorView showAnimated:YES];
            } else {
                [self.activityIndicatorView  hideAnimated:YES];
            }
#pragma clang diagnostic pop
            
            [notificationCenter addObserver:self selector:@selector(af_startAnimating) name:AFNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidSuspendNotification object:task];
        }
    }
}

#pragma mark -

- (void)af_startAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
        [self.activityIndicatorView showAnimated:YES];
#pragma clang diagnostic pop
    });
}

- (void)af_stopAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreceiver-is-weak"
        [self.activityIndicatorView hideAnimated:YES];
#pragma clang diagnostic pop
    });
}

#pragma mark -

- (void)dealloc {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidCompleteNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidResumeNotification object:nil];
    [notificationCenter removeObserver:self name:AFNetworkingTaskDidSuspendNotification object:nil];
}

@end
