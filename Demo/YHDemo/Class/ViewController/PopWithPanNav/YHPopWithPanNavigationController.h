//
//  YHPopWithPanNavigationController.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHPopWithPanNavigationController : UINavigationController <UIGestureRecognizerDelegate>

/*!
 是否支持滑动手势，可以用于解决手势冲突
 */
@property (nonatomic, assign)BOOL panGestureEnable;

/*!
 手否支持手势并发，可以用于解决手势冲突
 */
@property (nonatomic, assign)BOOL simultaneouslyGestureEnable;

@end
