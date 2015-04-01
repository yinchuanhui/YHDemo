//
//  YHRunloopDemo4ViewController.m
//  YHDemo
//
//  Created by ych on 14-10-23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHRunloopDemo4ViewController.h"
#import "YHWorkThread.h"

@interface YHRunloopDemo4ViewController (){
    NSPort *distantPort;
}

@end

@implementation YHRunloopDemo4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationItemTitle:@"Read me" normalImageName:nil highlightedImageName:nil position:BarItemPositionLeft action:@selector(readMe)];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 120, 50)];
    [b setTitle:@"New Thread" forState:UIControlStateNormal];
    [b setBackgroundColor:[UIColor grayColor]];
    [b addTarget:self action:@selector(launchThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)readMe{
    YHReadMeViewController *readMeVC = [[YHReadMeViewController alloc] initWithReadMeFile:@"Read_me_RunloopDemo4"];
    [kYH_RootNav pushViewController:readMeVC animated:YES];
}

//启动线程
- (void)launchThread{
    //设置主线程port，子线程通过此端口发送消息给主线程
    NSPort *myPort = [NSMachPort port];
    if (myPort) {
        myPort.delegate = self;
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:) toTarget:[YHWorkThread class] withObject:myPort];
    }
}

#pragma mark - NSPortDelegate

#define kCheckinMessage 100
#define kExitMessage 101
//port代理，用于处理子线程发给主线程的消息，但NSPortMessage貌似是似有方法,会有警告，如果是arc模式则编译不通过
- (void)handlePortMessage:(NSPortMessage *)message{
    unsigned int msgid = [message msgid];
    
    if (msgid == kCheckinMessage) {
        distantPort = [message sendPot];//执行到此会崩溃
        //获得distantPort后可向此端口发送kExitMessage让子线程退出
    }else{
    
    }
}

- (void)handleMachMessage:(void *)msg{

}

@end
