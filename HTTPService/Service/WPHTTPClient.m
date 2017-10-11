//
//  SCHTTPClient.m
// hhfa
//
//  Created by hhfa on 14-10-13.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "WPHTTPClient.h"
#import "WPConfig.h"
#import "NSError+WP.h"
#import "WPDataResponseSerializer.h"
#import "WPData.h"


@interface NSData (GameKitCategory)
+(NSData*) dataWithValue:(NSValue*)value;
+(NSData*) dataWithNumber:(NSNumber*)number;
@end

@implementation NSData (GameKitCategory)
+(NSData*) dataWithValue:(NSValue*)value
{
    NSUInteger size;
    const char* encoding = [value objCType];
    NSGetSizeAndAlignment(encoding, &size, NULL);
    
    void* ptr = malloc(size);
    [value getValue:ptr];
    NSData* data = [NSData dataWithBytes:ptr length:size];
    free(ptr);
    
    return data;
}

+(NSData*) dataWithNumber:(NSNumber*)number
{
    return [NSData dataWithValue:(NSValue*)number];
}
@end

@implementation WPHTTPClient
{
    NSMutableDictionary* responseSerializer;
}
+ (instancetype)sharedClient {
    static WPHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WPHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[WPConfig config] baseURL]]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
           _sharedClient.requestSerializer.timeoutInterval = 30;
        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
     
        _sharedClient.requestSerializer.timeoutInterval = 30;
        _sharedClient.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        policy.allowInvalidCertificates = YES;
        _sharedClient.securityPolicy = policy;
 
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", @"text/html",@"application/octet-stream", nil];
        [_sharedClient.reachabilityManager startMonitoring];
        
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                 responseClass:(Class)responseClass
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    __block void (^ok) (NSURLSessionDataTask * __unused task, id JSON);
    __block void (^fail) (NSURLSessionDataTask *operation, NSError *error);
    
    ok = ^(NSURLSessionDataTask * __unused task, id JSON) {
        
        WPDataResponseSerializer* d = [[WPDataResponseSerializer alloc] initWithResponseClass:responseClass];
        NSError* e;
        JSON = [d responseObjectForResponse:task.response JSON:JSON error:&e];
        if (e) {
            failure(task,e);
        } else
            success(task, JSON);
    };
    fail = ^(NSURLSessionDataTask *task, NSError *error)
    {
        long status = ((NSHTTPURLResponse*)task.response).statusCode;
        NSError* e = nil;//[NSError errorWithResponse:task.response];
        if(!self.reachabilityManager.reachable && e == nil)
        {
            e =  [NSError errorWithDomain:CLErrorDomain code:602 userInfo:@{@"code":@(602), @"msg":NSLocalizedString(@"未连接到互联网",nil)}];
        }
        failure(task, e ? e :error);
        
    };
    
    NSURLSessionDataTask* t = [super POST:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(NSURLSessionDataTask *operation, id responseObject))ok
                                  failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))fail];
    return t;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                responseClass:(Class)responseClass
                      success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    
    
    __block void (^ok) (NSURLSessionDataTask * __unused task, id JSON);
    __block void (^fail) (NSURLSessionDataTask *operation, NSError *error);
    
    ok = ^(NSURLSessionDataTask * __unused task, id JSON) {
        WPDataResponseSerializer* d = [[WPDataResponseSerializer alloc] initWithResponseClass:responseClass];
        NSError* e;
        JSON = [d responseObjectForResponse:task.response JSON:JSON error:&e];
        if (e) {
            failure(task,e);
        } else
            success(task, JSON);
    };
    fail = ^(NSURLSessionDataTask *task, NSError *error)
    {
        failure(task, error);
        
        
    };
    
    NSURLSessionDataTask* t =  [super GET:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(NSURLSessionDataTask *operation, id responseObject))ok
                                  failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))fail];
    //    [responseSerializer setObject:responseClass forKey:@(t.taskIdentifier)];
    return t;
}

- (NSURLSessionDataTask *)getImage:(NSString *)URLString block:(void (^)(UIImage* image, NSError *error))block
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    sessionManager.responseSerializer = [AFImageResponseSerializer serializer];
    NSURLSessionDataTask *task = [sessionManager GET:URLString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        block(responseObject, nil);
        //        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        block(nil, error);
        NSLog(@"Error: %@", error);
    }];
    
    //    NSURL* url = [NSURL URLWithString:URLString];
    //    NSURLRequest*  urlRequest = [NSURLRequest requestWithURL:url];
    //
    //    NSURLSessionDataTask *operation = [self HTTPRequestOperationWithRequest:urlRequest
    //                    success:^(NSURLSessionDataTask *operation, id responseObject) {
    //        block(responseObject, nil);
    //
    //    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    //        block(nil, error);
    //    }];
    //    operation.responseSerializer = [AFImageResponseSerializer serializer];
    //    
    //    [self.operationQueue addOperation:operation];
    //    
    //    return operation;
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    NSURLSessionDataTask* o = [super POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
    return o;
}


- (NSURLSessionDataTask *)POST:(NSString *)URLString
                 multipartForm:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    return [self POST:URLString multipartForm:parameters progress:nil success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                 multipartForm:(NSDictionary *)parameters
                      progress:(void (^)(NSProgress *))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure

{
    void (^block)(id <AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData)
    {
        if (!parameters) {
            return;
        }
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSNumber class]]) {
                obj = [obj stringValue];
            }
            if ([obj isKindOfClass:[NSString class]]) {
                NSFileManager* fmr =[NSFileManager defaultManager];
                if (//[[obj pathExtension] isEqualToString:@"amr"] &&
                    [fmr fileExistsAtPath:obj])
                {
//                    NSData* data = [NSData dataWithContentsOfFile:obj];
                    NSString* fileName = [[obj lastPathComponent] stringByReplacingOccurrencesOfString:@"mov" withString:@"mp3"];
                    if ([obj rangeOfString:@"mov" ].length > 0) {
                         [formData appendPartWithFormData:[@"0" dataUsingEncoding:NSUTF8StringEncoding] name:@"chat"];
                    } else{
//                          [formData appendPartWithFormData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] name:@"chat"];
                    }
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:obj] name:key fileName:fileName mimeType:@"application/json" error:nil];
                    
                } else
                [formData appendPartWithFormData:[obj dataUsingEncoding:NSUTF8StringEncoding] name:key];
            }
            
//            if ([obj isKindOfClass:[NSNumber class]]) {
//                [formData appendPartWithFormData:[NSData dataWithNumber:obj] name:key];
//            }

            if ([obj isKindOfClass:[UIImage class]]) {

                 NSData* d1 = UIImageJPEGRepresentation(obj, 0.7);
//                UIImagePNGRepresentation(obj)
                [formData appendPartWithFileData:d1 name:key fileName:@"upload_img.jpeg" mimeType:@"image/jpeg" ];
            }
            
        }];
    };
    
    NSURLSessionDataTask* o  =
    [self POST:URLString parameters:nil constructingBodyWithBlock:block
      progress:uploadProgress
     
       success:^(NSURLSessionDataTask *task, id JSON) {
          
           WPDataResponseSerializer* d = [[WPDataResponseSerializer alloc] initWithResponseClass:[WPData class]];
           NSError* e;
           JSON = [d responseObjectForResponse:task.response JSON:JSON error:&e];
           if (e) {
               failure(task,e);
           } else
               success(task, JSON);
 
       } failure:^(NSURLSessionDataTask *operation, NSError *error) {
           failure(operation,error);
       
       }];

    return o;
}


@end
