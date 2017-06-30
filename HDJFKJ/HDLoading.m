

#import "HDLoading.h"
#import "HDWHLoadSubView.h"
#import "HDWHLoadFailView.h"
#import "HDWHLoadSuccsessVIew.h"
#import "UIImage+GIF.h"
#define FPS 2.0
@interface HDLoading()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) HDWHLoadSubView * animationView;
@property (nonatomic, strong) HDWHLoadFailView * failView;
@property (nonatomic, strong) HDWHLoadSuccsessVIew * successView;
@property (nonatomic, assign) BOOL where;
@end
@implementation HDLoading

#pragma mark - MLTableAlert Class Method



+ (HDLoading*)sharedView {
    static dispatch_once_t once;
    
    static HDLoading *sharedView;
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]; });
#else
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
#endif
    return sharedView;
}
+ (void)showWithImageWithString:(NSString *)string{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[self sharedView] dismissImmediately];
//        [[self sharedView] showImageWithString:string];
        
        [MBProgressHUD showMessage:string];
    });
    
    
}

//加载动画
- (void)showImageWithString:(NSString *)string {
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            // strongSelf.backgroundColor = [UIColor redColor];
            _animationView = [HDWHLoadSubView view];
            [strongSelf addSubview:_animationView];
            
            _animationView.center = CGPointMake(strongSelf.center.x, strongSelf.center.y);
            _animationView.size = CGSizeMake(146*LDScreenWidth/375, 132*LDScreenWidth/375);
            
            UIImage *image = [UIImage animatedImageNamed:@"loading" duration:1/FPS*3];
            _animationView.anmiationImageView.image = image;
            _animationView.loadingStrLabel.text = string;
            
            //            strongSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
            UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
            [appWindow addSubview:strongSelf];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];

        }
    }];
}


+ (void)dismissHDLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[[self sharedView] dismiss];
        [MBProgressHUD hideHUD];
    });
    
    
}


//取消
- (void)dismiss{
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            [_timer invalidate];
            [UIView animateWithDuration:0.35 animations:^{
                _animationView.anmiationImageView.alpha = 0.0;
                _animationView.loadingStrLabel.alpha = 0.0;
                strongSelf.alpha = 0.0;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.0 animations:^{
                    [_animationView removeFromSuperview];
                } completion:^(BOOL finished){
                    strongSelf.alpha = 1.0;
                    [strongSelf removeFromSuperview];
                }];
            }];
            
            
        }
    }];
    
}
- (void)dismissImmediately{
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            [_timer invalidate];
            [_animationView removeFromSuperview];
            [_failView removeFromSuperview];
            [_successView removeFromSuperview];
        }
    }];
    
}

//加载失败
+ (void)showFailViewWithString:(NSString *)string{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[self sharedView] dismissImmediately];
//        [[self sharedView] showfailWith:string];
        [MBProgressHUD showError:string];
    });
    
}

- (void)showfailWith:(NSString *)string {
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            
            _failView = [HDWHLoadFailView view];
            [strongSelf addSubview:_failView];
            
            _failView.center = CGPointMake(strongSelf.center.x, strongSelf.center.y);
            
             _failView.size = CGSizeMake(155*LDScreenWidth/375, 156*LDScreenWidth/375);
            
            _failView.tishiLabel.text = string;
            _failView.tishiLabel.numberOfLines = 2;
            
            UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
            [appWindow addSubview:strongSelf];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dismissFail) userInfo:nil repeats:NO];
            //strongSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            strongSelf.backgroundColor = [UIColor clearColor];
        }
    }];
}
//加载成功
+ (void)showSuccessViewWithString:(NSString *)string{
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[self sharedView] dismissImmediately];
//        [[self sharedView] showSuccessWith:string];
        [MBProgressHUD showSuccess:string];
    });
    
    
}
- (void)showSuccessWith:(NSString *)string {
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            // strongSelf.backgroundColor = [UIColor redColor];
            _successView = [HDWHLoadSuccsessVIew view];
            [strongSelf addSubview:_successView];
            
            _successView.center = CGPointMake(strongSelf.center.x, strongSelf.center.y);
            _successView.size = CGSizeMake(155*LDScreenWidth/375, 156*LDScreenWidth/375);
            
            _successView.tishiLbale.text = string;
            
            UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
            [appWindow addSubview:strongSelf];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissSuccess) userInfo:nil repeats:NO];
            //strongSelf.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            strongSelf.backgroundColor = [UIColor clearColor];
            
        }
    }];
}

- (void)dismissSuccess{
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            [_timer invalidate];
            
            [UIView animateWithDuration:0.35 animations:^{
                _successView.subImageView.alpha = 0.0;
                _successView.tishiLbale.alpha = 0.0;
                strongSelf.alpha = 0.0;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.0 animations:^{
                    [_successView removeFromSuperview];
                } completion:^(BOOL finished){
                    strongSelf.alpha = 1.0;
                    [strongSelf removeFromSuperview];
                }];
            }];
            
        }
    }];
    
}

- (void)dismissFail{
    __weak HDLoading * weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong  HDLoading * strongSelf = weakSelf;
        if(strongSelf){
            [_timer invalidate];
            [UIView animateWithDuration:0.35 animations:^{
                _failView.subImageView.alpha = 0.0;
                _failView.tishiLabel.alpha = 0.0;
                strongSelf.alpha = 0.0;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.0 animations:^{
                    [_failView removeFromSuperview];
                } completion:^(BOOL finished){
                    strongSelf.alpha = 1.0;
                    [strongSelf removeFromSuperview];
                }];
            }];
            
            
        }
    }];
    
}

//加载jif动画
+ (void)showJifWithString:(NSString *)string toView:(UIView *)view{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        HDLoading * lodView = [[HDLoading alloc]initWithView:view];
        
        lodView.backgroundColor = WHColorFromRGB(0xf5f5f9);
        
        /** 加载动画图片 */
        UIImageView * jifImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 55*bili, 55*bili)];
        jifImageView.image = [UIImage sd_animatedGIFNamed:@"loadingJif"];
        jifImageView.center = lodView.center;
        [lodView addSubview:jifImageView];
        
        /** 加载文字提示 */
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, jifImageView.frame.origin.y + jifImageView.frame.size.height, lodView.frame.size.width, 21*bili)];
        
        label.text =  string.length == 0 ? @"正在加载。。。" : string;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15*bili];
        label.textColor = WHColorFromRGB(0x4279d6);
        [lodView addSubview:label];
        
        [view addSubview:lodView];
        
    }];
    
    
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

/** 移除加载 */
+ (void)hiddenLodJifToView:(UIView *)view{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
        HDLoading *loadView = [self LoadForView:view];
        if (loadView != nil) {
            [UIView animateWithDuration:0.35 animations:^{
                
                loadView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [loadView removeFromSuperview];
            }];
            
        }
    
    
    }];
    
    
}

+ (instancetype)LoadForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (HDLoading *)subview;
        }
    }
    return nil;
}

@end
