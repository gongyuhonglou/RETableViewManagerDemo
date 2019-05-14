//
//  UIViewController+ESSeparatorInset.m
//  TableViewSeparatorInset
//
//  Created by  on 15/7/18.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "UIViewController+ESSeparatorInset.h"
#import <objc/runtime.h>

static NSString *ES_INSETS_ASS_KEY = @"ES_INSETS_ASS_KEY";

@interface UIViewController()

@property (nonatomic, assign) UIEdgeInsets inset;

@end

@implementation UIViewController (ESSeparatorInset)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
        SEL swizzledSelector = @selector(es_tableView:willDisplayCell:forRowAtIndexPath:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)es_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self respondsToSelector:@selector(es_tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self es_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
    [self setSeparatorInsetWithTarget:cell insets:self.inset];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}



- (void)setSeparatorInsetZeroWithTableView:(UITableView *)tableView{
    [self setSeparatorInsetWithTableView:tableView inset:UIEdgeInsetsZero];
}

- (void)setSeparatorInsetWithTableView:(UITableView *)tableView inset:(UIEdgeInsets)inset{
    self.inset = inset;
    [self setSeparatorInsetWithTarget:tableView insets:inset];
}

- (void)setSeparatorInsetWithTarget:(id)target insets:(UIEdgeInsets)insets{
    if ([target respondsToSelector:@selector(setSeparatorInset:)]) {
        [target setSeparatorInset:insets];
    }
    if ([target respondsToSelector:@selector(setLayoutMargins:)]) {
        [target setLayoutMargins:insets];
    }
}

- (void)setInset:(UIEdgeInsets)insets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, &ES_INSETS_ASS_KEY, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)inset{
    NSValue *value = objc_getAssociatedObject(self, &ES_INSETS_ASS_KEY);
    return [value UIEdgeInsetsValue];
}

//+(UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    id  nextResponder = nil;
//    UIViewController *appRootVC=window.rootViewController;
//    //    如果是present上来的appRootVC.presentedViewController 不为nil
//    if (appRootVC.presentedViewController) {
//        nextResponder = appRootVC.presentedViewController;
//    }else{
//
//        NSLog(@"===%@",[window subviews]);
//        UIView *frontView = [[window subviews] objectAtIndex:0];
//        nextResponder = [frontView nextResponder];
//    }
//
//    if ([nextResponder isKindOfClass:[UITabBarController class]]){
//        UITabBarController * tabbar = (UITabBarController *)nextResponder;
//        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
//        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
//        result=nav.childViewControllers.lastObject;
//
//    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
//        UIViewController * nav = (UIViewController *)nextResponder;
//        result = nav.childViewControllers.lastObject;
//    }else{
//        result = nextResponder;
//    }
//    NSLog(@"当前控制器%@",result);
//    return result;
//}
+ (UIViewController *)getCurrentVC {
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
    
}


@end
