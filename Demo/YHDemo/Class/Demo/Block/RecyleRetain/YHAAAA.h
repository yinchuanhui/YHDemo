//
//  YHAAAA.h
//  YHDemo
//
//  Created by ych on 15/1/19.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestBlick)(void);

@interface YHAAAA : NSObject

+ (id)sharedInstance;
- (void)requestWithBlock:(RequestBlick)block;

@end
