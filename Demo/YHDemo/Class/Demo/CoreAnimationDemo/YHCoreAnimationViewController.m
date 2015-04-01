//
//  YHCoreAnimationViewController.m
//  YHDemo
//
//  Created by ych on 15/3/24.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "YHCoreAnimationViewController.h"
#import <GLKit/GLKit.h>
#import "UIColor+Categary.h"
#import "YHReflectionView.h"

@interface YHCoreAnimationViewController ()

@property (nonatomic, retain)UIScrollView *scrollView;
@property (nonatomic, retain)NSMutableArray *digitViewArray;
@property (nonatomic, retain)CALayer *colorLayer;

@end

@implementation YHCoreAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(kYH_ScreenWidth, 10000);
    [self.view addSubview:self.scrollView];
    
    [self layerContents];//寄宿图
    [self layerDelegate];//layer delegate
    [self anchorPoint];//锚点
    [self shadowTest];//阴影
    [self layerMask];//图层蒙板
    [self imageStrdtchFilter];//图片拉伸过滤算法
    [self whatIsAffine];//仿射变换和非仿射变换区别
    [self mingleTransform];//混合变换
    [self transfrom3D];//3D变换
    [self disappearPoint];//消亡点
    [self cube];//立方体
    [self strokeDemo];//用shapelayer画线
    [self textLayerDemo];//CATextLayer
    [self gradientLayerDemo];//CAGradientLayer
    [self replicatorLayer];//CAReplicatorLayer
    [self emitterLayer];//CAEmitterLayer
    [self changeColorAnimate];//变换颜色的隐式动画
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Demo Config

- (void)layerContents{
    [self addDemoName:@"寄宿图"];
    
    UIView *contentsView = [[UIView alloc] initWithFrame:CGRectMake(20, [self getLastViewBottom]+20, 200, 200)];
    contentsView.backgroundColor = [UIColor grayColor];
    [self.scrollView addSubview:contentsView];
    
    //我们利用CALayer在一个普通的UIView中显示了一张图片。这不是一个UIImageView，它不是我们通常用来展示图片的方法。
    UIImage *image = [UIImage imageNamed:@"Snowman"];
    contentsView.layer.contents = (__bridge id)image.CGImage;
    
    //    你可能已经注意到了我们的雪人看起来有点。。。胖 ＝＝！ 我们加载的图片并不刚好是一个方的，为了适应这个视图，它有一点点被拉伸了。在使用UIImageView的时候遇到过同样的问题，解决方法就是把contentMode属性设置成更合适的值，像这样：view.contentMode = UIViewContentModeScaleAspectFit;
    //    CALayer与contentMode对应的属性叫做contentsGravity
    contentsView.layer.contentsGravity = kCAGravityLeft;
    
    //    contentsScale属性属于支持高分辨率（又称Hi-DPI或Retina）屏幕机制的一部分。它用来判断在绘制图层的时候应该为寄宿图创建的空间大小，和需要显示的图片的拉伸度（假设并没有设置contentsGravity属性）。UIView有一个类似功能但是非常少用到的contentScaleFactor属性。如果contentsScale设置为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕
    //    contentsScale的目的并不是那么明显。它并不是总会对屏幕上的寄宿图有影响。如果你尝试对我们的例子设置不同的值，你就会发现根本没任何影响。因为contents由于设置了contentsGravity属性，所以它已经被拉伸以适应图层的边界。但是如果我们把contentsGravity设置为kCAGravityCenter（这个值并不会拉伸图片），那将会有很明显的变化
    //    如果你只是单纯地想放大图层的contents图片，你可以通过使用图层的transform和affineTransform属性来达到这个目的，这(指放大)也不是contengsScale的目的所在.
    contentsView.layer.contentsScale = image.scale;
    
    //  contentsRect：单位坐标指定在0到1之间，是一个相对值。contentsRect是{0, 0, 1, 1}，这意味着整个寄宿图默认都是可见的，如果我们指定一个小一点的矩形，图片就会被裁剪
    //    contentsRect在app中最有趣的地方在于一个叫做image sprites（图片拼合）的用法。如果你有游戏编程的经验，那么你一定对图片拼合的概念很熟悉，图片能够在屏幕上独立地变更位置。抛开游戏编程不谈，这个技术常用来指代载入拼合的图片，跟移动图片一点关系也没有。
    //    典型地，图片拼合后可以打包整合到一张大图上一次性载入。相比多次载入不同的图片，这样做能够带来很多方面的好处：内存使用，载入时间，渲染性能等等
    //    拼合不仅给app提供了一个整洁的载入方式，还有效地提高了载入性能（单张大图比多张小图载入地更快），但是如果有手动安排的话，他们还是有一些不方便的，如果你需要在一个已经创建好的品和图上做一些尺寸上的修改或者其他变动，无疑是比较麻烦的。
    //    Mac上有一些商业软件可以为你自动拼合图片，这些工具自动生成一个包含拼合后的坐标的XML或者plist文件，拼合图片的使用大大简化。这个文件可以和图片一同载入，并给每个拼合的图层设置contentsRect，这样开发者就不用手动写代码来摆放位置了。
    //    这些文件通常在OpenGL游戏中使用，不过呢，你要是有兴趣在一些常见的app中使用拼合技术，那么一个叫做LayerSprites的开源库（https://github.com/nicklockwood/LayerSprites)，它能够读取Cocos2D格式中的拼合图并在普通的Core Animation层中显示出来。
    contentsView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
    
}

- (void)layerDelegate{
    [self addDemoName:@"CALayer Delegate"];
    
    //    注意一下一些有趣的事情：
    //
    //    1.我们在blueLayer上显式地调用了-display。不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者。
    //    2.尽管我们没有用masksToBounds属性，绘制的那个圆仍然沿边界被裁剪了。这是因为当你使用CALayerDelegate绘制寄宿图的时候，并没有对超出边界外的内容提供绘制支持。
    //    3.现在你理解了CALayerDelegate，并知道怎么使用它。但是除非你创建了一个单独的图层，你几乎没有机会用到CALayerDelegate协议。因为当UIView创建了它的宿主图层时，它就会自动地把图层的delegate设置为它自己，并提供了一个-displayLayer:的实现，那所有的问题就都没了。
    //
    //    当使用寄宿了视图的图层的时候，你也不必实现-displayLayer:和-drawLayer:inContext:方法咦绘制你的寄宿图。通常做法是实现UIView的-drawRect:方法，UIView就会帮你做完剩下的工作，包括在需要重绘的时候调用-display方法。
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, [self getLastViewBottom]+20, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.scrollView.layer addSublayer:blueLayer];
    [blueLayer display];
}

- (void)anchorPoint{
    [self addDemoName:@"锚点"];
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(20, [self getLastViewBottom]+20, 50, 50)];
    a.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:a];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(70, a.frame.origin.y, 50, 50)];
    b.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:b];
    b.layer.anchorPoint = CGPointMake(0, 0);
    //    当改变了anchorPoint，position属性保持固定的值并没有发生改变，但是frame却移动了。
    NSLog(@"%@----%@", NSStringFromCGPoint(a.layer.position), NSStringFromCGPoint(b.layer.position));
}

- (void)shadowTest{
    [self addDemoName:@"阴影"];
    
    UIView *a = [[UIView alloc] initWithFrame:CGRectMake(20, [self getLastViewBottom]+20, 100, 100)];
    a.backgroundColor = [UIColor blueColor];
    a.layer.shadowOpacity = 0.8f;
    a.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    a.layer.shadowRadius = 20.0f;
    //masksToBounds会裁剪掉了阴影和超出边界的内容
    //    a.layer.masksToBounds = YES;
    [self.scrollView addSubview:a];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(75, 25, 50, 50)];
    b.backgroundColor = [UIColor redColor];
    [a addSubview:b];
    
    
    
    UIView *c = [[UIView alloc] initWithFrame:CGRectMake(200, a.frame.origin.y, 100, 100)];
    c.backgroundColor = [UIColor blueColor];
    c.layer.shadowOpacity = 0.8f;
    c.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    c.layer.shadowRadius = 30.0f;
    [self.scrollView addSubview:c];
    
    CGMutablePathRef squarePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(squarePath, NULL, c.bounds);
    c.layer.shadowPath = squarePath;
    CGPathRelease(squarePath);
}

- (void)layerMask{
    [self addDemoName:@"图层蒙板"];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, [self getLastViewBottom] +20, 117, 155)];
    imageView1.image = [UIImage imageNamed:@"Snowman"];
    [self.scrollView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(157, imageView1.frame.origin.y + 13, 128, 128)];
    imageView2.image = [UIImage imageNamed:@"mask_layer_demo"];
    [self.scrollView addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(305, imageView1.frame.origin.y, 117, 155)];
    imageView3.image = [UIImage imageNamed:@"Snowman"];
    [self.scrollView addSubview:imageView3];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = imageView2.bounds;
    UIImage *maskImage = [UIImage imageNamed:@"mask_layer_demo"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    imageView3.layer.mask = maskLayer;
}

- (void)imageStrdtchFilter{
    [self addDemoName:@"图片拉伸算法对比"];
    UIImage *image1 = [UIImage imageNamed:@"stretch_filter_demo_1"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
    imageView1.frame = CGRectMake(20, [self getLastViewBottom]+20, image1.size.width, image1.size.height);
    [self.scrollView addSubview:imageView1];
    
    UIImage *image2 = [UIImage imageNamed:@"stretch_filter_demo_2"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
    imageView2.frame = CGRectMake(20, [self getLastViewBottom]+20, image2.size.width, image2.size.height);
    [self.scrollView addSubview:imageView2];
    
    UIImage *image3 = [UIImage imageNamed:@"stretch_filter_demo_3"];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image3];
    imageView3.frame = CGRectMake(20, [self getLastViewBottom]+20, image3.size.width, image3.size.height);
    [self.scrollView addSubview:imageView3];
    
    UIImage *image4 = [UIImage imageNamed:@"stretch_filter_demo_4"];
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:image4];
    imageView4.frame = CGRectMake(20, [self getLastViewBottom]+20, image4.size.width, image4.size.height);
    [self.scrollView addSubview:imageView4];
    
    self.digitViewArray = [[NSMutableArray alloc] initWithCapacity:6];
    CGFloat y = [self getLastViewBottom];
    for (int i = 0; i < 12; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(20+i*125, y, 125, 460)];
        view.layer.contents = (__bridge id)image4.CGImage;
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResize;
        if (i>2) {
            view.layer.magnificationFilter = kCAFilterNearest;
        }
        [self.scrollView addSubview:view];
        [self.digitViewArray addObject:view];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)whatIsAffine{
    [self addDemoName:@"仿射变换和非仿射变换区别"];
    UIImage *image = [UIImage imageNamed:@"what_is_affine"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(20, [self getLastViewBottom]+20, image.size.width, image.size.height);
    [self.scrollView addSubview:imageView];
}

- (void)mingleTransform{
    [self addDemoName:@"旋转/混合变换/剪切变换"];
    
    UIImage *image = [UIImage imageNamed:@"Snowman"];
    
    UIImageView *imageView1 = [self addImageViewWithName:@"Snowman" containerView:self.scrollView];
    CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI_4);
    imageView1.transform = transform1;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getLastViewBottom], kYH_ScreenWidth, 200)];
    containerView.backgroundColor = [UIColor grayColor];
    [self.scrollView addSubview:containerView];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
    imageView2.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [containerView addSubview:imageView2];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    transform = CGAffineTransformRotate(transform, M_PI/180*30);
    transform = CGAffineTransformTranslate(transform, 200, 0);
    imageView2.layer.affineTransform = transform;
    
    UIImage *image2 = [UIImage imageNamed:@"transform_demo_1"];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image2];
    imageView3.frame = CGRectMake(200, 20, image2.size.width, image2.size.height);
    [containerView addSubview:imageView3];
    
    UIImageView *imageView4 = [self addImageViewWithName:@"Snowman" containerView:self.scrollView];
    imageView4.frame = CGRectMake(200, imageView4.frame.origin.y, imageView4.frame.size.width, imageView4.frame.size.height);
    CGAffineTransform shearTransform = CGAffineTransformIdentity;
    shearTransform.c = -1;
    shearTransform.b = 0;
    shearTransform.d = -1;
    imageView4.transform = shearTransform;
}

- (void)transfrom3D{
    [self addDemoName:@"3D变换"];
    
    UIImageView *imageView1 = [self addImageViewWithName:@"Snowman" containerView:self.scrollView];
    CATransform3D transform3D = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);//绕Y轴旋转45°；
    imageView1.layer.transform = transform3D;
    
    UIImageView *imageView3 = [self addImageViewWithName:@"transform_3d_demo" containerView:self.scrollView];
    imageView3.frame = CGRectMake(150, imageView1.frame.origin.y, imageView3.frame.size.width, imageView3.frame.size.height);
    
    UIImageView *imageView2 = [self addImageViewWithName:@"Snowman" containerView:self.scrollView];
    transform3D = CATransform3DIdentity;
    transform3D.m34 = 1.0/500;
    transform3D = CATransform3DRotate(transform3D, M_PI_4, 0, 1, 0);
    imageView2.layer.transform = transform3D;
}

- (void)disappearPoint{
    [self addDemoName:@"消亡点，详见Read me"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [self getLastViewBottom]+20, kYH_ScreenWidth, 100)];
    [self.scrollView addSubview:view];
    
    UIImageView *imageView1 = [self addImageViewWithName:@"Snowman" containerView:view];
    UIImageView *imageView2 = [self addImageViewWithName:@"Snowman" containerView:view];
    UIImageView *imageView3 = [self addImageViewWithName:@"Snowman" containerView:view];
    //    imageView2.frame = CGRectMake(kYH_ScreenWidth-imageView1.frame.size.width-imageView1.frame.origin.x, imageView1.frame.origin.y, imageView2.frame.size.width, imageView2.frame.size.height);
    imageView2.frame = CGRectMake(imageView1.frame.size.width+imageView1.frame.origin.x+20, imageView1.frame.origin.y, imageView2.frame.size.width, imageView2.frame.size.height);
    imageView3.frame = CGRectMake(imageView2.frame.size.width+imageView2.frame.origin.x+20, imageView1.frame.origin.y, imageView3.frame.size.width, imageView3.frame.size.height);
    
    CATransform3D perspectice = CATransform3DIdentity;
    perspectice.m34 = -1.0/500;
    view.layer.sublayerTransform = perspectice;
    
    //注意设置旋转后与原图的对比
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    imageView1.layer.transform = transform1;
    imageView2.layer.transform = transform1;
    imageView3.layer.transform = transform1;
}

- (void)cube{
    UILabel *label = [self addDemoName:@"立方体"];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 60, label.frame.size.width, label.frame.size.height);
    
    UIView *cube = [[UIView alloc] initWithFrame:CGRectMake(0, [self getLastViewBottom], kYH_ScreenWidth, 400)];
    cube.backgroundColor = [UIColor grayColor];
    CATransform3D prespective =CATransform3DIdentity;
    prespective.m34 = -1.0/500;
    prespective = CATransform3DRotate(prespective, -M_PI_4, 1, 0, 0);
    prespective = CATransform3DRotate(prespective, -M_PI_4, 0, 1, 0);
    cube.layer.sublayerTransform = prespective;
    [self.scrollView addSubview:cube];
    
    UIView *view1 = [self addFaceViewWithIndex:1 containerView:cube];
    UIView *view2 = [self addFaceViewWithIndex:2 containerView:cube];
    UIView *view3 = [self addFaceViewWithIndex:3 containerView:cube];
    UIView *view4 = [self addFaceViewWithIndex:4 containerView:cube];
    UIView *view5 = [self addFaceViewWithIndex:5 containerView:cube];
    UIView *view6 = [self addFaceViewWithIndex:6 containerView:cube];
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    view1.layer.transform = transform;
    
    CATransform3D transform1 = CATransform3DMakeTranslation(100, 0, 0);
    transform1 = CATransform3DRotate(transform1, M_PI_2, 0, 1, 0);
    view2.layer.transform = transform1;
    
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    view3.layer.transform = transform;
    
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    view4.layer.transform = transform;
    
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    view5.layer.transform = transform;
    
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    view6.layer.transform = transform;
}

- (void)strokeDemo{
    [self addDemoName:@"UIShapeLayer画线demo"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, [self getLastViewBottom]+20, kYH_ScreenWidth, 170)];
    [self.scrollView addSubview:view];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(75, 30)];
    [path addArcWithCenter:CGPointMake(50, 30) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path moveToPoint:CGPointMake(50, 55)];
    [path addLineToPoint:CGPointMake(50, 105)];
    [path addLineToPoint:CGPointMake(25, 155)];
    [path moveToPoint:CGPointMake(50, 105)];
    [path addLineToPoint:CGPointMake(75, 155)];
    [path moveToPoint:CGPointMake(0, 80)];
    [path addLineToPoint:CGPointMake(100, 80)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [view.layer addSublayer:shapeLayer];
    
    //单独置顶某个角的是否圆角
    CGRect rect = CGRectMake(0, 0, 100, 100);
    CGSize radius = CGSizeMake(20, 20);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerTopLeft | UIRectCornerBottomLeft;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radius];
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(150, 0, 100, 100);
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path1.CGPath;
    [view.layer addSublayer:shapeLayer];
}

- (void)textLayerDemo{
    [self addDemoName:@"CATextLayer"];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(20, [self getLastViewBottom]+20, kYH_ScreenWidth, 80);
    [self.scrollView.layer addSublayer:textLayer];
    textLayer.foregroundColor = [UIColor blueColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    UIFont *font = kYH_Font_Normal(14);
    //    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    //    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    CGFontRef fontRef = (__bridge CGFontRef)font;
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    NSString *text = @"这是用CATextLayer渲染的文字！！！这是用CATextLayer渲染的文字！！！这是用CATextLayer渲染的文字！！！这是用CATextLayer渲染的文字！！！这是用CATextLayer渲染的文字！！！这是用CATextLayer渲染的文字！！！这是用CATextLayer渲染的文字！！！\r\n如果我们想以Retina的质量来显示文字，我们就得手动地设置CATextLayer的contentsScale属性";
    textLayer.string = text;
}

- (void)gradientLayerDemo{
    [self addDemoName:@"CAGradientLayer"];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(20, [self getLastViewBottom]+20, 100, 100);
    [self.scrollView.layer addSublayer:gradientLayer];
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, ];
    //locations属性是一个浮点数值的数组（以NSNumber包装）。这些浮点数定义了colors属性中每个不同颜色的位置
    gradientLayer.locations = @[@0.0, @0.45, @0.70];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}

- (void)replicatorLayer{
    [self addDemoName:@"CAReplicatorLayer 说明参见代码"];
    
    //    我们在屏幕的中间创建了一个灰色方块图层，然后用CAReplicatorLayer生成十个图层组成一个圆圈。instanceCount属性指定了图层需要重复多少次。instanceTransform指定了一个CATransform3D3D变换（这种情况下，下一图层的位移和旋转将会移动到圆圈的下一个点）。
    //    变换是逐步增加的，每个实例都是相对于前一实例布局。这就是为什么这些复制体最终不会出现在同意位置上
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.backgroundColor = [UIColor grayColor].CGColor;
    replicatorLayer.frame = CGRectMake(200, [self getLastViewBottom]+200, 100, 100);
    [self.scrollView.layer addSublayer:replicatorLayer];
    replicatorLayer.instanceCount = 8;
    
    CATransform3D transform = CATransform3DIdentity;
    //    transform = CATransform3DTranslate(transform, 100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_4, 0, 0, 1);
    //    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicatorLayer.instanceTransform = transform;
    
    //通过逐步减少蓝色和绿色通道
    replicatorLayer.instanceBlueOffset = -0.1;
    replicatorLayer.instanceRedOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.backgroundColor = [UIColor grayColor].CGColor;
    [replicatorLayer addSublayer:layer];
    
    UIImage *image = [UIImage imageNamed:@"Snowman"];
    YHReflectionView *reView = [[YHReflectionView alloc] initWithFrame:CGRectMake(20, [self getLastViewBottom]+200, image.size.width, image.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [reView addSubview:imageView];
    
    [self.scrollView addSubview:reView];
}

- (void)emitterLayer{
    UILabel *label = [self addDemoName:@"CAEmitterLayer创建爆炸效果"];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 120, label.frame.size.width, label.frame.size.height);
    
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = CGRectMake(20, [self getLastViewBottom], 200, 200);;
    [self.scrollView.layer addSublayer:emitter];
    //kCAEmitterLayerAdditive，它实现了这样一个效果：合并例子重叠部分的亮度使得看上去更亮。如果我们把它设置为默认的kCAEmitterLayerUnordered，效果就没那么好看了
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"emitter"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    //alphaSpeed设置为-0.4，就是说例子的透明度每过一秒就是减少0.4，这样就有发射出去之后逐渐消失的效果
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    //emissionRange属性的值是2π，这意味着例子可以从360度任意位置反射出来。如果指定一个小一些的值，就可以创造出一个圆锥形
    cell.emissionRange = M_PI * 2.0;
    //add particle template to emitter
    emitter.emitterCells = @[cell];
}

- (void)changeColorAnimate{
    [self addDemoName:@"隐式动画"];
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(20, [self getLastViewBottom]+20, 100, 100);
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.scrollView.layer addSublayer:self.colorLayer];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(160, self.colorLayer.frame.origin.y, 100, 40)];
    [button setTitle:@"变换颜色" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
}

#pragma mark - Layer Delegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

#pragma mark - Private Method

- (UILabel *)addDemoName:(NSString *)name{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, [self getLastViewBottom]+50, kYH_ScreenWidth, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameLabel setText:name];
    [nameLabel setTextColor:[UIColor redColor]];
    [nameLabel setFont:kYH_Font_Blod(18)];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:nameLabel];
    return nameLabel;
}

- (UIImageView *)addImageViewWithName:(NSString *)imageName containerView:(UIView *)containerView{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    if (containerView == self.scrollView) {
        imageView.frame = CGRectMake(20, [self getLastViewBottom]+20, image.size.width, image.size.height);
    }else{
        imageView.frame = CGRectMake(20, 20, image.size.width, image.size.height);
    }
    
    [containerView addSubview:imageView];
    return imageView;
}

//获取最后视图或图层的bottom坐标
- (CGFloat)getLastViewBottom{
    NSArray *views = self.scrollView.subviews;
    UIView *lastView = [views lastObject];
    CGFloat lastViewBotton = lastView.frame.origin.y + lastView.frame.size.height;
    
    NSArray *layers = self.scrollView.layer.sublayers;
    CALayer *lastLayer = [layers lastObject];
    CGFloat lastLayerBottom = lastLayer.frame.origin.y + lastLayer.frame.size.height;
    
    return lastViewBotton>lastLayerBottom?lastViewBotton:lastLayerBottom;
}

#pragma mark - Demo Private Method

- (void)tick{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    //set hours
    [self setDigit:components.hour / 10 forView:self.digitViewArray[0]];
    [self setDigit:components.hour % 10 forView:self.digitViewArray[1]];
    //set minutes
    [self setDigit:components.minute / 10 forView:self.digitViewArray[2]];
    [self setDigit:components.minute % 10 forView:self.digitViewArray[3]];
    //set seconds
    [self setDigit:components.second / 10 forView:self.digitViewArray[4]];
    [self setDigit:components.second % 10 forView:self.digitViewArray[5]];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    view.layer.contentsRect = CGRectMake(digit * 0.1, 0, 0.1, 1.0);
}

- (UIView *)addFaceViewWithIndex:(int)index containerView:(UIView *)contrainerView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
    view.backgroundColor = [UIColor randomColor];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
    button.frame = view.bounds;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = kYH_Font_Blod(22);
    [view addSubview:button];
    [contrainerView addSubview:view];
    view.center = CGPointMake(contrainerView.frame.size.width / 2.0, contrainerView.frame.size.height / 2.0);
    return view;
}

- (void)changeColor{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    //    用事务控制动画时间
    //    [CATransaction begin];
    //    [CATransaction setAnimationDuration:1.0];
    //    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    //    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    //    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    //    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    //    [CATransaction commit];
}

@end
