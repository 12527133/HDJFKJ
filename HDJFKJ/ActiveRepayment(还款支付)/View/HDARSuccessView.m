

#import "HDARSuccessView.h"

@implementation HDARSuccessView


- (void)createTitleView{

    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 8.0;
    self.layer.borderWidth = 0.0;
    
    /** 标题Label */
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 18*bili, self.frame.size.width, 24*bili)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = WHColorFromRGB(0x3e3e3e);
    titleLabel.text = @"正在支付";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17*bili];
    [self addSubview:titleLabel];

    /** 创建分割线 */
    UILabel * lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60*bili-0.5, self.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel1];
    
    
    /** 绘制圆形图 */
    [self drawCircleView];
}


/** 绘制圆形View  */
- (void)drawCircleView{
    
   

    self.circleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*bili, 120*bili)];
    
    self.circleView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2);
    self.circleView.backgroundColor = [UIColor clearColor];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //bounds代表视图的大小
    CGPoint center = CGPointMake(self.circleView.frame.size.width/2.0, self.circleView.frame.size.height/2.0);
    CGFloat radius = MIN(self.circleView.bounds.size.width/2, self.circleView.bounds.size.height/2);
    //起点弧度为 二分之三 π
    //结束弧度为 数值*2π  + 起点的二分之三π
    [path addArcWithCenter:center radius:radius-5 startAngle:3*M_PI_2 endAngle:3*M_PI_2 + M_PI_2 * 4 clockwise:YES];
    
    //如果颜色 不等于nil
    [WHColorFromRGB(0xB0BBD2) setStroke];
    path.lineWidth = 5;
    //描边
    [path stroke];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //内部填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //线条颜色
    layer.strokeColor = WHColorFromRGB(0xB0BBD2).CGColor;
    //线条宽度
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
    [self.circleView.layer addSublayer:layer];
    [self addSubview:self.circleView];
    
    [self drawArcView];
}

/** 绘制弧形View */
- (void)drawArcView{

    self.arcView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120*bili, 120*bili)];
    
    self.arcView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2);
    self.arcView.backgroundColor = [UIColor clearColor];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //bounds代表视图的大小
    CGPoint center = CGPointMake(self.arcView.frame.size.width/2.0, self.arcView.frame.size.height/2.0);;
    CGFloat radius = MIN(self.arcView.bounds.size.width/2, self.arcView.bounds.size.height/2);
    //起点弧度为 二分之三 π
    //结束弧度为 数值*2π  + 起点的二分之三π
    [path addArcWithCenter:center radius:radius-5 startAngle:2*M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    //如果颜色 不等于nil
    [WHColorFromRGB(0x4279d6) setStroke];
    path.lineWidth = 5;
    //描边
    [path stroke];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //内部填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //线条颜色
    layer.strokeColor = WHColorFromRGB(0x4279d6).CGColor;
    //线条宽度
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
    [self.arcView.layer addSublayer:layer];
    [self addSubview:self.arcView];
    [self rotateArcView];
}

/** 视图旋转 */
- (void)rotateArcView
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2);
    rotationAnimation.duration = 0.5;
    rotationAnimation.repeatCount = 150;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.arcView.layer addAnimation:rotationAnimation forKey:@"UIViewRotation"];
}

//停止旋转动画
- (void)stopRotation
{
    [self.arcView.layer removeAnimationForKey:@"UIViewRotation"];
    
    [self.arcView removeFromSuperview];
    
    [self drawmatchView];
}


/** 绘制对号View */
- (void)drawmatchView{

    self.matchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90*bili, 90*bili)];
    self.matchView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2);;
    //曲线建立开始点和结束点
    //1. 曲线的中心
    //2. 曲线半径
    //3. 开始角度
    //4. 结束角度
    //5. 顺/逆时针方向
    UIBezierPath * path = [UIBezierPath bezierPath];
    //UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x, self.center.y) radius:self.frame.size.width/2.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    //对拐角和中点处理
    
    //设置线头的样式：Butt 齐头   Square 多出一截方头 Round 多出一截圆头
    path.lineCapStyle = kCGLineCapRound;
    //设置线条连接处的样式（圆的、斜的、尖的）
    path.lineJoinStyle = kCGLineJoinMiter;
    
    //对号第一部分直线的起始
    [path moveToPoint:CGPointMake(self.matchView.frame.size.width/5, self.matchView.frame.size.width/2)];
    CGPoint p1 = CGPointMake(self.matchView.frame.size.width/5.0*2, self.matchView.frame.size.width/4.0*3);
    [path addLineToPoint:p1];
    
    //对号第二部分起始
    CGPoint p2 = CGPointMake(self.matchView.frame.size.width/8.0*7, self.matchView.frame.size.width/4.0+8);
    [path addLineToPoint:p2];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    //内部填充颜色
    layer.fillColor = [UIColor clearColor].CGColor;
    //线条颜色
    layer.strokeColor = WHColorFromRGB(0x4279d6).CGColor;
    //线条宽度
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    //动画设置
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.3;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [self.matchView.layer addSublayer:layer];
    [self addSubview:self.matchView];

}
@end
