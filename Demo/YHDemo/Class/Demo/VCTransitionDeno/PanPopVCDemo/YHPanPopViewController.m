//
//  YHPanPopViewController.m
//  YHDemo
//
//  Created by ych on 14-10-17.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHPanPopViewController.h"

@interface YHPanPopViewController ()

@end

@implementation YHPanPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 70)];
    b.backgroundColor = [UIColor grayColor];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)push{
#ifdef kYHPopWithPanNavigationController
    [kYH_RootVC pushViewController:[[YHPanPopViewController alloc] init] animated:YES];
#endif
}

@end
