//
//  WPConfig.m
// hhfa
//
//  Created by hhfa on 14-10-20.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "WPConfig.h"
#define BaseURL   @"https://httpbin.org/"

@implementation WPConfig

static WPConfig *_sharedInstance = nil;
static dispatch_once_t once_token = 0;

+(instancetype)config {
    dispatch_once(&once_token, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [[[self class] alloc] init];
        }
    });
    return _sharedInstance;
}

+(void)reset{
    once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance =  nil;
}


-(NSString*)baseURL
{
    return BaseURL;
}

-(NSString*)posURL
{
    return BaseURL;
}

@end
