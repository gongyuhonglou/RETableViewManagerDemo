//
//  MBProgressHUD+Show.m
//  weibo
//
//  Created by apple on 13-9-1.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Show.h"

@implementation MBProgressHUD (Show)
+ (void)showText:(NSString *)text detailsString:(NSString * )detailsString name:(NSString *)name
{
    // 显示加载失败
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // 显示一张图片(mode必须写在customView设置之前)
    hud.mode = MBProgressHUDModeCustomView;
    // 设置一张图片
    name = [NSString stringWithFormat:@"MBProgressHUD.bundle/%@", name];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    
    hud.label.text = text;
    hud.detailsLabel.text = detailsString;
    hud.margin = 60.f;
    
    // 隐藏的时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒后自动隐藏
    [hud hideAnimated:YES afterDelay:1];
  
}

+ (void)showErrorWithText:(NSString *)text detailsString:(NSString * )detailsString
{
    [self showText:text detailsString:detailsString name:@"error.png"];
}

+ (void)showSuccessWithText:(NSString *)text detailsString:(NSString * )detailsString
{
    [self showText:text detailsString:detailsString name:@"success.png"];
}

+(void)showText:(NSString *)text {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
//    hud.margin = 40.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];

}

+(void)showText:(NSString *)text detailsString:(NSString *)detailtext{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.detailsLabel.text = detailtext;
    hud.margin = 40.f;
    hud.removeFromSuperViewOnHide = YES;
    
     [hud hideAnimated:YES afterDelay:1];
}


#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
   
    NSUInteger i = [UIApplication  sharedApplication].windows.count;
    if (view == nil){
        if (i > 1) {
            view = [UIApplication sharedApplication].windows[1];
        }else {
            view = [UIApplication sharedApplication].windows[0];
            
        }
        
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;

    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    
    NSUInteger i = [UIApplication  sharedApplication].windows.count;
    if (view == nil){
        if (i > 1) {
            view = [UIApplication sharedApplication].windows[1];
        }else {
            view = [UIApplication sharedApplication].windows[0];
            
        }
        
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

@end
