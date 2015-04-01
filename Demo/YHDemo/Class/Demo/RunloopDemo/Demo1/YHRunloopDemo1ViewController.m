//
//  YHRunloopDemo1ViewController.m
//  YHDemo
//
//  Created by ych on 14-10-16.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHRunloopDemo1ViewController.h"
#import "YHReadMeViewController.h"

@interface YHRunloopDemo1ViewController ()

@end

@implementation YHRunloopDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 120, 50)];
    [button1 setTitle:@"normal thread" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor grayColor]];
    [button1 addTarget:self action:@selector(buttonNormalThreadTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(140, 100, 80, 50)];
    [button2 setTitle:@"runloop" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [button2 addTarget:self action:@selector(buttonRunloopPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(230, 100, 80, 50)];
    [button3 setTitle:@"test" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setBackgroundColor:[UIColor grayColor]];
    [button3 addTarget:self action:@selector(buttonTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




BOOL threadProcess1Finished =NO;

-(void)threadProce1{
    
    NSLog(@"Enter threadProce1.");
    
    for (int i=0; i<5;i++) {
        NSLog(@"InthreadProce1 count = %d.", i);
        sleep(1);
    }
    
    threadProcess1Finished =YES;

    NSLog(@"Exit threadProce1.");
}

BOOL threadProcess2Finished =NO;

-(void)threadProce2{
    
    NSLog(@"Enter threadProce2.");
    
    for (int i=0; i<5;i++) {
        NSLog(@"InthreadProce2 count = %d.", i);
        sleep(1);
    }
    threadProcess2Finished =YES;
    
    NSLog(@"Exit threadProce2.");
    
    
    //buttonRunloopPressed中while循环后执行的语句会在很长时间后才被执行。因为，改变变量threadProcess1Finished的值，runloop对象根本不知道，runloop在这个时候未被唤醒。有其他事件在某个时点唤醒了主线程，这才结束了while循环，但延缓的时长总是不定的。改为向主线程发送消息，唤醒runloop，延时问题解决。
    [self performSelectorOnMainThread: @selector(setEnd)
     
                           withObject: nil
     
                        waitUntilDone: NO];
    
}

-(void)setEnd{
    
    threadProcess2Finished = YES;
    
}

- (IBAction)buttonNormalThreadTestPressed:(UIButton *)sender {
    
    NSLog(@"EnterbuttonNormalThreadTestPressed");
    
    threadProcess1Finished =NO;
    
    NSLog(@"Start a new thread.");
    
    [NSThread detachNewThreadSelector: @selector(threadProce1)
                            toTarget: self
                          withObject: nil];
    
    // 通常等待线程处理完后再继续操作的代码如下面的形式。
    // 在等待线程threadProce1结束之前，调用buttonTestPressed，界面没有响应，直到threadProce1运行完，才打印buttonTestPressed里面的日志。
    while (!threadProcess1Finished) {
        [NSThread sleepForTimeInterval: 1];
    }
    
    NSLog(@"ExitbuttonNormalThreadTestPressed");
}

- (IBAction)buttonRunloopPressed:(id)sender {
    
    NSLog(@"Enter buttonRunloopPressed");
    threadProcess2Finished =NO;
    NSLog(@"Start a new thread.");
    
    [NSThread detachNewThreadSelector: @selector(threadProce2)
                            toTarget: self
                          withObject: nil];
    
#pragma mark - Demo重点
    
    // 使用runloop，情况就不一样了。
    // 在等待线程threadProce2结束之前，调用buttonTestPressed，界面立马响应，并打印buttonTestPressed里面的日志。
    // 这就是runloop的神奇所在
    while (!threadProcess2Finished) {
        NSLog(@"Begin runloop");
        //通过断点、日志可以看出，执行下面代码后程序会挂起，在[NSDate distantFuture]到期或用户触摸屏幕后才会继续执行
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                beforeDate: [NSDate distantFuture]];
        NSLog(@"End runloop.");
    }
    NSLog(@"Exit buttonRunloopPressed");
}

- (IBAction)buttonTestPressed:(id)sender{
    NSLog(@"Enter buttonTestPressed");
    NSLog(@"Exit buttonTestPressed");
}

@end
