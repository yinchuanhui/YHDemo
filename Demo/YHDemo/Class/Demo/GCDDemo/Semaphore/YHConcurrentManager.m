//
//  YHConcurrentManager.m
//  YHDemo
//
//  Created by ych on 15/5/8.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHConcurrentManager.h"

@interface YHConcurrentManager (){
    dispatch_semaphore_t semaphore;
    dispatch_queue_t queue;
}

@end

@implementation YHConcurrentManager

- (instancetype)init{
    if (self = [super init]) {
        semaphore = dispatch_semaphore_create(0);
        queue = dispatch_queue_create("com.sina.video.channel_request", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)doSomething{
    dispatch_async(queue, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"do something......");
    });
}

@end
