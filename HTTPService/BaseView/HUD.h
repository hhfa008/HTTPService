//
//  HUD.h
//  smartya
//
//  Created by hhfa on 14-4-30.
//  Copyright (c) 2014年 polyvi. All rights reserved.
//

#import "MBProgressHUD.h"

@interface HUD : MBProgressHUD

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (HUD *)showMessage:(NSString *)message;
+ (HUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
+ (HUD *)showAll:(UIViewController *)vc;
+ (HUD *)show:(UIViewController *)vc;
+ (HUD *)wait:(NSURLSessionTask *)operation atController:(UIViewController*)vc;

@end
