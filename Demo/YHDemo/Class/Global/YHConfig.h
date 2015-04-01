//
//  YHConfig.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#ifndef YHDemo_YHConfig_h
#define YHDemo_YHConfig_h

//rootVC rootNav
#define kYH_RootVC                      ((AppDelegate *)[UIApplication sharedApplication].delegate).rootVC
#define kYH_RootNav                     ((AppDelegate *)[UIApplication sharedApplication].delegate).rootNav

//设备
#define kYH_IsIOS6                      [[YHSystemUtil sharedInstance] isIOS6]
#define kYH_IsIOS7                      [[YHSystemUtil sharedInstance] isIOS7]
#define kYH_IsIOS8                      [[YHSystemUtil sharedInstance] isIOS8]
#define kYH_IsIphone                    [[YHSystemUtil sharedInstance] isIphone]
#define kYH_IsIphone                    [[YHSystemUtil sharedInstance] isIphone]
#define kYH_IsIphone4                   [[YHSystemUtil sharedInstance] isIphone4]
#define kYH_IsIphone5                   [[YHSystemUtil sharedInstance] isIphone5]
#define kYH_IsIphone6                   [[YHSystemUtil sharedInstance] isIphone6]
#define kYH_IsIphone6Plus               [[YHSystemUtil sharedInstance] isIphone6Plus]
#define kYH_ScreenWidth                 [[YHSystemUtil sharedInstance] screenWidth]
#define kYH_ScreenHeight                [[YHSystemUtil sharedInstance] screenHeight]
#define kYH_StatusBarHeight             (kYH_IsIOS6?20.0:0.0)
#define kYH_NavigationBarHeight         (kYH_IsIOS6?44.0:64.0)

//app
#define kYH_AppVersion                  [[YHAppUtil sharedInstance] appVersion]
#define kYH_DocumentsPath               [[YHAppUtil sharedInstance] documentsPath]
#define kYH_LibraryPath                 [[YHAppUtil sharedInstance] libraryPath]
#define kYH_IsFirstTimeLaunch           [[YHAppUtil sharedInstance] isFirstTimeLaunch]
#define kYH_IsFirstTimeVersionLaunch    [[YHAppUtil sharedInstance] isFirstTimeVersionLaunch]

//color
#define kYH_Color_RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kYH_Color_ARGB(argbValue)       [UIColor colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 green:((float)((argbValue & 0xFF00) >> 8))/255.0 blue:((float)(argbValue & 0xFF))/255.0 alpha:(argbValue > 0xFFFFFF) ? (argbValue>>24)&0xFF : 255]

//font
#define kYH_Font_Normal(size)           [UIFont systemFontOfSize:size]
#define kYH_Font_Blod(size)             [UIFont boldSystemFontOfSize:size]

//数据处理，通常用于检测服务端数据
#define kYH_Safe_String(x)              (x&&[x isKindOfClass:[NSString class]])?x:([x isKindOfClass:[NSNumber class]]?[x description]:@"")
#define kYH_Safe_Object(x)              ( ((x) == [NSNull null] || (x) == nil) ? nil : (x) )

#endif
