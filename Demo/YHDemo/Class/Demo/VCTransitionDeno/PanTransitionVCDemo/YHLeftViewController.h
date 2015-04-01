//
//  YHLeftViewController.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHLeftViewController : YHBaseViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithDemoDic:(NSMutableDictionary *)_demoDic;

@end
