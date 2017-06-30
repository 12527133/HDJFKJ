//
//  SSImageView.m
//  diancaibao
//
//  Created by jujutec on 15/8/26.
//  Copyright (c) 2015年 jujutec. All rights reserved.
//

#import "SSImageView.h"
#import "AppDelegate.h"



@interface SSImageView ()
//全屏显示时图片的size
- (CGSize) preferredSize:(UIImage *)image;

@end

@implementation SSImageView
- (void)dealloc
{
    _contentView =nil;
    _imageView = nil;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _contentView=[[UIScrollView alloc]initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.delegate=self;
        _contentView.bouncesZoom=YES;
        
        _contentView.minimumZoomScale = 0.5;
        _contentView.maximumZoomScale = 5.0;
        
        _contentView.showsHorizontalScrollIndicator=NO;
        _contentView.showsVerticalScrollIndicator=NO;
        [self addSubview:_contentView];
        
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled =YES;
        [_contentView addSubview:_imageView];
        
        //为图片添加手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.enabled =YES;
        [tapGesture delaysTouchesBegan];
        [tapGesture cancelsTouchesInView];
        [_imageView addGestureRecognizer:tapGesture];
        
        //取消按钮
        _collectionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _collectionButton.frame =CGRectMake(frame.origin.x + frame.size.width  - 70, frame.origin.y + frame.size.height - 50, 60, 40);
        [_collectionButton setTitle:@"取消"forState:(UIControlStateNormal)];
        [self addSubview:_collectionButton];
        [_collectionButton addTarget:self action:@selector(didClickCollectionButtonAction:)forControlEvents:(UIControlEventTouchDown)];
        
        //删除按钮
        _deleteButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _deleteButton.frame =CGRectMake(10, frame.origin.y + frame.size.height - 50, 60, 40);
        [_deleteButton setTitle:@"删除"forState:(UIControlStateNormal)];
        [self addSubview:_deleteButton];
        [_deleteButton addTarget:self action:@selector(didClickDeleteButtonAction:)forControlEvents:(UIControlEventTouchDown)];
        
        //标题
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, LDScreenWidth, 44)];
        titleLabel.text = @"图片";
        titleLabel.textColor = WHColorFromRGB(0x051b28);
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //为视图增加边框
        _collectionButton.layer.masksToBounds=YES;
        _collectionButton.layer.cornerRadius = 5.0;
        _collectionButton.layer.borderWidth=1.0;
        _collectionButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        [_collectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //删除按钮
        _deleteButton.layer.masksToBounds=YES;
        _deleteButton.layer.cornerRadius = 5.0;
        _deleteButton.layer.borderWidth=1.0;
        _deleteButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
    
}
//取消按钮响应方法
- (void)didClickCollectionButtonAction:(UIButton *)button{
    
    [self hideImage];
    
    
}

//删除按钮响应方法
- (void)didClickDeleteButtonAction:(UIButton *)button{

    [self hideImage];
    
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deletePic" object:nil userInfo:@{@"picID" : _picID}];
    
}

- (void) setImage:(UIImage *) image {
    if (image) {
        CGSize size = [self preferredSize:image];
        _imageView.frame =CGRectMake(0, 0, size.width, size.height);
        
        _contentView.contentSize= size;
        
        _imageView.center =self.center;
        _imageView.image = image;
    }
}

- (CGSize) preferredSize:(UIImage *) image {
    
    CGFloat width = 0.0, height = 0.0;
    CGFloat rat0 = image.size.width / image.size.height;
    CGFloat rat1 =self.frame.size.width /self.frame.size.height;
    if (rat0 > rat1) {
        width =self.frame.size.width;
        height = width / rat0;
    }else {
        height =self.frame.size.height;
        width = height * rat0;
    }
    
    return CGSizeMake(width, height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat x = scrollView.center.x,y = scrollView.center.y;
    x = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :x;
    y = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : y;
    _imageView.center =CGPointMake(x, y);
}

- (void) showImageWithPicId:(NSString *)picID{
    
    _picID = picID;
    if (_picID == nil) {
        _deleteButton.hidden = YES;
    }
    
    _contentView.transform =CGAffineTransformMakeScale(0.1, 0.1);
    _contentView.alpha = 0;
    _collectionButton.alpha = 0;
    _deleteButton.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.alpha = 1.0;
        _collectionButton.alpha = 1.0;
        _deleteButton.alpha = 1.0;
        _contentView.transform =CGAffineTransformMakeScale(1, 1);
        _contentView.center=self.center;
    }];
    
}

-  (void) hideImage {
    titleLabel.alpha = 0;
    _collectionButton.alpha = 0;
    _deleteButton.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.transform =CGAffineTransformMakeScale(0.1, 0.1);
        _contentView.alpha = 0;
        _collectionButton.alpha = 0;
        
    }completion:^(BOOL finished) {
        if (finished) {
            _contentView.alpha=1;
            [_contentView removeFromSuperview];
            [_imageView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

+ (void) viewWithImage:(UIImage *) image picID:(NSString *)picID{
    
   
    
    AppDelegate * delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    UIWindow * window = delegate.window;
    SSImageView * imageViewer = [[SSImageView alloc]initWithFrame:window.frame];
    [imageViewer setImage:image];
    
    [window addSubview:imageViewer];
    [imageViewer showImageWithPicId:picID];
}


@end
