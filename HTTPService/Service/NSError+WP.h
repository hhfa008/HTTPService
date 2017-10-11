//
//  NSError+XError.h
//  smartya
//
//  Created by hhfa on 14-3-25.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const CLErrorDomain = @"CLErrorDomain";

@interface NSError (WP)
+(id) permissionError;
+(id) errorWithCode:(NSString*)code msg:(NSString*)msg;
+(id) errorWithResponse:(int)code object:(id)object;
+(id) errorWithCode:(NSString*)code msg:(NSString*)msg data:(NSObject*)data;
-(NSString*)msg;
-(id)data;

-(NSString*)connectionMsg;
-(NSString*)networkErrorMsg;
@end
