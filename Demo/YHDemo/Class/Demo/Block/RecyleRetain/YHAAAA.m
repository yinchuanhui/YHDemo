//
//  YHAAAA.m
//  YHDemo
//
//  Created by ych on 15/1/19.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHAAAA.h"

@interface YHAAAA ()

@property (nonatomic, copy)RequestBlick _block;

@end

@implementation YHAAAA

+ (id)sharedInstance
{
    static YHAAAA *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHAAAA alloc] init];
    });
    return instance;
}

- (void)requestWithBlock:(RequestBlick)block{
    self._block = block;
}

@end
