//
//  YHBaseViewController.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

@interface YHBaseViewController ()

@end

@implementation YHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController.viewControllers containsObject:self]) {
        [self configCommonBackNavigationItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)configCommonBackNavigationItem
{
//    [self configNavigationItemTitle:@"Back" normalImageName:nil highlightedImageName:nil position:BarItemPositionLeft action:@selector(backButtonPressed:)];
    [self configNavigationItemTitle:@"Read me" normalImageName:nil highlightedImageName:nil position:BarItemPositionLeft action:@selector(readMe)];
}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)readMe{
    YHReadMeViewController *readMeVC = [[YHReadMeViewController alloc] initWithReadMeFile:self.readMeFileName];
    [kYH_RootNav pushViewController:readMeVC animated:YES];
}

#pragma mark - Public Method

- (UIButton *)configNavigationItemTitle:(NSString *)title
                        normalImageName:(NSString *)normalImageName
                   highlightedImageName:(NSString *)highlightedImageName
                               position:(BarItemPosition)position
                                 action:(SEL)action
{
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
    
    CGFloat width = 100;
    CGFloat heigth = 44;
    
    if (normalImage != nil) {
        width = normalImage.size.width;
        heigth = normalImage.size.height;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, width, heigth);
    button.titleLabel.font = kYH_Font_Normal(17);
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (position == BarItemPositionLeft) {
        [self.navigationItem setLeftBarButtonItem:item animated:YES];
    } else if (position == BarItemPositionRight) {
        [self.navigationItem setRightBarButtonItem:item animated:YES];
    }
    
    return button;
}

@end
