//
//  NSObject+JSON.h
//  hhfa
//
//  Created by hhfa on 14-7-23.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)
- (NSString *)JSONString;
- (id)JSON;
+ (id)JSONWithFileAtPath:(NSString *)path;
@end
