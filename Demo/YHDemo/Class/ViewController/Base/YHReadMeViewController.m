//
//  YHReadMeViewController.m
//  YHDemo
//
//  Created by ych on 14-10-20.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHReadMeViewController.h"

@interface YHReadMeViewController (){
    NSString *readMeContent;
}

@end

@implementation YHReadMeViewController

- (id)initWithReadMeFile:(NSString *)readMeFile{
    if (self = [super initWithNibName:nil bundle:nil]) {
        readMeContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:readMeFile ofType:@""] encoding:NSUTF8StringEncoding error:nil] ;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationItemTitle:@"Back" normalImageName:nil highlightedImageName:nil position:BarItemPositionLeft action:@selector(back)];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.frame];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:18];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = readMeContent;
    textView.scrollEnabled = YES;
    
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
