//
//  CameraDrawView.m
//
//
//  Created by Magel on 10-12-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CameraBankDrawView.h"

#define kTimeInterval	0.2f

#define kLength 40
#define ScanValue 10

#define kVerticalMargin   preSize.height / ScanValue
#define KHeight (preSize.height - kVerticalMargin*2.0)
#define kHorizontalMargin (preSize.width-KHeight/1.58)*0.5
@interface CameraDrawView()
@property(nonatomic,assign) BOOL showUp;
@property(nonatomic,assign) BOOL showRight;
@property(nonatomic,assign) BOOL showBottom;
@property(nonatomic,assign) BOOL showLeft;
@end

@implementation CameraDrawView
@synthesize delegate;
//- (void)dealloc {
//    [_lable release];
//    [super dealloc];
//}
- (id)initWithFrame:(CGRect)frame{
    
    
    if ((self = [super initWithFrame:frame])) {
        
        // Initialization code
        
        boundColor = [UIColor whiteColor];
        
        beat = YES;
        CGRect rect = CGRectMake(-6, 273, 500, 21);
        
        _lable = [[UILabel alloc] initWithFrame:rect];
        
//        _lable.text = @"请将身份证置于此区域  并尝试对齐边缘";
        _lable.textColor = [UIColor whiteColor];
        _lable.font = [UIFont boldSystemFontOfSize:14];
        _lable.backgroundColor = [UIColor clearColor];
        _lable.transform=CGAffineTransformMakeRotation(M_PI/2);
        _lable.textAlignment = NSTextAlignmentCenter;
        
        _lable.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/1.2,[[UIScreen mainScreen] bounds].size.height/2);

        [self addSubview:_lable];
    }
    return self;
}
-(void)showText:(NSString *)text
{
    if (_lable != NULL) {
        _lable.text = text;
    }
}
- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)drawRect:(CGRect)rect {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    CGFloat lineWidth  = 6;
    CGFloat viewWidth = preSize.width;
    CGFloat viewHeight = preSize.height;
    //NSLog(@"%f %f",viewWidth,viewHeight);
    _beginPoint = CGPointMake(kVerticalMargin, kHorizontalMargin);
    _endPoint = CGPointMake(viewHeight-kVerticalMargin, viewWidth - kHorizontalMargin);
//    _beginPoint.x = _beginPoint.x ;
//    _endPoint.x = _endPoint.x;
    // Drawing code
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(_beginPoint.y,
                                      _beginPoint.x,
                                      _endPoint.y-_beginPoint.y,
                                      _endPoint.x- _beginPoint.x);
    
    UIImageView * CenterImageView = [[UIImageView alloc] init];

    CenterImageView.transform=CGAffineTransformMakeRotation(M_PI/2);
    
    CenterImageView.frame = clearDrawRect;

    [self addSubview:CenterImageView];
    
    if (self.IsBankCard) {
        
//        [CenterImageView setImage:[UIImage imageNamed:@"dingdantishi"]];

        
    }else{
        
        if (self.IsPositive == YES) {
            
            [CenterImageView setImage:[UIImage imageNamed:@"Group-1"]];

            
        }else{
            
            [CenterImageView setImage:[UIImage imageNamed:@"反面"]];
            
        }
    
    }
    
    self.ImageDrawViewFrame = CenterImageView.frame;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:currentContext rect:screenDrawRect];
    
    [self addCenterClearRect:currentContext rect:clearDrawRect];
    if (beat == YES) {
        CGContextSetStrokeColorWithColor(currentContext, [boundColor CGColor]);
        if(boundColor == [UIColor greenColor] || boundColor == [UIColor redColor])
            
            beat = NO;
    }
    else {
        CGContextSetStrokeColorWithColor(currentContext, [[UIColor clearColor] CGColor]);
        beat = YES;
    }
    CGContextSetLineWidth(currentContext, lineWidth);
    //	CGContextAddRect(currentContext, CGRectMake(40, 15, 240, 400));
    
//    CGPoint newPoints1[] = {
//        CGPointMake(_beginPoint.y, _beginPoint.x+kLength),
//        CGPointMake(_beginPoint.y, _beginPoint.x),
//        CGPointMake(_beginPoint.y+kLength, _beginPoint.x)
//    };
//    CGContextAddLines(currentContext, newPoints1, 3);
//    CGContextStrokePath(currentContext);
//    
//    CGPoint newPoints2[] = {
//        CGPointMake(_endPoint.y, _beginPoint.x+kLength),
//        CGPointMake(_endPoint.y, _beginPoint.x),
//        CGPointMake(_endPoint.y-kLength, _beginPoint.x)
//    };
//    CGContextAddLines(currentContext, newPoints2, 3);
//    CGContextStrokePath(currentContext);
//    
//    CGPoint newPoints3[] = {
//        CGPointMake(_beginPoint.y, _endPoint.x-kLength),
//        CGPointMake(_beginPoint.y, _endPoint.x),
//        CGPointMake(_beginPoint.y+kLength, _endPoint.x)
//    };
//    CGContextAddLines(currentContext, newPoints3, 3);
//    CGContextStrokePath(currentContext);
//    
//    CGPoint newPoints4[] = {
//        CGPointMake(_endPoint.y-kLength, _endPoint.x),
//        CGPointMake(_endPoint.y, _endPoint.x),
//        CGPointMake(_endPoint.y, _endPoint.x-kLength)
//    };
//    CGContextAddLines(currentContext, newPoints4, 3);
//    CGContextStrokePath(currentContext);
//    
    
    //画四条边
    //上边
//    if (self.showUp) {
//            CGPoint lineUpPoints[] = {
//                CGPointMake(kHorizontalMargin+kLength, kVerticalMargin),
//                CGPointMake(viewWidth-kHorizontalMargin, kVerticalMargin),
//        };
//        CGContextAddLines(currentContext, lineUpPoints, 2);
//        CGContextStrokePath(currentContext);
//    }

    //    //右边
//    if (self.showRight) {
//                 CGPoint lineRightPoints[] = {
//                  CGPointMake(viewWidth-kHorizontalMargin, kVerticalMargin+kLength),
//                CGPointMake(viewWidth-kHorizontalMargin, viewHeight-kVerticalMargin-kLength),
//            };
//            CGContextAddLines(currentContext, lineRightPoints, 2);
//            CGContextStrokePath(currentContext);
//        }
//        //下边
//        if (self.showBottom) {
//            CGPoint lineBottomPoints[] = {
//                CGPointMake(kHorizontalMargin + kLength, viewHeight-kVerticalMargin),
//                CGPointMake(viewWidth-kHorizontalMargin-kLength, viewHeight-kVerticalMargin),
//            };
//            CGContextAddLines(currentContext, lineBottomPoints, 2);
//            CGContextStrokePath(currentContext);
//        }
//    
//    //    //左边
//        if (self.showLeft) {
//            CGPoint lineLeftPoints[] = {
//                CGPointMake(kHorizontalMargin, kVerticalMargin+kLength),
//                CGPointMake(kHorizontalMargin, viewHeight-kVerticalMargin-kLength),
//            };
//            CGContextAddLines(currentContext, lineLeftPoints, 2);
//            CGContextStrokePath(currentContext);
//        }
}


- (void)changeBoundColor: (UIColor *)theColor
{
    boundColor = theColor;
    //	[self setNeedsDisplay];
}


-(void)showLineUP:(BOOL)up right:(BOOL)right bottom:(BOOL)bottom left:(BOOL)left{
    self.showUp = up;
    self.showRight = right;
    self.showBottom = bottom;
    self.showLeft = left;
    //[self setNeedsDisplay];
}
-(CGPoint)getBeginPoint{
    return _beginPoint;
}
-(CGPoint)getEndPoint{
    return _endPoint;
}
-(void)SetPreSize:(CGSize)size
{
    preSize.height = size.height;
    preSize.width = size.width;
    
    CGFloat viewWidth = preSize.width;
    CGFloat viewHeight = preSize.height;
    _beginPoint = CGPointMake(kVerticalMargin, kHorizontalMargin);
    _endPoint = CGPointMake(viewHeight-kVerticalMargin, viewWidth - kHorizontalMargin);
}
@end
