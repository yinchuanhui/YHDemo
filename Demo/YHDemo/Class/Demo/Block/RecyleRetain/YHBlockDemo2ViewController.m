//
//  YHBlockDemo2ViewController.m
//  YHDemo
//
//  Created by ych on 15/4/9.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHBlockDemo2ViewController.h"
#import "YHPushViewController.h"

@interface YHBlockDemo2ViewController ()

@end

@implementation YHBlockDemo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    b.backgroundColor = [UIColor grayColor];
    [b setTitle:@"Push" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushAction{
    YHPushViewController *pushVC = [[YHPushViewController alloc] init];
    [self.navigationController pushViewController:pushVC animated:YES];
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
