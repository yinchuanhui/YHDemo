//
//  YHRunTimeDemo1ViewController.m
//  YHDemo
//
//  Created by ych on 14/11/18.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHRunTimeDemo1ViewController.h"
#import <objc/runtime.h>

@interface YHRunTimeDemo1ViewController ()

@end

@implementation YHRunTimeDemo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    [button1 setTitle:@"replace method" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor grayColor]];
    [button1 addTarget:self action:@selector(replace) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 170, 200, 50)];
    [button2 setTitle:@"forward method" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor grayColor]];
    [button2 addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(10, 240, 200, 50)];
    [button3 setTitle:@"get property" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setBackgroundColor:[UIColor grayColor]];
    [button3 addTarget:self action:@selector(property) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button31 = [[UIButton alloc] initWithFrame:CGRectMake(10, 310, 200, 50)];
    [button31 setTitle:@"get ivar" forState:UIControlStateNormal];
    [button31 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button31 setBackgroundColor:[UIColor grayColor]];
    [button31 addTarget:self action:@selector(ivar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button31];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(10, 380, 200, 50)];
    [button4 setTitle:@"get method" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button4 setBackgroundColor:[UIColor grayColor]];
    [button4 addTarget:self action:@selector(method) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////replace//////////////////////////////////////////

//IMP originalIMP;
NSString *(* originalIMP)(id,SEL);

NSString * MyUppercaseString(id class, SEL _cmd){
    NSLog(@"begin");
    NSString *str = originalIMP(class, _cmd);
    NSLog(@"end");
    return str;
}

- (void)replace{
    Class strClass = [NSString class];
    SEL originalUppercaseSting = @selector(uppercaseString);
    originalIMP = [NSString instanceMethodForSelector:originalUppercaseSting];
    class_replaceMethod(strClass, originalUppercaseSting, (IMP)MyUppercaseString, NULL);
    NSString *s = @"hello world!";
    
    NSLog(@"%@",  [s uppercaseString]);
}

//////////////////////////////////////////forward & resolve//////////////////////////////////////////

- (void)forward{
    NSString *s = [self performSelector:@selector(uppercaseString)];
    NSLog(@"%@", s);
}

//forwardingTargetForSelector是NSObject的函数，用户可以在派生类中对其重载,从而将无法处理的selector转 发给另一个对象。还是以上面的uppercaseString为例，如果用户自己定义的CA类的对象a，没有uppercaseString这样一个实例 函数，那么在不调用respondSelector的情况下，直接执行[a performSelector:@selector"uppercaseString"],那么执行时一定会crash，此时，如果CA实现了 forwardingTargetForSelector函数，并返回一个NSString对象，那么就相对于对该NSString对象执行了 uppercaseString函数，此时就不会crash了。当然实现这个函数的目的并不仅仅是为了程序不crash那么简单，在实现装饰者模式时，也 可以使用该函数进行消息转发。
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector == @selector(uppercaseString)) {
        return @"hello world!";
    }
    return nil;
}

//+ (BOOL) resolveInstanceMethod:(SEL)aSEL
//
//这个函数与forwardingTargetForSelector类似，都会在对象不能接受某个selector时触发，执行起来略有差别。前者的目 的主要在于给客户一个机会来向该对象添加所需的selector，后者的目的在于允许用户将selector转发给另一个对象。另外触发时机也不完全一 样，该函数是个类函数，在程序刚启动，界面尚未显示出时，就会被调用。
//
//在类不能处理某个selector的情况下，如果类重载了该函数，并使用class_addMethod添加了相应的selector，并返回YES，那么后面forwardingTargetForSelector 就不会被调用，如果在该函数中没有添加相应的selector，那么不管返回什么，后面都会继续调用 forwardingTargetForSelector，如果在forwardingTargetForSelector并未返回能接受该 selector的对象，那么resolveInstanceMethod会再次被触发，这一次，如果仍然不添加selector，程序就会报异常




//三种测试方法可帮助了解forward & resolve的使用方法
//1.按如下代码执行，当调用uppercaseString时会添加uppercaseString
//2.注释如下代码，当调用uppercaseString时执行forwardingTargetForSelector
//3.+ (BOOL)resolveInstanceMethod:(SEL)sel中代码修改为retuen YES;,当调用uppercaseString时,由于没有uppercaseString函数，因此会触发resolveInstanceMethod，但是由于该函数并没有添加selector，因此运行时发现找不到该函数，会触发
//forwardingTargetForSelector 函数，在forwardingTargetForSelector函数中，返回了一个NSString "hello world"，因此会由该string来执行uppercaseString函数，最终返回大写的hello world。


+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(uppercaseString)) {
//    @@:    第一个@代表返回类型是字符串，第二个@代表id（就是self的类型）,:代表SEL
//    v@:    v代表返回类型是void，其他同上
//    @@:@   最后一个@代表参数是NSString，其他同上
//    v@:@   最后一个@代表参数是NSString，其他同上
        class_addMethod([self class], sel, (IMP)runtimeAdd, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

NSString * runtimeAdd(id self, SEL _cmd)
{
    printf("SEL %s did not exist\n",sel_getName(_cmd));
    return @"hello world with runtime add";
}



//runtime只会获取当前类的属性——父类的以及扩展里实现的属性都不能通过这样的方式获取


//////////////////////////////////////////property//////////////////////////////////////////
- (void)property{
    u_int count;
    objc_property_t *properties = class_copyPropertyList([UIView class], &count);
    
    for (int i = 0; i < count; i++) {
        const char *property = property_getName(properties[i]);
        NSString *peopertyName = [NSString stringWithCString:property encoding:NSUTF8StringEncoding];
        NSLog(@"----%@", peopertyName);
    }
}

//////////////////////////////////////////ivar//////////////////////////////////////////

- (void)ivar{
    u_int count;
    Ivar *ivars = class_copyIvarList([UIView class], &count);
    for (int i = 0; i < count; i++) {
        const char *iavr = ivar_getName(ivars[i]);
        NSString *ivarName = [NSString stringWithCString:iavr encoding:NSUTF8StringEncoding];
        NSLog(@"%@", ivarName);
    }
}

//////////////////////////////////////////method//////////////////////////////////////////

- (void)method{
    u_int count;
    Method *methods = class_copyMethodList([UIView class], &count);
    for (int i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        NSString *methodName = [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
        NSLog(@"%@", methodName);
    }
}

@end
