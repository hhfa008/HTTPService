//
//  SCHTTPClient.h
// hhfa
//
//  Created by hhfa on 14-10-13.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "AFNetworking.h"

@interface WPHTTPClient : AFHTTPSessionManager
+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                 multipartForm:(NSDictionary *)parameters
                      progress:(void (^)(NSProgress *))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                   multipartForm:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                 responseClass:(Class)responseClass
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                responseClass:(Class)responseClass
                      success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

- (NSURLSessionTask *)getImage:(NSString *)URLString block:(void (^)(UIImage* image, NSError *error))block;
@end
