//
//  YHCircleProgressView_1.m
//  YHDemo
//
//  Created by ych on 15/3/12.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHCircleProgressView_1.h"

@interface YHCircleProgressView_1(){
    ProgressStatus progressStatus;
    CAShapeLayer *progressLayer;
    CAShapeLayer *completeLayer;
    UIBezierPath *lastUpdatedPath;
    NSMutableArray *paths;
    CGFloat lastSourceAngle;
    CGFloat animateDuration;
}

@end

@implementation YHCircleProgressView_1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        progressStatus = ProgressStatusNormal;
        progressLayer = [CAShapeLayer layer];
        progressLayer.path = [UIBezierPath bezierPath].CGPath;
        progressLayer.frame = self.bounds;
        [self.layer addSublayer:progressLayer];
        completeLayer = [CAShapeLayer layer];
        completeLayer.frame = self.bounds;
        completeLayer.path = [UIBezierPath bezierPath].CGPath;
        completeLayer.lineJoin = kCALineJoinRound;
        completeLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:completeLayer];
        paths = [[NSMutableArray alloc] init];
        lastSourceAngle = degreeToRadian(-90);
        animateDuration = 0.3;
        
        self.annulusBorderWidth = 0.5;
        self.annulusBorderCorlor = [UIColor whiteColor];
        self.progressRadius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2-self.annulusBorderWidth-4.5;
        self.progressBgColor = [UIColor whiteColor];
        self.progressStrokeWidth = 1.0;
        self.progressFillColor = [UIColor colorWithRed:115./255 green:180./255 blue:245./255 alpha:1.0f];
        self.completeMarkStrokeColor = [UIColor colorWithRed:117./255 green:117./255 blue:117./255 alpha:1.0f];
        self.completeMarkPoints = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(8.5, 12)],[NSValue valueWithCGPoint:CGPointMake(10.5, 14)],[NSValue valueWithCGPoint:CGPointMake(15, 10)], nil];
        
        [self updateConfig];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2 - self.annulusBorderWidth;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    //绘制环形
    UIBezierPath *annulusPath = [UIBezierPath bezierPath];
    [annulusPath addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self.annulusBorderCorlor set];
    [annulusPath setLineWidth:self.annulusBorderWidth];
    [annulusPath stroke];
    
    //绘制圆形
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:center radius:self.progressRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [self.annulusBorderCorlor set];
    [circlePath fill];
}

#pragma mark - Public Method

- (void)updateConfig{
    progressLayer.strokeColor = [UIColor clearColor].CGColor;
    progressLayer.fillColor = self.progressFillColor.CGColor;
    progressLayer.lineWidth = self.progressStrokeWidth;
    progressLayer.opacity = 0.0;
    
    completeLayer.strokeColor = self.completeMarkStrokeColor.CGColor;
    completeLayer.fillColor = [UIColor clearColor].CGColor;
    completeLayer.lineWidth = 2;
    progressLayer.opacity = 0.0;
    
    [self setNeedsDisplay];
}

- (void)updateProgress:(CGFloat)progress{
    
    if (progress <= 0.0) {
        progressStatus = ProgressStatusNormal;
        if (progress < 0.05) {
            progress = 0.05;
        }
        [self updateProgressView:progress];
    }else if(progress >= 1.0){
        if (progressStatus != ProgressStatusComplete) {
            progressStatus = ProgressStatusComplete;
            [self updateCompleteView];
        }
    }else{
        progressStatus = ProgressStatusStart;
        if (progress < 0.05) {
            progress = 0.05;
        }
        [self updateProgressView:progress];
    }
}

#pragma mark - Private Method

- (void)updateProgressView:(CGFloat)progress{
    lastUpdatedPath = [UIBezierPath bezierPathWithCGPath:progressLayer.path];
    
    [paths removeAllObjects];
    
    CGFloat destinationAngle = [self destinationAngleWithRatio:(progress)];
    [paths addObjectsFromArray:[self keyframePathsWithLastUpdatedAngle:lastSourceAngle newAngle:destinationAngle  radius:self.progressRadius]];
    
    progressLayer.path = (__bridge CGPathRef)((id)paths[(paths.count -1)]);
    lastSourceAngle = destinationAngle;
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    [pathAnimation setValues:paths];
    [pathAnimation setDuration:animateDuration];
    [pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [pathAnimation setRemovedOnCompletion:YES];
    [progressLayer addAnimation:pathAnimation forKey:@"path"];
    
    if (progressLayer.opacity == 0.0) {
        CABasicAnimation *opacityAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation1 setDuration:0.3];
        [opacityAnimation1 setRemovedOnCompletion:YES];
        [progressLayer setOpacity:1];
        [progressLayer addAnimation:opacityAnimation1 forKey:nil];
        
        CABasicAnimation *opacityAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation2 setDuration:0.3];
        [opacityAnimation2 setRemovedOnCompletion:YES];
        [completeLayer setOpacity:0];
        [completeLayer addAnimation:opacityAnimation2 forKey:nil];
    }
}

- (void)updateCompleteView{
    completeLayer.opacity = 1.0;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacityAnimation setDuration:0.3];
    [opacityAnimation setRemovedOnCompletion:YES];
    [progressLayer setOpacity:0.0];
    [progressLayer addAnimation:opacityAnimation forKey:nil];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = 0.4;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:[[self.completeMarkPoints firstObject] CGPointValue]];
    
    [self.completeMarkPoints enumerateObjectsUsingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
        [path addLineToPoint:[pointValue CGPointValue]];
    }];
    completeLayer.path = path.CGPath;
    [completeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (CGFloat)destinationAngleWithRatio:(CGFloat)ratio
{
    return (degreeToRadian((360*ratio) - 90));
}

float degreeToRadian(float degree)
{
    return ((degree * M_PI)/180.0f);
}

- (NSArray *)keyframePathsWithLastUpdatedAngle:(CGFloat)lastUpdatedAngle newAngle:(CGFloat)newAngle radius:(CGFloat)radius
{
    NSUInteger frameCount = ceil(animateDuration * 60);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:frameCount + 1];
    for (int frame = 0; frame <= frameCount; frame++)
    {
        CGFloat startAngle = degreeToRadian(-90);
        CGFloat endAngle = lastUpdatedAngle + (((newAngle - lastUpdatedAngle) * frame) / frameCount);
        
        [array addObject:(id)([self pathWithStartAngle:startAngle endAngle:endAngle radius:radius].CGPath)];
    }
    
    return [NSArray arrayWithArray:array];
}

- (UIBezierPath *)pathWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle radius:(CGFloat)radius
{
    BOOL clockwise = startAngle < endAngle;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [path moveToPoint:center];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    [path closePath];
    
    return path;
}

@end