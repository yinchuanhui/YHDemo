//
//  YHCircleProgressDemo1ViewController.m
//  YHDemo
//
//  Created by ych on 15/3/12.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHCircleProgressDemo1ViewController.h"
#import "YHCircleProgressView_1.h"

@interface YHCircleProgressDemo1ViewController (){
    UIButton *animateButton;
    UIView *animateView;
    YHCircleProgressView_1 *progressView;
    UISlider *slider;
}

@end

@implementation YHCircleProgressDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //    annulusBorderWidth;//外层圆环线条宽度 默认：1.0
    //    @property (nonatomic, assign)UIColor *annulusBorderCorlor;//外层圆环线条颜色 默认：0xffffff
    //    @property (nonatomic, assign)CGFloat progressRadius;//圆形进度条半径 默认：根据视图大小设置
    //    @property (nonatomic, retain)UIColor *progressBgColor;//圆形进度条背景颜色 默认：0xffffff
    //    @property (nonatomic, assign)CGFloat progressStrokeWidth;//圆形进度条已加载部分线条宽度 默认：1.0
    //    @property (nonatomic, retain)UIColor *progressStrokeColor;//圆形进度条已加载部分线条颜色 默认：0x73B4F5
    //    @property (nonatomic, retain)UIColor *progressFillColor;//圆形进度条已加载部分填充色 默认：0x73B4F5
    //    @property (nonatomic, retain)UIColor *completeMarkStrokeColor;//完成标记颜色 默认：0x757575
    //    @property (nonatomic, retain)NSMutableArray *completeMarkPoints;
    
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view, typically from a nib.
    progressView = [[YHCircleProgressView_1 alloc] initWithFrame:CGRectMake(100, 200, 23, 23)];
    //    progressView.progressFillColor = [UIColor redColor];
    //    progressView.annulusBorderCorlor = [UIColor blackColor];
    //    progressView.progressRadius = 5;
    //    progressView.progressBgColor = [UIColor yellowColor];
    //    progressView.progressStrokeWidth = 3;
    //    progressView.completeMarkStrokeColor = [UIColor blueColor];
    //    progressView.completeMarkPoints = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(8.5, 12)],[NSValue valueWithCGPoint:CGPointMake(20, 40)],[NSValue valueWithCGPoint:CGPointMake(35, 10)], nil];
    [progressView updateConfig];
    
    [self.view addSubview:progressView];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 160, 200, 20)];
    slider.minimumValue = 0;
    slider.maximumValue = 1.0;
    slider.value = 0.0;
    [slider addTarget:self action:@selector(updateValue) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    //    double delayInSeconds1 = 1.0;
    //    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
    //    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
    //        [progressView updateProgress:1.0];
    //    });
    //    double delayInSeconds2 = 2.0;
    //    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
    //    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
    //        [progressView updateProgress:0.3];
    //    });
    //    double delayInSeconds3 = 3.0;
    //    dispatch_time_t popTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds3 * NSEC_PER_SEC));
    //    dispatch_after(popTime3, dispatch_get_main_queue(), ^(void){
    //        [progressView updateProgress:0.6];
    //    });
    //    double delayInSeconds4 = 4.0;
    //    dispatch_time_t popTime4 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds4 * NSEC_PER_SEC));
    //    dispatch_after(popTime4, dispatch_get_main_queue(), ^(void){
    //        [progressView updateProgress:0.5];
    //    });
    //    double delayInSeconds5 = 5.0;
    //    dispatch_time_t popTime5 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds5 * NSEC_PER_SEC));
    //    dispatch_after(popTime5, dispatch_get_main_queue(), ^(void){
    //        [progressView updateProgress:.9];
    //    });
    //    double delayInSeconds = 2.0;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        for (int i = 0; i<1000; i++) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    ////                double delayInSeconds5 = .001*i;
    ////                dispatch_time_t popTime5 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds5 * NSEC_PER_SEC));
    ////                dispatch_after(popTime5, dispatch_get_main_queue(), ^(void){
    //                    [progressView updateProgress:0.001*i];
    ////                });
    //            });
    //
    //        }
    //    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateValue{
    [progressView updateProgress:slider.value];
}

@end
