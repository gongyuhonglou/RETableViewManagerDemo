//
//  PrefixHeader.h
//  RETableViewManagerDemo
//
//  Created by rpweng on 2019/5/14.
//  Copyright © 2019 rpweng. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#define kScreen_width ([[UIScreen mainScreen] bounds].size.width)

#define kScreen_height ([[UIScreen mainScreen] bounds].size.height)
//状态栏高度
#define __MainStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏高度
#define __MainNavHeight 44
//顶部高度
#define __MainTopHeight (__MainStatusBarHeight+__MainNavHeight)//iphone:44+20  iphonex:44+44

//iPhoneX安全区域高度
#define __MainSafeAreaHeight (__MainStatusBarHeight>20?34:0)
//TabBar高度
#define __MainTabBarHeight (49+__MainSafeAreaHeight)//iphone:49  iphonex:49+34


//评论相关
#define IphoneXCommentHeight (__MainStatusBarHeight>20?(__MainSafeAreaHeight-10):0)


#define __MainScreenFrame   [[UIScreen mainScreen] bounds]//设备屏幕大小
#define __MainScreen_Width  __MainScreenFrame.size.width//设备屏幕宽

#define __MainScreen_Height __MainScreenFrame.size.height - __MainStatusBarHeight//设备屏幕高(屏幕高-状态栏高度)

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

#import "MBProgressHUD.h"
#import "MBProgressHUD+Show.h"
#import "Color+Hex.h"

#endif /* PrefixHeader_h */
