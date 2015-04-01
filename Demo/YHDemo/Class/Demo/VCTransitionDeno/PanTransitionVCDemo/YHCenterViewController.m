//
//  YHCenterViewController.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHCenterViewController.h"
#import "YHReadMeViewController.h"

@interface YHCenterViewController ()

@end

@implementation YHCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kYH_Color_RGBA(71, 119, 175, 1.0);
    
    [self configNavigationItemTitle:@"Show left" normalImageName:nil highlightedImageName:nil position:BarItemPositionLeft action:@selector(showLeft)];
    [self configNavigationItemTitle:@"Read me" normalImageName:nil highlightedImageName:nil position:BarItemPositionRight action:@selector(readMe)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - Private Method

- (void)readMe{
    YHReadMeViewController *readMeVC = [[YHReadMeViewController alloc] initWithReadMeFile:@"Read me"];
    [kYH_RootNav pushViewController:readMeVC animated:YES];
}

- (void)showLeft{
#ifdef kYHPanTransitionViewController
    [kYH_RootVC showLeftView];
#endif
}

@end
