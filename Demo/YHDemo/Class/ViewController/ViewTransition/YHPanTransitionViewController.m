//
//  YHPanTransitionViewController.m
//  YHDemo
//
//  Created by ych on 14-10-15.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHPanTransitionViewController.h"

//UIPanGestureRecognizer滑动速度阀值，用于判断是否显示或隐藏左侧视图
CGFloat const MainPanVelocityXAnimationThreshold = 300.0f;
CGFloat const CenterViewControllerMaskViewAlpha = 0.5f;

#pragma mark - CenterContainerView

@interface CenterContainerView : UIView

@end

@implementation CenterContainerView

@end


#pragma mark - MainViewController

@interface YHPanTransitionViewController (){
    CenterContainerView *centerContainerView;
    UIView *centerViewMask;
    CGFloat leftViewWidth;
    CGFloat rightViewWidth;
    CGRect startingPanRect;
}

@end

@implementation YHPanTransitionViewController

- (id)initWithCenterViewController:(UIViewController *)centerViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSParameterAssert(centerViewController);
        
        self.centerViewController = centerViewController;
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
        
        self.panGestureEnable = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateCenterVC];
    [self updateLeftVC];
    [self updateRightVC];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
    //需要设置plist文件的View controller-based status bar appearance为NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Set VC

- (void)updateCenterVC
{
    if(centerContainerView == nil){
        centerContainerView = [[CenterContainerView alloc] initWithFrame:self.view.bounds];
        centerContainerView.layer.masksToBounds = NO;
        centerContainerView.layer.shadowOffset = CGSizeMake(-2, 0);
        centerContainerView.layer.shadowOpacity = 0.05f;
        centerContainerView.layer.shadowColor = [UIColor grayColor].CGColor;
        centerContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:centerContainerView.frame].CGPath;
        [self.view addSubview:centerContainerView];
        
        centerViewMask = [[UIView alloc] initWithFrame:self.view.bounds];
        [centerContainerView addSubview:centerViewMask];
        
        centerViewMask.backgroundColor = [UIColor blackColor];
        centerViewMask.alpha = 0.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [centerViewMask addGestureRecognizer:tap];
    }
    
    if (self.centerViewController) {
        [self addChildViewController:self.centerViewController];
        [centerContainerView addSubview:self.centerViewController.view];
        
        [self.centerViewController beginAppearanceTransition:YES animated:NO];
        [self.centerViewController endAppearanceTransition];
        [self.centerViewController didMoveToParentViewController:self];
        
        //设置带导航栏的中间视图
        /*
         UINavigationController *centerNavitagor = [[UINavigationController alloc] initWithRootViewController:nil];
         [self addChildViewController:centerNavitagor];
         [centerContainerView addSubview:centerNavitagor.view];
         
         [centerNavitagor beginAppearanceTransition:YES animated:NO];
         [centerNavitagor endAppearanceTransition];
         [centerNavitagor didMoveToParentViewController:self];
         centerNavitagor.view.frame = self.view.bounds;
         
         [centerNavitagor pushViewController:self.centerViewController animated:NO];
         
         */
    }
    [centerContainerView bringSubviewToFront:centerViewMask];
}

- (void)updateLeftVC
{
    if(self.leftViewController){
        leftViewWidth = self.leftViewController.view.frame.size.width;
        
        [self addChildViewController:self.leftViewController];
        [self.view insertSubview:self.leftViewController.view belowSubview:centerContainerView];
        [self.leftViewController didMoveToParentViewController:self];
        self.leftViewController.view.frame = CGRectOffset(self.leftViewController.view.frame, -leftViewWidth/2, 0);
        self.leftViewController.view.hidden = YES;
    }
}

- (void)updateRightVC{
    if(self.rightViewController){
        rightViewWidth = self.rightViewController.view.frame.size.width;
        
        [self addChildViewController:self.rightViewController];
        [self.view insertSubview:self.rightViewController.view belowSubview:centerContainerView];
        [self.rightViewController didMoveToParentViewController:self];
        self.rightViewController.view.frame = CGRectOffset(self.rightViewController.view.frame, centerContainerView.frame.size.width -rightViewWidth/2, 0);
        self.rightViewController.view.hidden = YES;
    }
}

#pragma mark - Gesture Handler

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            
            startingPanRect = centerContainerView.frame;
            
            break;
            
        case UIGestureRecognizerStateChanged:{
            
            CGRect newFrame = startingPanRect;
            CGPoint translatedPoint = [panGesture translationInView:centerContainerView];
            
            if ((translatedPoint.x>0 && !_isRightViewShow) || _isLeftViewShow) {
                //向右滑动
                self.rightViewController.view.hidden = YES;
                self.leftViewController.view.hidden = NO;
                
                newFrame.origin.x = [self recomputeOriginX:CGRectGetMinX(startingPanRect)+translatedPoint.x isToRight:YES];
                newFrame = CGRectIntegral(newFrame);
                [centerContainerView setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
                centerViewMask.alpha = newFrame.origin.x/leftViewWidth * CenterViewControllerMaskViewAlpha;
                
                self.leftViewController.view.center = CGPointMake(centerContainerView.frame.origin.x/2, centerContainerView.center.y);
            }else if((translatedPoint.x<0 && !_isLeftViewShow)|| _isRightViewShow){
                //向左滑动
                self.rightViewController.view.hidden = NO;
                self.leftViewController.view.hidden = YES;
                
                newFrame.origin.x = [self recomputeOriginX:CGRectGetMinX(startingPanRect)+translatedPoint.x isToRight:NO];
                newFrame = CGRectIntegral(newFrame);
                [centerContainerView setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
                centerViewMask.alpha = newFrame.origin.x/rightViewWidth * CenterViewControllerMaskViewAlpha;
                
                self.rightViewController.view.center = CGPointMake(centerContainerView.frame.size.width+centerContainerView.frame.origin.x/2, centerContainerView.center.y);
            }
            
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
            
            break;
            
        case UIGestureRecognizerStateEnded:{
            
            CGPoint velocity = [panGesture velocityInView:self.view];
            startingPanRect = CGRectZero;
            CGFloat xOffset = centerContainerView.frame.origin.x;
            if ((xOffset>0 && !_isLeftViewShow) || _isLeftViewShow) {
                CGFloat midPoint = leftViewWidth / 2.0;
                if (velocity.x > MainPanVelocityXAnimationThreshold) {
                    [self showLeftView];
                }else if(velocity.x < -MainPanVelocityXAnimationThreshold){
                    [self hideLeftView];
                }else if(xOffset > midPoint){
                    [self showLeftView];
                }else if(xOffset < midPoint){
                    [self hideLeftView];
                }
            }else if((xOffset<0 && !_isLeftViewShow) || _isRightViewShow){
                CGFloat midPoint = -rightViewWidth / 2.0;
                if (velocity.x < -MainPanVelocityXAnimationThreshold) {
                    [self showRightView];
                }else if(velocity.x > MainPanVelocityXAnimationThreshold){
                    [self hideRightView];
                }else if(xOffset < midPoint){
                    [self showRightView];
                }else if(xOffset > midPoint){
                    [self hideRightView];
                }
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture{
    CGPoint translatedPoint = [tapGesture locationInView:self.view];
    if (CGRectContainsPoint(centerContainerView.frame, translatedPoint)) {
        if (_isLeftViewShow) {
            [self hideLeftView];
        }
        if (_isRightViewShow) {
            [self hideRightView];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.panGestureEnable;
}

#pragma mark - Private Methods

-(CGFloat)recomputeOriginX:(CGFloat)originX isToRight:(BOOL)isToRight{
    //根据手势确定centerView的x坐标
    if (isToRight) {
        if(originX > leftViewWidth){
            return leftViewWidth;
        }else if(originX < 0){
            return 0;
        }else{
            return originX;
        }
    }else{
        if(originX < -rightViewWidth){
            return -rightViewWidth;
        }else if(originX > 0){
            return 0;
        }else{
            return originX;
        }
    }
}

#pragma mark - Public Methods

- (void)changeCenterVC:(UIViewController *)centerVC{
    [self.centerViewController.view removeFromSuperview];
    [self.centerViewController removeFromParentViewController];
    self.centerViewController = nil;
    self.centerViewController = centerVC;
    [self updateCenterVC];
}

- (void)showLeftView{
    _isLeftViewShow = YES;
    self.leftViewController.view.hidden = NO;
    
    if (self.rightViewController) {
        [self.view sendSubviewToBack:self.rightViewController.view];
    }
    
    [self.leftViewController beginAppearanceTransition:YES animated:YES];
    [self.leftViewController endAppearanceTransition];
    
    [self.centerViewController beginAppearanceTransition:NO animated:YES];
    [self.centerViewController endAppearanceTransition];
    
    //TODO:后期可优化设置动画效果
    [UIView animateWithDuration:0.2 animations:^{
        centerContainerView.frame = CGRectMake(leftViewWidth, 0, centerContainerView.frame.size.width, centerContainerView.frame.size.height);
        self.leftViewController.view.frame = CGRectMake(0, 0, self.leftViewController.view.frame.size.width, self.leftViewController.view.frame.size.height);
        
        centerViewMask.alpha = CenterViewControllerMaskViewAlpha;
    }];
}

- (void)hideLeftView{
    _isLeftViewShow = NO;
    
    [self.leftViewController beginAppearanceTransition:NO animated:YES];
    [self.leftViewController endAppearanceTransition];
    
    [self.centerViewController beginAppearanceTransition:YES animated:YES];
    [self.centerViewController endAppearanceTransition];
    
    //TODO:后期可优化设置动画效果
    [UIView animateWithDuration:0.2 animations:^{
        centerContainerView.frame = CGRectMake(0, 0, centerContainerView.frame.size.width, centerContainerView.frame.size.height);
        self.leftViewController.view.frame = CGRectMake(-leftViewWidth/2, 0, self.leftViewController.view.frame.size.width, self.leftViewController.view.frame.size.height);
        
        centerViewMask.alpha = 0.0;
    }completion:^(BOOL finished) {
        self.leftViewController.view.hidden = YES;
    }];
}

- (void)showRightView{
    _isRightViewShow = YES;
    self.rightViewController.view.hidden = NO;
    
    if (self.leftViewController) {
        [self.view sendSubviewToBack:self.leftViewController.view];
    }
    
    [self.rightViewController beginAppearanceTransition:YES animated:YES];
    [self.rightViewController endAppearanceTransition];
    
    [self.centerViewController beginAppearanceTransition:NO animated:YES];
    [self.centerViewController endAppearanceTransition];
    
    //TODO:后期可优化设置动画效果
    [UIView animateWithDuration:0.2 animations:^{
        centerContainerView.frame = CGRectMake(-rightViewWidth, 0, centerContainerView.frame.size.width, centerContainerView.frame.size.height);
        self.rightViewController.view.frame = CGRectMake(centerContainerView.frame.size.width-rightViewWidth, 0, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        
        centerViewMask.alpha = CenterViewControllerMaskViewAlpha;
    }];
}

- (void)hideRightView{
    _isRightViewShow = NO;
    
    [self.rightViewController beginAppearanceTransition:NO animated:YES];
    [self.rightViewController endAppearanceTransition];
    
    [self.centerViewController beginAppearanceTransition:YES animated:YES];
    [self.centerViewController endAppearanceTransition];
    
    //TODO:后期可优化设置动画效果
    [UIView animateWithDuration:0.2 animations:^{
        centerContainerView.frame = CGRectMake(0, 0, centerContainerView.frame.size.width, centerContainerView.frame.size.height);
        self.rightViewController.view.frame = CGRectMake(centerContainerView.frame.size.width-rightViewWidth/2, 0, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        
        centerViewMask.alpha = 0.0;
    }completion:^(BOOL finished) {
        self.rightViewController.view.hidden = YES;
    }];
}

@end