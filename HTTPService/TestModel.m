//
//  TestModel.m
//  HTTPService
//
//  Created by youkia on 2017/10/23.
//  Copyright © 2017年 hhfa. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel
+(NSString *)path
{
    return @"https://httpbin.org/get";
}
+(BOOL)get
{
    return YES;
}
@end
