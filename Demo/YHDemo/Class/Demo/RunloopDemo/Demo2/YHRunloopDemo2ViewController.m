//
//  YHRunloopDemo1ViewController.m
//  YHDemo
//
//  Created by ych on 14-10-21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHRunloopDemo2ViewController.h"

@interface YHRunloopDemo2ViewController ()

@end

@implementation YHRunloopDemo2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSThread detachNewThreadSelector: @selector(newThreadProcess)
                            toTarget: self
                          withObject: nil];
    
}





- (void)newThreadProcess

{
    
    @autoreleasepool {
        
        ////获得当前thread的Runloop
        
        NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
        
        
        
        //设置Run loop observer的运行环境
        
        CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
        
        
        
        //创建Run loop observer对象
        
        //第一个参数用于分配observer对象的内存
        
        //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
        
        //第三个参数用于标识该observer是在第一次进入runloop时执行还是每次进入run loop处理时均执行
        
        //第四个参数用于设置该observer的优先级
        
        //第五个参数用于设置该observer的回调函数
        
        //第六个参数用于设置该observer的运行环境
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
        
        if(observer)
            
        {
            
            //将Cocoa的NSRunLoop类型转换成CoreFoundation的CFRunLoopRef类型
            
            CFRunLoopRef cfRunLoop = [myRunLoop getCFRunLoop];
            
            
            
            //将新建的observer加入到当前thread的runloop
            
            CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
            
        }
        
        
        
        //
        
        [NSTimer scheduledTimerWithTimeInterval: 1
         
                                        target: self
         
                                      selector:@selector(timerProcess)
         
                                      userInfo: nil
         
                                       repeats: YES];
        
        NSInteger loopCount = 3;
        
        do{
            NSLog(@"------------------");
            //启动当前thread的loop直到所指定的时间到达，在loop运行时，runloop会处理所有来自与该run loop联系的inputsource的数据
            
            //对于本例与当前run loop联系的inputsource只有一个Timer类型的source。
            
            //该Timer每隔1秒发送触发事件给runloop，run loop检测到该事件时会调用相应的处理方法。
            
            
            
            //由于在run loop添加了observer且设置observer对所有的runloop行为都感兴趣。
            
            //当调用runUnitDate方法时，observer检测到runloop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
            
            //observer检测到runloop的其它行为并调用回调函数的操作与上面的描述相类似。
            
            [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
            
            //当run loop的运行时间到达时，会退出当前的runloop。observer同样会检测到runloop的退出行为并调用其回调函数，第二个参数所传递的行为是kCFRunLoopExit。
            
            loopCount--;
            
        }while (loopCount);
        
    }
    
}



void myRunLoopObserver(CFRunLoopObserverRef observer,CFRunLoopActivity activity,void *info)

{
    
    switch (activity) {
            
            //The entrance of the run loop, beforeentering the event processing loop.
            
            //This activity occurs once for each callto CFRunLoopRun and CFRunLoopRunInMode
            
        case kCFRunLoopEntry:
            
            NSLog(@"run loop entry");
            
            break;
            
            //Inside the event processing loop beforeany timers are processed
            
        case kCFRunLoopBeforeTimers:
            
            NSLog(@"run loop before timers");
            
            break;
            
            //Inside the event processing loop beforeany sources are processed
            
        case kCFRunLoopBeforeSources:
            
            NSLog(@"run loop before sources");
            
            break;
            
            //Inside the event processing loop beforethe run loop sleeps, waiting for a source or timer to fire.
            
            //This activity does not occur ifCFRunLoopRunInMode is called with a timeout of 0 seconds.
            
            //It also does not occur in a particulariteration of the event processing loop if a version 0 source fires
            
        case kCFRunLoopBeforeWaiting:
            
            NSLog(@"run loop before waiting");
            
            break;
            
            //Inside the event processing loop afterthe run loop wakes up, but before processing the event that woke it up.
            
            //This activity occurs only if the run loopdid in fact go to sleep during the current loop
            
        case kCFRunLoopAfterWaiting:
            
            NSLog(@"run loop after waiting"); 
            
            break; 
            
            //The exit of the run loop, after exitingthe event processing loop.  
            
            //This activity occurs once for each callto CFRunLoopRun and CFRunLoopRunInMode 
            
        case kCFRunLoopExit: 
            
            NSLog(@"run loop exit"); 
            
            break; 
            
            /*
             
             A combination of all the precedingstages
             
             case kCFRunLoopAllActivities:
             
             break;
             
             */ 
            
        default: 
            
            break; 
            
    } 
    
}





- (void)timerProcess{
    
    
    
    for (int i=0; i<5; i++) {       
        
        NSLog(@"In timerProcess count = %d.", i);
        
        sleep(1);
        
    }
    
}

@end
