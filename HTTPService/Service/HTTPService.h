//
//  PayService.h
//Merchant
//
//  Created by hhfa on 14-10-13.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface HTTPService : NSObject
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                responseClass:(Class)responseClass
                        block:(void (^)(id responseObject, NSError *error))block;

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                responseClass:(Class)responseClass
                        block:(void (^)(id responseObject, NSError *error))block;

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                         block:(void (^)(id responseObject, NSError *error))block;
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                 responseClass:(Class)responseClass
                         block:(void (^)(id responseObject, NSError *error))block;

@end
