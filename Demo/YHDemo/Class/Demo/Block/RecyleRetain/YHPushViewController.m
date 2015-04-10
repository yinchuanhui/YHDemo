//
//  YHPushViewController.m
//  YHDemo
//
//  Created by ych on 15/1/19.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHPushViewController.h"
#import "YHAAAA.h"

@interface YHPushViewController (){
    UIButton *b;
}

@end

@implementation YHPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    b = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 50)];
    b.backgroundColor = [UIColor grayColor];
    [b setTitle:@"Pop" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
#warning 注意观察此方法是否调用
    NSLog(@"PushVC dealloc!!!");
}

- (void)pushAction{
#warning 这里造成了循环引用:block中引用到self，a又retain了该block的一根拷贝。a是单例，pop后并没有被释放导致self的dealloc方法未调用，造成内存泄漏。可使用下面两种方法解决
    YHAAAA *a = [YHAAAA sharedInstance];
    [a requestWithBlock:^{
        self.view.backgroundColor = [UIColor blackColor];
    }];
    
    /*方法1
    YHAAAA *a = [[YHAAAA alloc] init];
    [a requestWithBlock:^{
        self.view.backgroundColor = [UIColor blackColor];
    }];
     */
    
    /*方法2
    __unsafe_unretained YHPushViewController *weakSelf = self;  //ios4下不支持arc则用__unsafe_unretained
    //如果是non-ARC环境下就将__weak替换为__block即可。non-ARC情况下，__block变量的含义是在Block中引入一个新的结构体成员变量指向这个__block变量，那么__block typeof(self) weakSelf = self;就表示Block别再对self对象retain啦，这就打破了循环引用。（未验证）
    __weak YHPushViewController *weakSelf = self;
    __weak typeof(self) weakSelf = self;
    YHAAAA *a = [YHAAAA sharedInstance];
    [a requestWithBlock:^{
        weakSelf.view.backgroundColor = [UIColor blackColor];
    }];
    */
    
    [self.navigationController popViewControllerAnimated:YES];
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
