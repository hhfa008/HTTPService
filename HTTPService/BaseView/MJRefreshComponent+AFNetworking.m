//
//  MJRefreshComponent+AF.m
//  hhfa
//
//  Created by hhfa on 6/4/16.
//  Copyright © 2016 hhfa. All rights reserved.
//
#import "HUD.h"
#import "MJRefreshComponent+AFNetworking.h"
#import "AFURLSessionManager.h"



@interface MJNotificationObserver : NSObject
@property (readonly, nonatomic, weak) MJRefreshComponent *activityIndicatorView;
- (instancetype)initWithMJ:(MJRefreshComponent *)activityIndicatorView;

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;

@end

@implementation MJRefreshComponent (AFNetworking)

- (MJNotificationObserver *)af_notificationObserver {
    MJNotificationObserver *notificationObserver = objc_getAssociatedObject(self, @selector(af_notificationObserver));
    if (notificationObserver == nil) {
        notificationObserver = [[MJNotificationObserver alloc] initWithMJ:self];
        objc_setAssociatedObject(self, @selector(af_notificationObserver), notificationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return notificationObserver;
}

- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task {
    [[self af_notificationObserver] setAnimatingWithStateOfTask:task];
}

@end

@implementation MJNotificationObserver

- (instancetype)initWithMJ:(MJRefreshComponent *)activityIndicatorView
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
            

            if (task.state == NSURLSessionTaskStateRunning) {                [self.activityIndicatorView beginRefreshing];
            } else {
                [self.activityIndicatorView  endRefreshing];
            }

            
            [notificationCenter addObserver:self selector:@selector(af_startAnimating) name:AFNetworkingTaskDidResumeNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidCompleteNotification object:task];
            [notificationCenter addObserver:self selector:@selector(af_stopAnimating) name:AFNetworkingTaskDidSuspendNotification object:task];
        }
    }
}

#pragma mark -

- (void)af_startAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.activityIndicatorView beginRefreshing];

    });
}

- (void)af_stopAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{

        [self.activityIndicatorView endRefreshing];

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
