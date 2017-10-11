//
//  NSError+XError.m
//  smartya
//
//  Created by hhfa on 14-3-25.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "NSError+WP.h"
//#import "AFURLConnectionOperation.h"

@implementation NSError (WP)

-(NSString*)networkErrorMsg
{
    NSString* msg;

    if ([self.domain isEqualToString:NSURLErrorDomain] || [self.domain isEqualToString:NSCocoaErrorDomain]) {
        msg = self.localizedDescription;
    }
   
    return msg;
}


-(id)data
{
   id data;

    
    //    if (self.code == 11007 || self.code == 11013) {
    //        return NSLocalizedString(@"密码错误",nil);
    //    }
    //
    //    if (self.code == 11024) {
    //        return NSLocalizedString(@"账号已冻结",nil);
    //    }
    
    if (CLErrorDomain == self.domain) {
        data = [self.userInfo objectForKey:@"data"];
    }
;
    
    return data;
}

-(NSString*)msg
{
     NSString* msg;
    if (self.code == 11007) {
        return NSLocalizedString(@"密码错误",nil);
    }
    
    if (self.code == 2001) {
        return NSLocalizedString(@"您的账号已被冻结",nil);
    }
 
//    if (self.code == 11007 || self.code == 11013) {
//        return NSLocalizedString(@"密码错误",nil);
//    }
//
//    if (self.code == 11024) {
//        return NSLocalizedString(@"账号已冻结",nil);
//    }
    
    if (CLErrorDomain == self.domain) {
        msg = [self.userInfo objectForKey:@"msg"];
    }
    if(msg ==nil)
        return [self networkErrorMsg];

    return msg;
}

-(NSString *)connectionMsg
{
    NSString* msg;
    if (CLErrorDomain == self.domain) {
        msg = [self.userInfo objectForKey:@"msg"];
    }

    return msg;
}

+(id) permissionError
{
    return [NSError errorWithDomain:CLErrorDomain code:601 userInfo:@{@"msg" : @"no permission"}];
}

+(id) errorWithCode:(NSString*)code msg:(NSString*)msg
{
    return [NSError errorWithDomain:CLErrorDomain code:[code integerValue] userInfo:@{@"msg":msg,@"code":code}];
}

+(id) errorWithCode:(NSString*)code msg:(NSString*)msg data:(NSObject*)data
{
    return [NSError errorWithDomain:
            CLErrorDomain code:[code integerValue]
                           userInfo:@{@"msg":msg,
                                      @"data":data?:@"",
                                      @"code":code}];
}

+(id) errorWithResponse:(int)code object:(id)object
{
    if (code != 200 && [object isKindOfClass:[NSDictionary class]]) {
        return [NSError errorWithDomain:CLErrorDomain code:code userInfo:object];
    }
    return nil;
}

@end
