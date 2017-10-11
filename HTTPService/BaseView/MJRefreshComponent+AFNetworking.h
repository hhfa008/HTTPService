//
//  MJRefreshComponent+AF.h
//  hhfa
//
//  Created by hhfa on 6/4/16.
//  Copyright © 2016 hhfa. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MJRefreshComponent (AFNetworking)
- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;
@end
