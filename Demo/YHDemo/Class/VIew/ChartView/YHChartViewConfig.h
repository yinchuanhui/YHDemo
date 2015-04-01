//
//  YHChartViewConfig.h
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#ifndef YHDemo_YHChartViewConfig_h
#define YHDemo_YHChartViewConfig_h

//图表样式
typedef enum{
    YHChartLineStyle,
    YHChartBarStyle,
    YHChartCircleStyle
} YHChartStyle;

//动画样式
typedef enum{
    YHChartAnimateNone,
    YHChartAnimateNormal
} YHCHartAnimateStyle;

//范围
typedef struct _YHRange {
    CGFloat max;
    CGFloat min;
} YHRange;

//typedef YHRange *YHRangePointer;

NS_INLINE YHRange YHMakeRange(CGFloat max, CGFloat min) {
    YHRange r;
    r.max = max;
    r.min = min;
    return r;
}

static const YHRange CGRangeZero = {0,0};


#define Line_Default_XUnitsLength           40.0
#define Line_Default_YUnitsLength           40.0
#define Line_Default_HasAxis                YES
#define Line_Default_HasHorizontalGird      YES
#define Line_Default_HasVerticalGird        YES
#define Line_Default_HasTrendShadow         YES
#define Line_Default_TrendLineWidth         1.0
#define Line_Default_AxisLineWidth          1.0
#define Line_Default_GirdLineWidth          0.5
#define Line_Default_AxisColor              kYH_Color_RGBA(0, 0, 0, 1)
#define Line_Default_GirdColor              kYH_Color_RGBA(0, 0, 0, 0.1)
#define Line_Default_TrendLineColor         kYH_Color_RGBA(0, 0, 0, 1)
#define Line_Default_TrendShadowColor       kYH_Color_RGBA(0, 0, 0, 0.5)
#define Line_Default_XLabelColor            kYH_Color_RGBA(0, 0, 0, 1)
#define Line_Default_YLabelColor            kYH_Color_RGBA(0, 0, 0, 1)
#define Line_Default_XLabelFont             kYH_Font_Normal(12)
#define Line_Default_YLabelFont             kYH_Font_Normal(12)
#define Line_Default_XLabelHeigh            40.0
#define Line_Default_YLabelWidth            60.0

#endif
