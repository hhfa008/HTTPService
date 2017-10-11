//
//  SCDataResponseSerializer.h
//  hhfa
//
//  Created by hhfa on 14-8-22.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface WPDataResponseSerializer : AFJSONResponseSerializer
-(id)initWithResponseClass:(Class)cls;
- (id)responseObjectForResponse:(NSURLResponse *)response
                           JSON:(id)JSON
                          error:(NSError *__autoreleasing *)error;
@property Class responseClass;

@end
