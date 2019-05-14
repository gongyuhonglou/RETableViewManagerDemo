//
//  MBProgressHUD+Show.h
//  weibo
//
//  Created by apple on 13-9-1.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Show)

+ (void)showErrorWithText:(NSString *)text detailsString:(NSString * )detailsString;
+ (void)showSuccessWithText:(NSString *)text detailsString:(NSString * )detailsString;

//只显示提示文字
+ (void)showText:(NSString *)text;
+(void)showText:(NSString *)text detailsString:(NSString *)detailtext;



+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
