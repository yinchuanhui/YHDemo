//
//  YHSystemUtil.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHSystemUtil.h"

@implementation YHSystemUtil

+ (id)sharedInstance
{
    static YHSystemUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YHSystemUtil alloc] init];
    });
    return instance;
}

- (NSString *)systemVersion{
    static NSString *systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[UIDevice currentDevice] systemVersion];
    });
    return systemVersion;
}

- (CGFloat)screenWidth{
    static CGFloat width;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = [UIScreen mainScreen].bounds.size.width;
    });
    return width;
}

- (CGFloat)screenHeight{
    static CGFloat height;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        height = [UIScreen mainScreen].bounds.size.height;
    });
    return height;
}

- (BOOL)isIOS6{
    static BOOL isIOS6;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        float version = [[UIDevice currentDevice].systemVersion floatValue];
        isIOS6 = version>=6.0 && version<7.0;
    });
    return isIOS6;
}

- (BOOL)isIOS7{
    static BOOL isIOS7;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        float version = [[UIDevice currentDevice].systemVersion floatValue];
        isIOS7 = version>=7.0 && version<8.0;
    });
    return isIOS7;
}

- (BOOL)isIOS8{
    static BOOL isIOS8;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        float version = [[UIDevice currentDevice].systemVersion floatValue];
        isIOS8 = version>=8.0 && version<9.0;
    });
    return isIOS8;
}

- (BOOL)isIphone{
    static BOOL isIphone;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIphone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    });
    return isIphone;
}

- (BOOL)isIphone4{
    static BOOL isIphone4;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIphone4 = [self isIphone] && ([[UIScreen mainScreen ] bounds].size.height == 480.0f? YES:NO);
    });
    return isIphone4;
}

- (BOOL)isIphone5{
    static BOOL isIphone5;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIphone5 = [self isIphone] && ([[UIScreen mainScreen ] bounds].size.height == 568.0f? YES:NO);
    });
    return isIphone5;
}

- (BOOL)isIphone6{
    static BOOL isIphone6;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIphone6 = [self isIphone] && ([[UIScreen mainScreen ] bounds].size.height == 667.0f? YES:NO);
    });
    return isIphone6;
}

- (BOOL)isIphone6Plus{
    static BOOL isIphone6Plus;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIphone6Plus = [self isIphone] && ([[UIScreen mainScreen ] bounds].size.height == 736.0f? YES:NO);
    });
    return isIphone6Plus;
}

@end
