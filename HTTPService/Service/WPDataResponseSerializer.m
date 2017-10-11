//
//  WPDataResponseSerializer.m
//  hhfa
//
//  Created by hhfa on 14-8-22.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "WPDataResponseSerializer.h"
#import "WPData.h"
#import "NSError+WP.h"

@implementation WPDataResponseSerializer
-(id)initWithResponseClass:(Class)cls
{
    self = [super init];
    if(self)
    {
        self.responseClass = cls;
    }
    return self;
}




- (id)responseObjectForResponse:(NSURLResponse *)response
                           JSON:(id)JSON
                          error:(NSError *__autoreleasing *)error
{

    NSHTTPURLResponse* r = (NSHTTPURLResponse *)response;
    if (r.statusCode != 200) {
        *error = [NSError errorWithCode:[@(r.statusCode) stringValue] msg:NSLocalizedString(@"服务器异常",nil)];
        
        return nil;
        
    }
    
    if (*error) {
        return JSON;
    }
    long status = ((NSHTTPURLResponse*)response).statusCode;
    if(status != 200)
        return JSON;
    
    if([JSON isKindOfClass:[NSArray class]] )
    {
        return [self.responseClass performSelector:@selector(dataList:) withObject:JSON];
    }
    NSNumber* code = [JSON objectForKey:@"code"];
    NSString* msg =  [JSON objectForKey:@"msg"];

    if([code integerValue] != 0)
    {
        if(code && msg)
        {
            
            *error = [NSError errorWithCode:[code stringValue] msg:msg
                                       data:[JSON objectForKey:@"data"]];
            
            return nil;
        }
      
        return JSON;
    }
    NSDictionary* indata = [JSON objectForKey:@"data"];
    
    
    if(self.responseClass == nil || ![self.responseClass isSubclassOfClass:[WPData class]])
    {
        if(code || msg)
        {
            WPData* r= [[WPData alloc] initWithAttributes:JSON];
            
            return r;
        }
        return JSON;
    }
    
    if ((![indata isKindOfClass:[NSDictionary class]]&&![indata isKindOfClass:[NSArray class]])) {
        id object = [self.responseClass alloc];
        return [(WPData*)object initWithAttributes:JSON];
    }
    

    if ([code boolValue] && [JSON isKindOfClass:[NSDictionary class]]) {
    
        if([indata isKindOfClass:[NSArray class]] && [indata count] > 0)
        {
            return [self.responseClass performSelector:@selector(dataList:) withObject:indata];
        } else if ([JSON isKindOfClass:[NSDictionary class]])
        {
            id object = [self.responseClass alloc];
            return [(WPData*)object initWithAttributes:indata];
        }else
        {
            return JSON;
        }
        
        
    }
    return JSON;
}

@end
