//
//  YHChartTableViewCell.m
//  YHDemo
//
//  Created by ych on 15/3/13.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHChartTableViewCell.h"
#import "YHChartView.h"

@interface YHChartTableViewCell()<YHChartViewDataSource>

@property (nonatomic, strong)YHChartView *_chartView;
@property (nonatomic, strong)NSIndexPath *_path;

@end

@implementation YHChartTableViewCell

- (void)configUI:(NSIndexPath *)indexPath
{
    if (__chartView) {
        [__chartView removeFromSuperview];
        __chartView = nil;
    }
    
    __path = indexPath;
    
    
    YHChartStyle style = YHChartLineStyle;
    if (indexPath.row == 0) {
        style = YHChartLineStyle;
    }
    
    __chartView = [[YHChartView alloc] initWithFrame:CGRectMake(10, 10, kYH_ScreenWidth-20, self.frame.size.height) style:style];
    __chartView.dataSource = self;
    [self addSubview:__chartView];
    [__chartView show];
}


#pragma mark - YHChartViewDataSource
- (NSArray *)chartViewXValue:(YHChartView *)chartView{
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18"];
}

- (NSArray *)chartViewYValue:(YHChartView *)chartView{
    return @[@"20",@"5",@"8",@"35",@"22",@"44", @"18",@"30",@"60",@"30",@"10",@"30", @"20",@"10",@"1",@"60",@"20",@"30"];
}

- (CGFloat)chartViewAnimateTime:(YHChartView *)chartView{
    return 2.0;
}

- (YHCHartAnimateStyle)chartViewAnimateStyle:(YHChartView *)chartView{
    return YHChartAnimateNormal;
}

- (UIColor *)chartViewGirdColor:(YHChartView *)chartView{
    return kYH_Color_RGBA(95, 147, 196, 0.5);
}

- (UIColor *)chartViewTrendLineColor:(YHChartView *)chartView{
    return [[UIColor orangeColor] colorWithAlphaComponent:1.0];
}

- (CGFloat)chartViewGirdLineWidth:(YHChartView *)chartView{
    return 0.5;
}


- (NSArray *)chartViewColors:(YHChartView *)chartView{
    return @[kYH_Color_RGBA(77, 186, 122, 1.0), kYH_Color_RGBA(95, 147, 196, 1.0), kYH_Color_RGBA(77, 186, 122, 1.0), kYH_Color_RGBA(95, 147, 196, 1.0), kYH_Color_RGBA(77, 186, 122, 1.0), kYH_Color_RGBA(95, 147, 196, 1.0)];
}

//- (YHRange)chartViewYRange:(YHChartView *)chartView{
//    return YHMakeRange(50, 10);
//}

@end
