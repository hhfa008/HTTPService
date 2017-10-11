//
//  QueryOrder.h
// hhfa
//
//  Created by hhfa on 14-10-16.
//  Copyright (c) 2014年 hhfa. All rights reserved.
//

#import "WPData.h"

@interface WPQueryOrder : WPData
{
    NSMutableDictionary* query;
    

}


-(NSMutableDictionary*)query;
-(void)update:(id)res;
-(void)set:(id)o key:(id)key;

@property NSString* PageSize;
@property NSString* PageIndex;
@end
