//
//  YHBlockDemo1ViewController.m
//  YHDemo
//
//  Created by ych on 15/4/9.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHBlockDemo1ViewController.h"

@interface YHBlockDemo1ViewController ()

@end

@implementation YHBlockDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kYH_ScreenWidth, kYH_ScreenHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label setText:@"查看Log & Read me"];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:kYH_Font_Blod(40)];
    [self.view addSubview:label];
    
    [self testGlobalObj];
    NSLog(@"========================================\r");
    [self testStaticObj];
    NSLog(@"========================================\r");
    [self testLocalObj];
    NSLog(@"========================================\r");
    [self testBlockObj];
    NSLog(@"========================================\r");
    [self testWeakObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

UILabel *__globalLabel = nil;

- (void)testGlobalObj
{
    __globalLabel = [[UILabel alloc] init];
    
    printf("static address: %p\n", &__globalLabel);
    
    void (^TestBlock)(void) = ^{
        
        printf("static address: %p\n", &__globalLabel);
        
        NSLog(@"label is :%@", __globalLabel);
    };
    
    __globalLabel = nil;
    
    TestBlock();
}

- (void)testStaticObj
{
    static UILabel *__staticLabel = nil;
    __staticLabel = [[UILabel alloc] init];
    
    printf("static address: %p\n", &__staticLabel);
    
    void (^TestBlock)(void) = ^{
        
        printf("static address: %p\n", &__staticLabel);
        
        NSLog(@"label is : %@", __staticLabel);
    };
    
    __staticLabel = nil;
    
    TestBlock();
}

- (void)testLocalObj
{
    UILabel *__localLabel = nil;
    __localLabel = [[UILabel alloc] init];
    
    printf("local address: %p\n", &__localLabel);
    
    printf("local label address: %p\n", __localLabel);
    
    void (^TestBlock)(void) = ^{
        
        printf("local address: %p\n", &__localLabel);
        
        printf("local label address: %p\n", __localLabel);
        
        NSLog(@"label is : %@", __localLabel);
    };
    
    __localLabel = nil;
    
    printf("local address: %p\n", &__localLabel);
    
    printf("local label address: %p\n", __localLabel);
    
    TestBlock();
}

- (void)testBlockObj
{
    __block UILabel *_blockLabel = [[UILabel alloc] init];
    
    printf("block address: %p\n", &_blockLabel);
    printf("block label address: %p\n", _blockLabel);
    
    void (^TestBlock)(void) = ^{
        
        printf("block address: %p\n", &_blockLabel);
        printf("block label address: %p\n", _blockLabel);
        
        NSLog(@"label is : %@", _blockLabel);
    };
    
    _blockLabel = nil;
    
    printf("block address: %p\n", &_blockLabel);
    printf("block label address: %p\n", _blockLabel);
    
    TestBlock();
}

- (void)testWeakObj
{
    UILabel *__localLabel = [[UILabel alloc] init];
    
    __weak UILabel *weakLabel = __localLabel;
    
    printf("weak address: %p\n", &weakLabel);
    printf("weak label address: %p\n", weakLabel);
    
    void (^TestBlock)(void) = ^{
        
        printf("weak address: %p\n", &weakLabel);
        printf("weak str address: %p\n", weakLabel);
        
        NSLog(@"label is : %@", weakLabel);
    };
    
    __localLabel = nil;
    
    TestBlock();
}

@end
