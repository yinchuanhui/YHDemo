//
//  YHBaseChartView.h
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHChartViewConfig.h"

typedef void(^BackflowCompleteBlock)(void);

@interface YHBaseChartView : UIView

@property (nonatomic, strong) NSArray *xValues;//x坐标值/描述
@property (nonatomic, strong) NSArray *yValues;//y坐标值/描述
@property (nonatomic, assign) CGFloat animateTime;//动画时间
@property (nonatomic, assign) YHCHartAnimateStyle animateStyle;//动画类型

/*!
 绘制图表
 */
- (void)strokeChart;

/*!
 将图片已动画方式隐藏
 
 @param animated
 @param completeBlock 
 */
- (void)backflowWithAnimate:(BOOL)animated completeBlock:(BackflowCompleteBlock)completeBlock;

@end
