//
//  UIColor+Categary.m
//  YHDemo
//
//  Created by ych on 15/3/27.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "UIColor+Categary.h"

@implementation UIColor (Categary)

+ (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
