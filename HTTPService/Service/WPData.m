
//  WPData.m
// hhfa
//
//  Created by hhfa on 14-10-13.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import <objc/runtime.h>

#import "WPData.h"
#import "NSObject+JSON.h"
#import "HTTPService.h"
#import "MJRefresh.h"
#import "HUD+AFNetworking.h"
#import "MJRefreshComponent+AFNetworking.h"


@implementation WPData

+(id) req:(void (^)(id response, NSError *error))block
{
    return  [self get]?[self get:nil block:block]:[self req:nil block:block];
}

+(id) get:(void (^)(id response, NSError *error))block
{
      return  [self req:nil block:block];
}

+(id) reqFrom:(id)from block:(void (^)(id response, NSError *error))block
{
    return [self reqFrom:from query:nil block:block];
}

+(id) reqFrom:(id)from query:(id)query block:(void (^)(id response, NSError *error))block
{
    id o = [self get]?[self get:query block:block]:[self req:query block:block];
    
    if ([from isKindOfClass:[UIViewController class]]) {
        
        [HUD wait:o atController:from];
        
    } else  if ([from isKindOfClass:[MJRefreshHeader class]] || [from isKindOfClass:[MJRefreshAutoNormalFooter class]])
    {
        MJRefreshComponent* refresh = from;
        [refresh setAnimatingWithStateOfTask:o];
        
    }
    return o;
}


+(id) getFrom:(id)from  query:(id)query block:(void (^)(id response, NSError *error))block
{
    id o = [self get:query block:block];
    return o;
}

+(id) req:(id)query  block:(void (^)(id response, NSError *error))block;
{
    return [HTTPService POST:[[self class] path] parameters:[query JSON]   responseClass:[self class] block:block];
}

+(id) get:(id)query  block:(void (^)(id response, NSError *error))block;
{
    return [HTTPService GET:[[self class] path] parameters:[query JSON]  responseClass:[self class] block:block];
}

+(NSString*)path
{
    return nil;
}
+(BOOL)get
{
    return NO;
}

- (NSArray*) properties
{
    NSArray* array =  [self propertiesForClass:[self class]];
    
    return array;
}

- (NSArray*) propertiesForClass:(Class)cls
{
    if (cls == [NSObject class] ) {
        return nil;
    }
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:outCount];
    
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            [array addObject:propertyName];
        }
    }
    
    NSArray* superPro = [self propertiesForClass:[cls superclass]];
    
    if (superPro != nil ) {
        [array addObjectsFromArray:superPro];
    }
    
    free(properties);
    return array;
}

- (SEL)selectorForProperty:(NSString*)property
{
    NSArray* array = @[@"set", [[property substringToIndex:1] uppercaseString], [property substringFromIndex:1], @":"];
    return NSSelectorFromString([array componentsJoinedByString:@""]);
}

- (void)setJson:(id)data
{
    json = data;
}

- (NSArray*) signProperties
{
    return nil;
}

+(NSArray*)dataList:(NSArray*)attributeList
{
    if([attributeList isKindOfClass:[NSArray class]] && [attributeList count] > 0)
    {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *attributes in attributeList) {
            id object = [[self class] alloc];
            [list addObject:[(WPData*)object initWithAttributes:attributes]];
        }
        return list;
    }
    return nil;
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    if (![attributes isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    if(self){
        [self setValuesForKeysWithDictionary:attributes];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self._id = value;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        NSArray* properties = [self properties];
        for (NSString* key in properties) {
            SEL selectorForProperty = [self selectorForProperty:key];
            if ([self respondsToSelector:selectorForProperty]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:selectorForProperty withObject:[aDecoder decodeObjectForKey:key]];
#pragma clang diagnostic pop
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray* properties = [self properties];
    for (NSString* key in properties) {
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id a = [self performSelector:NSSelectorFromString(key)];
            [aCoder encodeObject:a forKey:key];
            #pragma clang diagnostic pop
        }
    }
}
@end

