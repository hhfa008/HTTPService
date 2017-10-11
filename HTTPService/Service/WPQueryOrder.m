//
//  QueryOrder.m
// hhfa
//
//  Created by hhfa on 14-10-16.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "WPQueryOrder.h"

@implementation NSNumber (key)

-(void)objectForKey:(id)key
{
    
}

@end

@implementation WPQueryOrder
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    [super setValue:value forUndefinedKey:key];
    [self set:value key:key];
}
-(void)update:(id)res
{
    if ([res isKindOfClass:[WPData class]]) {
        WPData* data = res;
        if (data.moredata && data.moredata.boolValue == NO) {
            return;
        }
    }

    if (_PageIndex) {
        _PageIndex = [@([_PageIndex integerValue] + 1) stringValue];
    }
}

-(NSMutableDictionary *)query
{
    return query;
}
-(void)set:(id)o key:(id)key
{
    if(query == nil) query =  [NSMutableDictionary dictionary];
    [query setObject:o forKey:key];
}

@end
