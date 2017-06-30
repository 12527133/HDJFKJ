

#import "HDHistoryPreView.h"
#import "AppDelegate.h"
#import "HDMaterialOperate.h"


@interface HDHistoryPreView ()
//全屏显示时图片的size
- (CGSize) preferredSize:(UIImage *)image;

@end

@implementation HDHistoryPreView

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
        
        _contentView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-60)];
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
        
//        //为图片添加手势
//        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
//        tapGesture.numberOfTapsRequired = 1;
//        tapGesture.enabled =YES;
//        [tapGesture delaysTouchesBegan];
//        [tapGesture cancelsTouchesInView];
//        [_imageView addGestureRecognizer:tapGesture];
        
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,frame.origin.y + frame.size.height - 60, frame.size.width, 60)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, bottomView.frame.size.width, 0.5)];
        lineView.backgroundColor = WHColorFromRGB(0xdedede);
        [bottomView addSubview:lineView];
        
        //取消按钮
        _collectionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _collectionButton.frame =CGRectMake(frame.origin.x + frame.size.width  - 90, frame.origin.y + frame.size.height - 50, 80, 40);
        [_collectionButton setTitle:@"取消选择"forState:(UIControlStateNormal)];
        [self addSubview:_collectionButton];
        [_collectionButton addTarget:self action:@selector(didClickCollectionButtonAction:)forControlEvents:(UIControlEventTouchDown)];
        
//        //删除按钮
//        _deleteButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//        _deleteButton.frame =CGRectMake(10, frame.origin.y + frame.size.height - 50, 60, 40);
//        [_deleteButton setTitle:@"删除"forState:(UIControlStateNormal)];
//        [self addSubview:_deleteButton];
//        [_deleteButton addTarget:self action:@selector(didClickDeleteButtonAction:)forControlEvents:(UIControlEventTouchDown)];
        
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
    
//    [self.delegate changePreView:self picture:nil];
    
    if (self.picModel) {
        [self.delegate changePreView:self picture:self.picModel];
    }
}

//删除按钮响应方法
- (void)didClickDeleteButtonAction:(UIButton *)button{
    if (self.picModel) {
        [self.delegate changePreView:self picture:self.picModel];
    }  
}

- (void) setPicture:(HDPictureModel *) picture {
    if (picture) {
        
        self.picModel = picture;
        
        if (picture.thumbnail != nil) {
            
            _imageView.image = [HDMaterialOperate readImageWithImageName:picture.picUrl];
            
        }else{
            [_imageView sd_setImageWithURL:[NSURL URLWithString:picture.picUrl] placeholderImage:[UIImage imageNamed:@"相机"]];
            
        }
        
        CGSize size = [self preferredSize:_imageView.image];
         _contentView.contentSize= size;
        _imageView.frame =CGRectMake(0, 0, size.width, size.height);
        //_imageView.center =self.center;
        _contentView.center = CGPointMake(self.frame.size.width/2.0, (self.frame.size.height -60)/2.0);
        _imageView.center = _contentView.center;
    }
}

- (CGSize) preferredSize:(UIImage *) image {
    
    CGFloat width = 0.0, height = 0.0;
    CGFloat rat0 = image.size.width / image.size.height;
    //CGFloat rat1 =self.frame.size.width /self.frame.size.height;
    CGFloat rat1 = _contentView.frame.size.width/_contentView.frame.size.height;
    if (rat0 > rat1) {
        //width =self.frame.size.width;
        width = _contentView.frame.size.width;
        height = width / rat0;
    }else {
        //height =self.frame.size.height;
        height = _contentView.frame.size.height;
        width = height * rat0;
    }
    
    return CGSizeMake(width, height);
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return _imageView;
//}


-  (void) hideImage {
    [self.delegate changePreView:self picture:nil];
}


@end
