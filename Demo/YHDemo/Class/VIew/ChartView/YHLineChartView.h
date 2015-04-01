//
//  YHLineChartView.h
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseChartView.h"

@interface YHLineChartView : YHBaseChartView

@property (nonatomic, assign)YHRange yRange;                //y坐标范围
@property (nonatomic, assign)CGFloat xUnitsLength;          //x坐标单位长度
@property (nonatomic, assign)CGFloat yUnitsLength;          //y坐标单位长度

@property (nonatomic, assign)BOOL    hasAxis;               //是否显示坐标轴
@property (nonatomic, assign)BOOL    hasHorizontalGird;     //是否显示水平网格线
@property (nonatomic, assign)BOOL    hasVerticalGird;       //是否显示垂直网格线
@property (nonatomic, assign)BOOL    hasTrendShadow;        //曲线下是否有阴影

@property (nonatomic, assign)CGFloat trendLineWidth;        //曲线宽度
@property (nonatomic, assign)CGFloat axisLineWidth;         //坐标轴线宽度
@property (nonatomic, assign)CGFloat girdLineWidth;         //网格线宽度

@property (nonatomic, retain)UIColor *axisColor;            //坐标轴线颜色
@property (nonatomic, retain)UIColor *girdColor;            //网格线颜色
@property (nonatomic, retain)UIColor *trendLineColor;       //曲线颜色
@property (nonatomic, retain)UIColor *trendShadowColor;     //曲线下阴影颜色

@property (nonatomic, retain)UIColor *xLabelColor;          //x轴字体颜色
@property (nonatomic, retain)UIColor *yLabelColor;          //y轴字体颜色
@property (nonatomic, retain)UIFont  *xLabelFont;           //x轴字体大小
@property (nonatomic, retain)UIFont  *yLabelFont;           //y轴字体大小

@property (nonatomic, assign)CGFloat xLabelHeigh;           //x轴label高度
@property (nonatomic, assign)CGFloat yLabelWidth;           //y轴label宽度

/*!
 计算y坐标显示范围
 
 @param yValues
 
 @return 
 */
- (YHRange)computeYRangeWithYValues:(NSArray *)yValues;

@end
