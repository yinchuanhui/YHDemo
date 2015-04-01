//
//  YHChartView.m
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHChartView.h"
#import "YHBaseChartView.h"
#import "YHLineChartView.h"
#import "YHBarChartView.h"
#import "YHCircleChartView.h"

@interface YHChartView ()

@property (nonatomic, assign)YHChartStyle _chartStyle;
@property (nonatomic, strong)YHBaseChartView *_chartView;
/*
@property (nonatomic, strong)YHLineChartView *_lineChartView;
@property (nonatomic, strong)YHBarChartView *_barChartView;
@property (nonatomic, strong)YHCircleChartView *_circleChartView;
 */

@end

@implementation YHChartView

- (id)initWithFrame:(CGRect)frame style:(YHChartStyle)style{
    __chartStyle = style;
    return [self initWithFrame:frame];
}

- (void)show{
    [self configChart];
}

- (void)changeStyle:(YHChartStyle)style{
    if (style == __chartStyle) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    BackflowCompleteBlock completeBlock = ^{
        weakSelf._chartStyle = style;
        [weakSelf configChart];
    };
    
    //隐藏图表，动画结束后显示新图表
    [__chartView backflowWithAnimate:YES completeBlock:^{
        completeBlock();
    }];
}

#pragma Private Method

- (void)configChart{
    if (!self.dataSource) {
        return;
    }
    
    /*
    if (__chartStyle == YHChartLineStyle) {
        if(!__lineChartView){
            __lineChartView = [[YHLineChartView alloc] initWithFrame:self.bounds];
            [self addSubview:__lineChartView];
        }
        self._currentChartView = __lineChartView;
    }else if(__chartStyle == YHChartBarStyle){
        if(!_barChartView){
            _barChartView = [[YHBarChartView alloc] initWithFrame:self.bounds];
            [self addSubview:_barChartView];
        }
        self._currentChartView = _barChartView;
    }else if(__chartStyle == YHChartCircleStyle){
        if(!__circleChartView){
            __circleChartView = [[YHCircleChartView alloc] initWithFrame:self.bounds];
            [self addSubview:__circleChartView];
        }
        self._currentChartView = __circleChartView;
    }*/
    if (__chartStyle == YHChartLineStyle) {
        YHLineChartView *lineChartView = [[YHLineChartView alloc] initWithFrame:self.bounds];
        __chartView = lineChartView;
        [self configLineChart:lineChartView];
    }else if(__chartStyle == YHChartBarStyle){
        YHBarChartView *barChartView = [[YHBarChartView alloc] initWithFrame:self.bounds];
        __chartView = barChartView;
        [self configBarChart:barChartView];
    }else if(__chartStyle == YHChartCircleStyle){
        YHCircleChartView *circleChartView = [[YHCircleChartView alloc] initWithFrame:self.bounds];
        __chartView = circleChartView;
        [self configCircleChart:circleChartView];
    }
    
    [self addSubview:__chartView];
    [__chartView strokeChart];
}

- (void)configLineChart:(YHLineChartView *)lineChartView{
    lineChartView.xValues = [self.dataSource chartViewXValue:self];
    lineChartView.yValues = [self.dataSource chartViewYValue:self];
    lineChartView.animateTime = [self.dataSource chartViewAnimateTime:self];
    
    if ([self.dataSource respondsToSelector:@selector(chartViewAnimateStyle:)]) {
        lineChartView.animateStyle = [self.dataSource chartViewAnimateStyle:self];
    }else{
        lineChartView.animateStyle = YHChartAnimateNormal;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewXUnitsLength:)]) {
        lineChartView.xUnitsLength = [self.dataSource chartViewXUnitsLength:self];
    }else{
        lineChartView.xUnitsLength = Line_Default_XUnitsLength;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewYUnitsLength:)]) {
        lineChartView.yUnitsLength = [self.dataSource chartViewYUnitsLength:self];
    }else{
        lineChartView.yUnitsLength = Line_Default_YUnitsLength;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewYRange:)]) {
        lineChartView.yRange = [self.dataSource chartViewYRange:self];
    }else{
        lineChartView.yRange = [lineChartView computeYRangeWithYValues:lineChartView.yValues];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewHasTrendShadow:)]) {
        lineChartView.hasTrendShadow = [self.dataSource chartViewHasTrendShadow:self];
    }else{
        lineChartView.hasTrendShadow = Line_Default_HasTrendShadow;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewTrendLineWidth:)]) {
        lineChartView.trendLineWidth = [self.dataSource chartViewTrendLineWidth:self];
    }else{
        lineChartView.trendLineWidth = Line_Default_TrendLineWidth;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewTrendLineColor:)]) {
        lineChartView.trendLineColor = [self.dataSource chartViewTrendLineColor:self];
    }else{
        lineChartView.trendLineColor = Line_Default_TrendLineColor;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewTrendShadowColor:)]) {
        lineChartView.trendShadowColor = [self.dataSource chartViewTrendShadowColor:self];
    }else{
        lineChartView.trendShadowColor = Line_Default_TrendShadowColor;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewHasAxis:)]) {
        lineChartView.hasAxis = [self.dataSource chartViewHasAxis:self];
    }else{
        lineChartView.hasAxis = Line_Default_HasAxis;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewHasHorizontalGird:)]) {
        lineChartView.hasHorizontalGird = [self.dataSource chartViewHasHorizontalGird:self];
    }else{
        lineChartView.hasHorizontalGird = Line_Default_HasHorizontalGird;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewHasVerticalGird:)]) {
        lineChartView.hasVerticalGird = [self.dataSource chartViewHasVerticalGird:self];
    }else{
        lineChartView.hasVerticalGird = Line_Default_HasVerticalGird;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewAxisLineWidth:)]) {
        lineChartView.axisLineWidth = [self.dataSource chartViewAxisLineWidth:self];
    }else{
        lineChartView.axisLineWidth = Line_Default_AxisLineWidth;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewGirdLineWidth:)]) {
        lineChartView.girdLineWidth = [self.dataSource chartViewGirdLineWidth:self];
    }else{
        lineChartView.girdLineWidth = Line_Default_GirdLineWidth;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewAxisColor:)]) {
        lineChartView.axisColor = [self.dataSource chartViewAxisColor:self];
    }else{
        lineChartView.axisColor = Line_Default_AxisColor;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewGirdColor:)]) {
        lineChartView.girdColor = [self.dataSource chartViewGirdColor:self];
    }else{
        lineChartView.girdColor = Line_Default_GirdColor;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewXLabelColor:)]) {
        lineChartView.xLabelColor = [self.dataSource chartViewXLabelColor:self];
    }else{
        lineChartView.xLabelColor = Line_Default_XLabelColor;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewYLabelColor:)]) {
        lineChartView.yLabelColor = [self.dataSource chartViewYLabelColor:self];
    }else{
        lineChartView.yLabelColor = Line_Default_YLabelColor;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewXLabelFont:)]) {
        lineChartView.xLabelFont = [self.dataSource chartViewXLabelFont:self];
    }else{
        lineChartView.xLabelFont = Line_Default_XLabelFont;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewYLabelFont:)]) {
        lineChartView.yLabelFont = [self.dataSource chartViewYLabelFont:self];
    }else{
        lineChartView.yLabelFont = Line_Default_YLabelFont;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewXLabelFont:)]) {
        UIFont *font = [self.dataSource chartViewXLabelFont:self];
        lineChartView.xLabelHeigh = font.lineHeight;
    }else{
        lineChartView.xLabelHeigh = Line_Default_XLabelHeigh;
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewYLabelWidth:)]) {
        lineChartView.yLabelWidth = [self.dataSource chartViewYLabelWidth:self];
    }else{
        lineChartView.yLabelWidth = Line_Default_YLabelWidth;
    }
}

- (void)configBarChart:(YHBarChartView *)barChartView{

}

- (void)configCircleChart:(YHCircleChartView *)circleChartView{

}

@end
