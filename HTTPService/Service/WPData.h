//
//  WPData.h
// hhfa
//
//  Created by hhfa on 14-10-13.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPData : NSObject
{
    id json;
}

+(id) reqFrom:(id)from block:(void (^)(id response, NSError *error))block;
+(id) reqFrom:(id)from query:(id)query block:(void (^)(id response, NSError *error))block;


+(id) req:(id)query  block:(void (^)(id response, NSError *error))block;
+(id) get:(id)query  block:(void (^)(id response, NSError *error))block;

+(id) req:(void (^)(id response, NSError *error))block;
+(id) get:(void (^)(id response, NSError *error))block;
+(NSArray*)dataList:(NSArray*)attributeList;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSArray*) signProperties;
- (NSArray*) properties;
- (void)setJson:(id)data;

+(NSString*)path;
+(BOOL)get;

@property NSString* _id;
@property NSNumber* moredata;
@property NSNumber* success;
@property NSString* msg;
@property NSNumber* hasSorted;
@property NSIndexPath* indexPath;

@property NSNumber* IsOk;
@property NSNumber* Status;
@property NSString* Msg;
@property NSString* Content;
@property NSString* Data;
@property NSString * HostUrl;
@property NSString * FileUrl;
//moredata = 0;
//ret = 1;
//retmsg
@end
