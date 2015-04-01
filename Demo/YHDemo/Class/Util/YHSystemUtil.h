//
//  YHSystemUtil.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHSystemUtil : NSObject

/*!
 单例
 
 @return YHSystemUtil
 */
+ (id)sharedInstance;

- (NSString *)systemVersion;

- (CGFloat)screenWidth;
- (CGFloat)screenHeight;

- (BOOL)isIOS6;
- (BOOL)isIOS7;
- (BOOL)isIOS8;
- (BOOL)isIphone;
- (BOOL)isIphone4;
- (BOOL)isIphone5;
- (BOOL)isIphone6;
- (BOOL)isIphone6Plus;

@end
