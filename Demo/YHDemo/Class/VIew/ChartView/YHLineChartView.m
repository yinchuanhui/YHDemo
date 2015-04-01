//
//  YHLineChartView.m
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHLineChartView.h"

@interface YHLineChartView ()

@property (nonatomic, retain)CAShapeLayer *xAxisLayer;
@property (nonatomic, retain)CAShapeLayer *yAxisLayer;
@property (nonatomic, retain)NSMutableArray *horizontalGirdLayerArray;
@property (nonatomic, retain)NSMutableArray *verticalGirdLayerArray;
@property (nonatomic, retain)NSMutableArray *yLabelArray;
@property (nonatomic, retain)NSMutableArray *xLabelArray;
@property (nonatomic, retain)CAShapeLayer *trendLineLayer;
@property (nonatomic, assign)int yUnitsCount;
@property (nonatomic, assign)BOOL yValuesIsTitle;//y坐标显示数组还是标题

@end

@implementation YHLineChartView

- (void)strokeChart{
    [self strokeAxis];
    
    if (self.hasHorizontalGird) {
        if (self.yValuesIsTitle) {
            [self strokeHorizontalGirdLineWithCount:self.yValues.count beginY:self.frame.size.height-self.xLabelHeigh];
        }else{
            if (self.yRange.min >= 0) {
                self.yUnitsCount = (int)floorf((self.frame.size.height-self.xLabelHeigh)/self.yUnitsLength);
                [self setYLabel];
                [self strokeHorizontalGirdLineWithCount:self.yUnitsCount+1 beginY:self.frame.size.height-self.xLabelHeigh];
            }else{
                
            }
        }
    }
    
    if (self.hasVerticalGird) {
        [self setXLabel];
        int xUnitsMaxCount = (int)floorf((self.frame.size.width-self.yLabelWidth)/self.xUnitsLength)+1;
        [self strokeVerticalGirdLineWithCount:xUnitsMaxCount beginX:self.yLabelWidth];
    }
    
    [self strokeTrendLine];
    
    [self configAnimate];
}

#pragma mark Private Method

//绘制坐标轴
- (void)strokeAxis{
    if (self.hasAxis) {
        self.xAxisLayer = [CAShapeLayer layer];
        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(self.yLabelWidth, self.frame.size.height-self.xLabelHeigh)];
        [xPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-self.xLabelHeigh)];
        [xPath closePath];
        self.xAxisLayer.path = xPath.CGPath;
        self.xAxisLayer.strokeColor = self.axisColor.CGColor;
        self.xAxisLayer.lineWidth = self.axisLineWidth;
        self.xAxisLayer.lineJoin = kCALineJoinRound;
        self.xAxisLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:self.xAxisLayer];
        
        self.yAxisLayer = [CAShapeLayer layer];
        UIBezierPath *yPath = [UIBezierPath bezierPath];
        [yPath moveToPoint:CGPointMake(self.yLabelWidth, self.frame.size.height-self.xLabelHeigh)];
        [yPath addLineToPoint:CGPointMake(self.yLabelWidth, 0)];
        [yPath closePath];
        self.yAxisLayer.path = yPath.CGPath;
        self.yAxisLayer.strokeColor = self.axisColor.CGColor;
        self.yAxisLayer.lineWidth = self.axisLineWidth;
        self.yAxisLayer.lineJoin = kCALineJoinRound;
        self.yAxisLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:self.yAxisLayer];
    }
}

//绘制横向网格线， beginY为第一条线的y坐标
- (void)strokeHorizontalGirdLineWithCount:(NSInteger)lineCount beginY:(CGFloat)y{
    for (int i = 0; i < lineCount; i++) {
        if (!self.horizontalGirdLayerArray) {
            self.horizontalGirdLayerArray = [NSMutableArray arrayWithCapacity:0];
        }
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat dashStyle[] = {5,5};
        [path setLineDash:dashStyle count:2 phase:0];
        [path moveToPoint:CGPointMake(self.yLabelWidth, y-(i*self.yUnitsLength))];
        [path addLineToPoint:CGPointMake(self.frame.size.width, y-(i*self.yUnitsLength))];
        layer.path = path.CGPath;
        layer.strokeColor = self.girdColor.CGColor;
        layer.lineWidth = self.girdLineWidth;
        layer.lineJoin = kCALineJoinRound;
        layer.lineCap = kCALineCapRound;
//        [layer setLineDashPattern:@{5, 5}];
        [self.layer addSublayer:layer];
        [self.horizontalGirdLayerArray addObject:layer];
    }
}

//绘制横向网格线， beginY为第一条线的y坐标
- (void)strokeVerticalGirdLineWithCount:(NSInteger)lineCount beginX:(CGFloat)x{
    for (int i = 0; i < lineCount; i++) {
        if (!self.verticalGirdLayerArray) {
            self.verticalGirdLayerArray = [NSMutableArray arrayWithCapacity:0];
        }
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(x+(i*self.xUnitsLength), self.frame.size.height-self.xLabelHeigh)];
        [path addLineToPoint:CGPointMake(x+(i*self.xUnitsLength), 0)];
        layer.path = path.CGPath;
        layer.strokeColor = self.girdColor.CGColor;
        layer.lineWidth = self.girdLineWidth;
        layer.lineJoin = kCALineJoinRound;
        layer.lineCap = kCALineCapRound;
        [self.layer addSublayer:layer];
        [self.verticalGirdLayerArray addObject:layer];
    }
}

//绘制曲线
- (void)strokeTrendLine{
    self.trendLineLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[self computePointwithYValuesIndex:0]];
    
    for (int i = 1; i < self.yValues.count; i++) {
        [path addLineToPoint:[self computePointwithYValuesIndex:i]];
    }
    self.trendLineLayer.path = path.CGPath;
    self.trendLineLayer.strokeColor = self.trendLineColor.CGColor;
    self.trendLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.trendLineLayer.lineWidth = self.trendLineWidth;
    self.trendLineLayer.lineJoin = kCALineJoinRound;
    self.trendLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:self.trendLineLayer];
}

- (void)setXLabel{
    for (int i = 0; i < self.xValues.count; i++) {
        if (!self.xLabelArray) {
            self.xLabelArray = [NSMutableArray arrayWithCapacity:0];
        }
        UILabel *xLabel = [[UILabel alloc] init];
        [xLabel setNumberOfLines:1];
        [xLabel setFont:self.xLabelFont];
        [xLabel setTextColor:self.xLabelColor];
        [xLabel setBackgroundColor:[UIColor clearColor]];
        [xLabel setTextAlignment:NSTextAlignmentCenter];
        [xLabel setText:[self.xValues objectAtIndex:i]];
        if (i == 0) {
            CGFloat labelWidth = self.xUnitsLength/2;
            [xLabel setTextAlignment:NSTextAlignmentLeft];
            xLabel.frame = CGRectIntegral(CGRectMake(self.yLabelWidth, self.frame.size.height-self.xLabelHeigh, labelWidth, self.xLabelHeigh));
        }else{
            xLabel.frame = CGRectIntegral(CGRectMake(self.yLabelWidth + i*self.xUnitsLength - self.xUnitsLength/2, self.frame.size.height-self.xLabelHeigh, self.xUnitsLength, self.xLabelHeigh));
        }
        [self addSubview:xLabel];
        [self.xLabelArray addObject:xLabel];
    }
}

- (void)setYLabel{
    CGFloat level = (self.yRange.max - self.yRange.min)/self.yUnitsCount;
    for (int i = 0; i <= self.yUnitsCount; i++) {
        if (!self.yLabelArray) {
            self.yLabelArray = [NSMutableArray arrayWithCapacity:0];
        }
        UILabel *yLabel = [[UILabel alloc] init];
        [yLabel setNumberOfLines:1];
        [yLabel setFont:self.yLabelFont];
        [yLabel setTextColor: self.yLabelColor];
        [yLabel setBackgroundColor:[UIColor clearColor]];
        [yLabel setTextAlignment:NSTextAlignmentCenter];
        if (level>2) {
            [yLabel setText:[NSString stringWithFormat:@"%d", (int)round(self.yRange.min+level*i)]];
        }else{
            [yLabel setText:[NSString stringWithFormat:@"%.2lf", self.yRange.min+level*i]];
        }
        [self addSubview:yLabel];
        if (i == 0) {
            yLabel.frame = CGRectIntegral(CGRectMake(0, self.frame.size.height-self.xLabelHeigh-self.yLabelFont.lineHeight, self.yLabelWidth, self.yLabelFont.lineHeight));
        }else{
            yLabel.frame = CGRectIntegral(CGRectMake(0, self.frame.size.height-self.xLabelHeigh-self.yLabelFont.lineHeight/2-self.yUnitsLength*i, self.yLabelWidth, self.yLabelFont.lineHeight));
        }
        [self.yLabelArray addObject:yLabel];
    }
}

- (void)configAnimate{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.animateTime/2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];;
    [self.xAxisLayer addAnimation:pathAnimation forKey:@"X_AxixStrokeEndAnimation"];
    [self.yAxisLayer addAnimation:pathAnimation forKey:@"Y_AxixStrokeEndAnimation"];
    
    for (int i = 0 ; i < self.horizontalGirdLayerArray.count; i++) {
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animate.duration = self.animateTime/2 + self.animateTime/2*((double)i/self.horizontalGirdLayerArray.count);
        animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animate.fromValue = [NSNumber numberWithFloat:0.0f];
        animate.toValue = [NSNumber numberWithFloat:1.0f];
        [[self.horizontalGirdLayerArray objectAtIndex:i] addAnimation:animate forKey:[NSString stringWithFormat:@"H_GridLineStrokeEndAnimation_%d", i]];
    }
    
    for (int i = 0 ; i < self.verticalGirdLayerArray.count; i++) {
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animate.duration = self.animateTime/2 + self.animateTime/2*((double)i/self.verticalGirdLayerArray.count);
        animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animate.fromValue = [NSNumber numberWithFloat:0.0f];
        animate.toValue = [NSNumber numberWithFloat:1.0f];
        [[self.verticalGirdLayerArray objectAtIndex:i] addAnimation:animate forKey:[NSString stringWithFormat:@"V_GridLineStrokeEndAnimation_%d", i]];
    }
    
    CABasicAnimation *trendAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    trendAnimation.duration = self.animateTime;
    trendAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    trendAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    trendAnimation.toValue = [NSNumber numberWithFloat:1.0f];;
    [self.trendLineLayer addAnimation:trendAnimation forKey:@"TrendStrokeEndAnimation"];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.duration = self.animateTime;
    for (int i = 0; i < self.yLabelArray.count; i++) {
        UILabel *label = (UILabel *)[self.yLabelArray objectAtIndex:i];
        [label.layer addAnimation:opacityAnimation forKey:@"YLabelOpacityAnimation"];
    }
    for (int i = 0; i < self.xLabelArray.count; i++) {
        UILabel *label = (UILabel *)[self.xLabelArray objectAtIndex:i];
        [label.layer addAnimation:opacityAnimation forKey:@"XLabelOpacityAnimation"];
    }
}

- (YHRange)computeYRangeWithYValues:(NSArray *)yValues{
    CGFloat max = 0;
    CGFloat min = 0;
    CGFloat y = 0;
    for (int i = 0; i < yValues.count; i++) {
        NSString *s = kYH_Safe_String([yValues objectAtIndex:i]);
        NSScanner *scanner = [NSScanner scannerWithString:s];
        //判断是数字还是标题
        if ([scanner scanDouble:&y] && [scanner isAtEnd]) {
            if (i == 0) {
                max = y;
                min = y;
            }
            if (y > max) {
                max = y;
            }
            if (y < min) {
                min = y;
            }
        }else{
            self.yValuesIsTitle = YES;
            return YHMakeRange(0, 0);
        }
    }
    //根据y坐标单位数确定显示范围：1.单位值大于2显示int 2.单位值小于2显示float
    CGFloat yUnitsMaxCount = floor((self.frame.size.height-self.xLabelHeigh)/self.yUnitsLength)+1.0;
    CGFloat level = (max - min)/yUnitsMaxCount;
    if (level >= 2) {
        //min小于0时有问题，先临时解决设置min最小为0
        int minRange = (int)floor(min-level/2);
        minRange = minRange<0?0:minRange;
        return YHMakeRange((int)ceil(max+level/2), minRange);
    }else{
        return YHMakeRange(ceil(max+level/2), floor(min-level/2));
    }
}

- (CGPoint)computePointwithYValuesIndex:(NSInteger)index{
    //y坐标计算：根据y值在显示范围中的占比来确定y坐标，并且需要加上y轴中不在显示范围中线的高度
    return CGPointMake(self.yLabelWidth+self.xUnitsLength*index, (self.yRange.max-[[self.yValues objectAtIndex:index] floatValue])/(self.yRange.max-self.yRange.min)*self.yUnitsCount*self.yUnitsLength + (self.frame.size.height-self.xLabelHeigh-self.yUnitsCount*self.yUnitsLength));
}

@end
