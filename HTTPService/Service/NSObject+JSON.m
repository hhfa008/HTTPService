//
//  NSObject+JSON.m
//  hhfa
//
//  Created by hhfa on 14-7-23.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "NSObject+JSON.h"
#import "WPData.h"
#import "WPQueryOrder.h"

@implementation NSObject (JSON)
- (NSString *)JSONString
{
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (id)JSON
{
    if([self isKindOfClass:[NSDictionary class]])
    {
        return self;
    }

    if([self isKindOfClass:[NSString class]])
    {
        NSError* error = nil;
        id a=  [NSJSONSerialization JSONObjectWithData:[(NSString*)self dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:kNilOptions
                                                        error:&error];
        
        return a;

    }

    if([self isKindOfClass:[NSData class]])
    {
        return [NSJSONSerialization JSONObjectWithData:(NSData*)self options:NSJSONReadingMutableContainers error:nil];
    }
    if([self isKindOfClass:[WPData class]])
    {
        NSArray* properties = [(WPData*)self properties];
        NSMutableDictionary* json = [NSMutableDictionary dictionary];
        for (NSString* key in properties) {
            if ([self respondsToSelector:NSSelectorFromString(key)]) {
                id a = [self performSelector:NSSelectorFromString(key)];

                if ((a != nil)) {
                    [json setObject:a forKey:key];
                }
            }
        }
        
        
         if([self isKindOfClass:[WPQueryOrder class]])
         {
             WPQueryOrder* q = self;
             NSMutableDictionary* query =q.query;
             if (query.count) {
                 [json setValuesForKeysWithDictionary:query];
             }
         }
        return json;
    }
    return nil;
}

+ (id)JSONWithFileAtPath:(NSString *)path
{
    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
    [inputStream open];
    id jsonObject = [NSJSONSerialization JSONObjectWithStream:inputStream
                                                      options:kNilOptions
                                                        error:nil];
    [inputStream close];
    return jsonObject;
}
@end
