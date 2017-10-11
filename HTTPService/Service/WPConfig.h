//
//  WPConfig.h
// hhfa
//
//  Created by hhfa on 14-10-20.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WPConfig : NSObject
+ (instancetype)config;
+(void)reset;
@property (nonatomic) NSString* baseURL;

@end
