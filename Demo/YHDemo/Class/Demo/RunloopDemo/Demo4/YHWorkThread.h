//
//  YHWorkThread.h
//  YHDemo
//
//  Created by ych on 14-10-23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHWorkThread : NSObject <NSPortDelegate>

+ (void)launchThreadWithPort:(id)inData;

@end
