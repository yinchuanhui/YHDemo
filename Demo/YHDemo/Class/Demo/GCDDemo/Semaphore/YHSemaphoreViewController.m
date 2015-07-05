//
//  YHSemaphoreViewController.m
//  YHDemo
//
//  Created by ych on 15/5/8.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHSemaphoreViewController.h"
#import "YHConcurrentManager.h"

@interface YHSemaphoreViewController ()

@end

@implementation YHSemaphoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YHConcurrentManager *concurrentManager = [[YHConcurrentManager alloc] init];
    for (int i  = 0; i < 100; i++) {
        [concurrentManager doSomething];
    }
    NSLog(@"over");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
