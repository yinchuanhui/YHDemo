//
//  YHPopWithPanNavigationController.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHPopWithPanNavigationController.h"

static CGFloat offset_float = 0.65;// 拉伸参数
static CGFloat min_distance = 100;// 最小回弹距离
static CGFloat PanVelocityXAnimationThreshold = 300.0f;//UIPanGestureRecognizer滑动速度阀值，用于判断是否pop

@interface YHPopWithPanNavigationController ()<UIGestureRecognizerDelegate> {
    CGPoint startPoint;
    UIView *lastVCView;//当前VC的父VC视图
    UIView *tempView;//指向废弃的lastVCView，pop后removefromsuperview
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSMutableArray *vcList;
@property (nonatomic, assign) BOOL isMoving;

@end

@implementation YHPopWithPanNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.panGestureEnable = YES;
        self.simultaneouslyGestureEnable = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - get

- (NSMutableArray *)vcList {
    if (!_vcList) {
        _vcList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _vcList;
}

#pragma mark - override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *fatherVC = [self.viewControllers lastObject];
    if (fatherVC) {
        [self.vcList addObject:fatherVC.view];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    // 有动画用自己的动画
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        return [super popViewControllerAnimated:animated];
    }
}

#pragma mark - private

- (void) popAnimation {
    if (self.viewControllers.count == 1) {
        return;
    }
    
    if (!self.backGroundView) {
        CGRect frame = self.view.frame;
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        _backGroundView.backgroundColor = [UIColor clearColor];
    }
    
    self.backGroundView.hidden = NO;
    [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    
    tempView = lastVCView;
    
    lastVCView = [self.vcList lastObject];
    lastVCView.frame = (CGRect){-(kYH_ScreenWidth*offset_float) , kYH_IsIOS6?20:0, 320, kYH_ScreenHeight};
    [self.backGroundView addSubview:lastVCView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self moveViewWithX:320];
    } completion:^(BOOL finished) {
        [self gestureAnimation:NO];
        
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        self.view.frame = frame;
        
        _isMoving = NO;
        
        self.backGroundView.hidden = YES;
        
        if (tempView) {
            [tempView removeFromSuperview];
            tempView = nil;
        }
    }];
}

- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    lastVCView.frame = (CGRect){-(kYH_ScreenWidth*offset_float)+x*offset_float, kYH_IsIOS6?20:0, 320, kYH_ScreenHeight};
}

- (void)gestureAnimation:(BOOL)animated {
    [self.vcList removeLastObject];
    [super popViewControllerAnimated:animated];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.panGestureEnable;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return self.simultaneouslyGestureEnable;
}

#pragma mark - Gesture Recognizer
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1) return;
    
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startPoint = touchPoint;
        
        if (!self.backGroundView) {
            CGRect frame = self.view.frame;
            _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            _backGroundView.backgroundColor = [UIColor whiteColor];
        }
        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
        
        _backGroundView.hidden = NO;
        tempView = lastVCView;
        lastVCView = [self.vcList lastObject];
        lastVCView.frame = (CGRect){-(kYH_ScreenWidth*offset_float), kYH_IsIOS6?20:0,320, kYH_ScreenHeight};
        [self.backGroundView addSubview:lastVCView];
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        CGPoint velocity = [recoginzer velocityInView:self.view];
        if (touchPoint.x - startPoint.x > min_distance || velocity.x > PanVelocityXAnimationThreshold)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kYH_ScreenWidth];
            } completion:^(BOOL finished) {
                [self gestureAnimation:NO];
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backGroundView.hidden = YES;
            }];
            
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backGroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startPoint.x];
    }
}

@end
