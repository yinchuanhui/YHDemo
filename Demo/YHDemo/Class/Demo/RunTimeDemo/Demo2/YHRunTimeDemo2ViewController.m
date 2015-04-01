//
//  YHRunTimeDemo2ViewController.m
//  YHDemo
//
//  Created by ych on 14/11/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHRunTimeDemo2ViewController.h"
#import "TestModel.h"

@interface YHRunTimeDemo2ViewController ()

@end

@implementation YHRunTimeDemo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestModel *model = [[TestModel alloc] init];
    model.name = @"name";
    model.auther = @"auther";
    model.version = @"1.0.0";
    NSLog(@"%@", model.name);
    NSLog(@"%@", model.auther);
    NSLog(@"%@", model.version);
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

@end
