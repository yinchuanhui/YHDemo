//
//  YHPerformanceDemo1ViewController.m
//  YHDemo
//
//  Created by ych on 15/4/7.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHPerformanceDemo1ViewController.h"

@interface YHPerformanceDemo1ViewController ()

@property (nonatomic, retain)UIScrollView *scrollView;

@end

@implementation YHPerformanceDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(kYH_ScreenWidth, 5000);
    [self.view addSubview:self.scrollView];
    
    for (int i = 1; i <= 14; i++) {
        [self addImageViewWithName:[NSString stringWithFormat:@"performance_demo_image_%d", i] containerView:self.scrollView];
    }
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

- (UIImageView *)addImageViewWithName:(NSString *)imageName containerView:(UIView *)containerView{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (containerView == self.scrollView) {
        imageView.frame = CGRectMake(20, [self getLastViewBottom], image.size.width, image.size.height);
    }else{
        imageView.frame = CGRectMake(20, 20, image.size.width, image.size.height);
    }
    
    [containerView addSubview:imageView];
    return imageView;
}

//获取最后视图或图层的bottom坐标
- (CGFloat)getLastViewBottom{
    NSArray *views = self.scrollView.subviews;
    UIView *lastView = [views lastObject];
    CGFloat lastViewBotton = lastView.frame.origin.y + lastView.frame.size.height;
    
    NSArray *layers = self.scrollView.layer.sublayers;
    CALayer *lastLayer = [layers lastObject];
    CGFloat lastLayerBottom = lastLayer.frame.origin.y + lastLayer.frame.size.height;
    
    return lastViewBotton>lastLayerBottom?lastViewBotton:lastLayerBottom;
}

@end
