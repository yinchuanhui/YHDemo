//
//  YHPanTransitionViewController.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

/*!
 三屏滑动切换效果
 */

#import "YHBaseViewController.h"

@interface YHPanTransitionViewController : YHBaseViewController <UIGestureRecognizerDelegate>

#pragma mark - Property

/*!
 滑动手势是否有效，可以用来解决手势冲突
 */
@property (nonatomic, assign)BOOL panGestureEnable;

/*!
 中间视图
 */
@property (nonatomic, strong)UIViewController *centerViewController;

/*!
 左侧视图
 */
@property (nonatomic, strong)UIViewController *leftViewController;

/*!
 右侧视图
 */
@property (nonatomic, strong)UIViewController *rightViewController;

/*!
 是否已显示左侧视图
 */
@property (nonatomic, readonly)BOOL isLeftViewShow;

/*!
 是否已显示右侧视图
 */
@property (nonatomic, readonly)BOOL isRightViewShow;


#pragma mark - Method

/*!
 设置中间视图、左侧视图和右侧视图，中间视图不能为nil，左侧和右侧若不需要则传nil
 导航栏
 
 @param centerViewController centerViewController
 @param leftViewController   leftViewController
 @param rightViewController   rightViewController
 
 @return YHPanTransitionViewController
 */
- (id)initWithCenterViewController:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;

/*!
 更换中间视图
 
 @param centerVC centerVC
 */
- (void)changeCenterVC:(UIViewController *)centerVC;

/*!
 显示左侧视图
 */
- (void)showLeftView;

/*!
 隐藏左侧视图
 */
- (void)hideLeftView;

/*!
 显示右侧视图
 */
- (void)showRightView;

/*!
 隐藏右侧视图
 */
- (void)hideRightView;

@end
