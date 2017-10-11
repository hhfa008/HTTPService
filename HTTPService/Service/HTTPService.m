//
//  PayService.m
//Merchant
//
//  Created by hhfa on 14-10-13.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "HTTPService.h"
#import "WPHTTPClient.h"
#import "NSObject+JSON.h"
#import "WPDataResponseSerializer.h"
#import "WPData.h"

@implementation HTTPService


+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                responseClass:(Class)responseClass
                        block:(void (^)(id responseObject, NSError *error))block

{
    return [HTTPService GET:URLString parameters:nil responseClass:responseClass block:block];
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                        block:(void (^)(id responseObject, NSError *error))block

{
    return [HTTPService GET:URLString parameters:parameters responseClass:nil block:block];
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                        block:(void (^)(id responseObject, NSError *error))block

{
    return [HTTPService GET:URLString parameters:nil responseClass:nil block:block];
}



+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                         block:(void (^)(id responseObject, NSError *error))block
{
    return  [HTTPService POST:URLString parameters:parameters responseClass:nil block:block];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                 responseClass:(Class)responseClass
                         block:(void (^)(id responseObject, NSError *error))block
{
    URLString = URLString?:[responseClass path];
    NSURLSessionDataTask* o = [[WPHTTPClient sharedClient] POST:URLString parameters:parameters responseClass:responseClass success:^(NSURLSessionDataTask * __unused task, id JSON) {
        block(JSON, nil);
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    return o;
}

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                responseClass:(Class)responseClass
                        block:(void (^)(id responseObject, NSError *error))block

{
    URLString = URLString?:[responseClass path];
    NSURLSessionDataTask* o = [[WPHTTPClient sharedClient] GET:URLString parameters:parameters responseClass:responseClass success:^(NSURLSessionDataTask * __unused task, id JSON) {
        if (block)
        {
            block(JSON, nil);
        }
    
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    return o;
}

@end
