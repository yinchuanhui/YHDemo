//
//  YHReflectionView.m
//  YHDemo
//
//  Created by ych on 15/3/27.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHReflectionView.h"

@implementation YHReflectionView

+ (Class)layerClass{
    return [CAReplicatorLayer class];
}

- (void)setUp{
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    layer.instanceAlphaOffset = -0.6;
}

- (id)initWithFrame:(CGRect)frame
{
    //this is called when view is created in code
    if ((self = [super initWithFrame:frame])) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib
{
    //this is called when view is created from a nib
    [self setUp];
}

@end
