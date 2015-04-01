//
//  AppDelegate.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//
//
//                        _ooOoo_
//                       o8888888o
//                       88" . "88
//                       (| -_- |)
//                       O\  =  /O
//                    ____/`---'\____
//                  .'  \\|     |//  `.
//                 /  \\|||  :  |||//  \
//                /  _||||| -:- |||||-  \
//                |   | \\\  -  /// |   |
//                | \_|  ''\---/''  |   |
//                \  .-\__  `-`  ___/-. /
//              ___`. .'  /--.--\  `. . __
//           ."" '<  `.___\_<|>_/___.'  >'"".
//          | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//          \  \ `-.   \_ __\ /__ _/   .-` /  /
//     ======`-.____`-.___\_____/___.-`____.-'======
//                        `=---='
//     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                 佛祖保佑       永无BUG
//

#import <UIKit/UIKit.h>
#import "YHPanTransitionViewController.h"
#import "YHPopWithPanNavigationController.h"

/*!
 *
 *加载不同UI框架通过修改宏来显示，框架中的方法也需要根据宏来判断是否调用
 *
 */
#define kYHPanTransitionViewController
//#define kYHPopWithPanNavigationController

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
#ifdef kYHPanTransitionViewController
@property (nonatomic, strong) YHPanTransitionViewController *rootVC;
#endif
#ifdef kYHPopWithPanNavigationController
@property (nonatomic, strong) YHPopWithPanNavigationController *rootVC;
#endif
@property (nonatomic, strong) UINavigationController *rootNav;

@end

