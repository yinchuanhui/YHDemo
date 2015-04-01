//
//  YHAppUtil.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#define FIRST_TIME_LAUNCH @"FIRST_TIME_LAUNCH" //首次启动标记
#define VERSION_FIRST_TIME_LAUNCH @"VERSION_FIRST_TIME_LAUNCH"//版本首次启动

#import "YHAppUtil.h"

@implementation YHAppUtil

+ (id)sharedInstance
{
    static YHAppUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHAppUtil alloc] init];
    });
    return instance;
}

- (NSString *)appVersion{
    static NSString *appVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    });
    return appVersion;
}

- (NSString *)documentsPath{
    static NSString *documentsPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });
    return documentsPath;
}

- (NSString *)libraryPath{
    static NSString *libraryPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    });
    return libraryPath;
}

- (BOOL)isFirstTimeLaunch{
    static BOOL isFirstTimeLaunch;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (nil == [userDefaults objectForKey:FIRST_TIME_LAUNCH]){
            [userDefaults setObject:FIRST_TIME_LAUNCH forKey:FIRST_TIME_LAUNCH];
            [userDefaults synchronize];
            isFirstTimeLaunch = YES;
        }else{
            isFirstTimeLaunch = NO;
        }
    });
    return isFirstTimeLaunch;
}

- (BOOL)isFirstTimeVersionLaunch{
    static BOOL isFirstTimeVersionLaunch;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *versionStart = [userDefaults stringForKey:VERSION_FIRST_TIME_LAUNCH];
        if (versionStart==nil || ![versionStart isEqualToString:[self appVersion]]) {
            [userDefaults setObject:[self appVersion] forKey:VERSION_FIRST_TIME_LAUNCH];
            [userDefaults synchronize];
            isFirstTimeVersionLaunch = YES;
        }else{
            isFirstTimeVersionLaunch = NO;
        }
    });
    return isFirstTimeVersionLaunch;
}

@end
