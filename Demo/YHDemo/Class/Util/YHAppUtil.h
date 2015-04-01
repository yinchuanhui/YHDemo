//
//  YHAppUtil.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHAppUtil : NSObject

/*!
 单例
 
 @return YHAppUtil
 */
+ (id)sharedInstance;

- (NSString *)appVersion;

- (NSString *)documentsPath;
- (NSString *)libraryPath;

/*!
 是否是第一次启动
 
 @return BOOL
 */
- (BOOL)isFirstTimeLaunch;

/*!
 是否是新版本启动
 
 @return BOOL
 */
- (BOOL)isFirstTimeVersionLaunch;

@end
