//
//  TestModel.m
//  YHDemo
//
//  Created by ych on 14/11/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

//@dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成。（当然对于readonly的属性只需提供getter即可）。假如一个属性被声明为@dynamic var，然后你没有提供@setter方法和@getter方法，编译的时候没问题，但是当程序运行到instance.var =someVar，由于缺setter方法会导致程序崩溃；或者当运行到 someVar = var时，由于缺getter方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定。
@dynamic name;
@dynamic auther;
@synthesize version;

- (id)init{
    self = [super init];
    if (self) {
        _propertiesDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/*
    用法1
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel rangeOfString:@"set"].location == 0) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }else{
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSString *key = NSStringFromSelector([anInvocation selector]);
    if ([key rangeOfString:@"set"].location == 0) {
        key = [[key substringWithRange:NSMakeRange(3, [key length]-4)] lowercaseString];
        NSString *obj;
        [anInvocation getArgument:&obj atIndex:2];
        [_propertiesDict setObject:obj forKey:key];
    }else{
        NSString *obj = [_propertiesDict objectForKey:key];
        [anInvocation setReturnValue:&obj];
    }
}

/*
    用法2
 */
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//{
//    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
//    if (signature==nil) {
//        signature = [someObj methodSignatureForSelector:aSelector];
//    }
//    NSUInteger argCount = [signature numberOfArguments];
//    for (NSInteger i=0 ; i<argCount ; i++) {
//    }
//    
//    return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    SEL seletor = [anInvocation selector];
//    if ([someObj respondsToSelector:seletor]) {
//        [anInvocation invokeWithTarget:someObj];
//    }
//    
//}

@end
