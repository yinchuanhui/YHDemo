//
//  YHChartView.h
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

/*!
 图表绘制
 高度定制，外部调用只需设置样式和数据源，可通过代理方法调整显示效果。
 */

#import <UIKit/UIKit.h>
#import "YHChartViewConfig.h"

@protocol YHChartViewDataSource;

@interface YHChartView : UIView

@property (nonatomic, assign)id<YHChartViewDataSource> dataSource;

/*!
 init
 
 @param frame
 @param style
 
 @return id
 */
- (id)initWithFrame:(CGRect)frame style:(YHChartStyle)style;

/*!
 显示
 */
- (void)show;

/*!
 切换样式
 
 @param style
 */
- (void)changeStyle:(YHChartStyle)style;

@end


@protocol YHChartViewDataSource <NSObject>

@required

//x坐标数值或标题(折线、柱形)；占比说明（圆形）
- (NSArray *)chartViewXValue:(YHChartView *)chartView;

//y坐标数值或标题(折线、柱形)；占比数值（圆形）
- (NSArray *)chartViewYValue:(YHChartView *)chartView;

//动画时间(折线、柱形、圆形)
- (CGFloat)chartViewAnimateTime:(YHChartView *)chartView;

@optional

//动画样式，默认为YHChartAnimateNormal (折线、柱形、圆形)
- (YHCHartAnimateStyle)chartViewAnimateStyle:(YHChartView *)chartView;

//x坐标单位长度(折线)
- (CGFloat)chartViewXUnitsLength:(YHChartView *)chartView;

//曲线下是否有阴影(折线)
- (BOOL)chartViewHasTrendShadow:(YHChartView *)chartView;

//曲线宽度(折线)
- (CGFloat)chartViewTrendLineWidth:(YHChartView *)chartView;

//曲线颜色(折线)
- (UIColor *)chartViewTrendLineColor:(YHChartView *)chartView;

//曲线下阴影颜色(折线)
- (UIColor *)chartViewTrendShadowColor:(YHChartView *)chartView;

//y坐标数值显示范围，无数组则自适应(折线、柱形)
- (YHRange)chartViewYRange:(YHChartView *)chartView;

//y坐标单位长度(折线、柱形)
- (CGFloat)chartViewYUnitsLength:(YHChartView *)chartView;

//是否显示坐标轴(折线、柱形)
- (BOOL)chartViewHasAxis:(YHChartView *)chartView;

//是否显示水平网格线(折线、柱形)
- (BOOL)chartViewHasHorizontalGird:(YHChartView *)chartView;

//是否显示垂直网格线(折线、柱形)
- (BOOL)chartViewHasVerticalGird:(YHChartView *)chartView;

//坐标轴线宽度(折线、柱形)
- (CGFloat)chartViewAxisLineWidth:(YHChartView *)chartView;

//网格线宽度(折线、柱形)
- (CGFloat)chartViewGirdLineWidth:(YHChartView *)chartView;

//坐标轴线颜色(折线、柱形)
- (UIColor *)chartViewAxisColor:(YHChartView *)chartView;

//网格线颜色(折线、柱形)
- (UIColor *)chartViewGirdColor:(YHChartView *)chartView;

//x轴字体颜色(折线、柱形)
- (UIColor *)chartViewXLabelColor:(YHChartView *)chartView;

//y轴字体颜色(折线、柱形)
- (UIColor *)chartViewYLabelColor:(YHChartView *)chartView;

//x轴字体大小(折线、柱形)
- (UIFont *)chartViewXLabelFont:(YHChartView *)chartView;

//y轴字体大小(折线、柱形)
- (UIFont *)chartViewYLabelFont:(YHChartView *)chartView;

//y轴label宽度(折线、柱形)
- (CGFloat)chartViewYLabelWidth:(YHChartView *)chartView;

//颜色组 (柱形、圆形)
- (NSArray *)chartViewColors:(YHChartView *)chartView;

@end