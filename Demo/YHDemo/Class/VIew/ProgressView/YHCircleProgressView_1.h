//
//  YHCircleProgressView_1.h
//  YHDemo
//
//  Created by ych on 15/3/12.
//  Copyright (c) 2015年 YH. All rights reserved.
//

/*
 *
 *  圆形进度条
 *
 */

#import <UIKit/UIKit.h>

//进度条状态
typedef enum {
    ProgressStatusNormal,
    ProgressStatusStart,
    ProgressStatusComplete
}ProgressStatus;//进度条状态

@interface YHCircleProgressView_1 : UIView

@property (nonatomic, assign)CGFloat annulusBorderWidth;//外层圆环线条宽度 默认：1.0
@property (nonatomic, assign)UIColor *annulusBorderCorlor;//外层圆环线条颜色 默认：0xffffff
@property (nonatomic, assign)CGFloat progressRadius;//圆形进度条半径 默认：根据视图大小设置
@property (nonatomic, retain)UIColor *progressBgColor;//圆形进度条背景颜色 默认：0xffffff
@property (nonatomic, assign)CGFloat progressStrokeWidth;//圆形进度条已加载部分线条宽度 默认：1.0
@property (nonatomic, retain)UIColor *progressFillColor;//圆形进度条已加载部分填充色 默认：0x73B4F5
@property (nonatomic, retain)UIColor *completeMarkStrokeColor;//完成标记颜色 默认：0x757575
@property (nonatomic, retain)NSMutableArray *completeMarkPoints;//完成标记路径；默认：[NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(8.5, 12)],[NSValue valueWithCGPoint:CGPointMake(10.5, 14)],[NSValue valueWithCGPoint:CGPointMake(15, 10)], nil];

/**
 @brief 更新配置，设置线条颜色、宽度、填充色后调用
 */
- (void)updateConfig;

/**
 @brief 设置进度，progress：0.0 - 1.0
 */
- (void)updateProgress:(CGFloat)progress;//设置进度

@end