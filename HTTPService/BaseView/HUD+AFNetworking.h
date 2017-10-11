//
//  HUD+AFNetworking.h
//  HTTPService
//
//  Created by hhfa on 2017/10/23.
//  Copyright © 2017年 hhfa. All rights reserved.
//

#import "HUD.h"

@interface HUD (AFNetworking)
- (void)setAnimatingWithStateOfTask:(NSURLSessionTask *)task;
@end
