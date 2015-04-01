//
//  TestModel.h
//  YHDemo
//
//  Created by ych on 14/11/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject{
    @private
    NSMutableDictionary *_propertiesDict;
}

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *auther;
@property (nonatomic, copy)NSString *version;

@end
