//
//  YHWorkThread.m
//  YHDemo
//
//  Created by ych on 14-10-23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHWorkThread.h"

@interface YHWorkThread (){
    NSPort *distantPort;
    BOOL   shouldExit;
}

@end

@implementation YHWorkThread

//类方法，用于创建子线程
+ (void)launchThreadWithPort:(id)inData{
    NSAutoreleasePool*  pool = [[NSAutoreleasePool alloc] init];
    
    NSPort *__distantPort = (NSPort *)inData;
    YHWorkThread *workThread = [[self alloc] init];
    [workThread sendCheckinMessage:__distantPort];
    
    do{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }while (![workThread shouldExit]);
    
    [workThread release];
    [pool release];
}

- (void)sendCheckinMessage:(NSPort *)__distantPort{
    //主线程端口，用于发送消息
    distantPort = __distantPort;
    
    NSPort *myPort = [NSMachPort port];
    myPort.delegate = self;
    [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
    //发送消息到主线程
    [distantPort sendBeforeDate:[NSDate date] msgid:10 components:nil from:myPort reserved:0];
    
    //私有方法
    /*
     NSPortMessage* messageObj = [[NSPortMessage alloc] initWithSendPort:outPort
     receivePort:myPort components:nil];
     
     if (messageObj)
     {
     [messageObj setMsgId:kCheckinMessage];
     [messageObj sendBeforeDate:[NSDate date]];
     }  */
}

- (BOOL)shouldExit{
    return shouldExit;
}

#pragma mark - NSPortDelegate

#define kCheckinMessage 100
#define kExitMessage 101
- (void)handlePortMessage:(NSPortMessage *)message
{
    unsigned int msgid = [message msgid];
    NSPort* distantPort = nil;
    
    if (msgid == kCheckinMessage)
    {
        distantPort = [message sendPort];
        
    }
    else if(msgid == kExitMessage)
    {
        shouldExit = YES;
    }
}


@end
