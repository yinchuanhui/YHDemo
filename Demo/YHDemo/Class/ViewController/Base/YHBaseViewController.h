//
//  YHBaseViewController.h
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BarItemPositionLeft = 0,
    BarItemPositionRight
}BarItemPosition;

@interface YHBaseViewController : UIViewController{
    
}

@property (nonatomic, retain)NSString *readMeFileName;

/*!
 设置导航栏左右侧按钮
 */
- (UIButton *)configNavigationItemTitle:(NSString *)title
                        normalImageName:(NSString *)normalImageName
                   highlightedImageName:(NSString *)highlightedImageName
                               position:(BarItemPosition)position
                                 action:(SEL)action;

@end
