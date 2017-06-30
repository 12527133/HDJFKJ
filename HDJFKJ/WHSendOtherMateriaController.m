

#import "WHSendOtherMateriaController.h"
#import "WHSendImageRequest.h"
#import "WHUserLoginModel.h"
#import "AuthorizViewController.h"
#import "SSImageView.h"
#import "WHImageSaveAndLoad.h"
/** 图片模型  */
#import "HDPictureModel.h"

/** 上传图片返回信息模型*/
#import "HDPicBackModel.h"

/** 保存图片到本地，删除本地图片*/
#import "HDMaterialOperate.h"

/** 图片资料模型 */
#import "HDMaterialModel.h"

/** 基本按钮类 */
#import "HDBaseButton.h"

/** 历史资料照片控制器  */
#import "HDHistoryPictureController.h"

/** 历史资料模型  */
#import "HDHistoryPictureModel.h"

/** 历史资料列表模型 */
#import "HDHistoryPictureList.h"


@interface WHSendOtherMateriaController ()<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) float labelheight;

@property (nonatomic, assign) float viewHeight;

@property (nonatomic, assign) float imageViewWdith;
@property (nonatomic, assign) float distance;


@property (nonatomic, strong) UICollectionView * collectionView1;

@property(nonatomic,strong)UILabel * ThreeLabel;



@property (nonatomic, strong) NSDateFormatter * fmt;



@property (nonatomic,strong)  NSIndexPath * currentIndexPath;

@property (nonatomic, strong) UIAlertController * alertVC;
@property (nonatomic, strong) UIImagePickerController * picker;

@property (nonatomic, strong) HDPictureModel * pictureModel;

//延迟刷新数据
@property (nonatomic, strong) NSTimer * reloadTimer;

/** 历史资料照片数据label */
@property (nonatomic, strong) UILabel * historyLabel;



/** 历史资料数量  */
@property (nonatomic, assign) NSInteger historyPictureCount;

@end

@implementation WHSendOtherMateriaController


//相机，相册选择窗
- (UIAlertController *)alertVC{
    if (!_alertVC) {
        
        __weak typeof(self)weakself = self;
        _alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself chooseCamera];
        }]];
        
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself choosePhoto];
        }]];
    }
    return _alertVC;
}

-(UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}


- (NSMutableArray *)pictureArray{
    
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc]init];
    }
    
    return _pictureArray;
}

- (NSMutableArray *)otherArray{
    
    if (!_otherArray) {
        _otherArray = [[NSMutableArray alloc]init];
    }
    return _otherArray;
}


- (NSDateFormatter *)fmt{
    
    if (!_fmt) {
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _fmt.dateFormat = @"yyyyMMddHHmmssSSS";
    }
    return _fmt;
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView1 reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传其他资料";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageViewWdith = LDScreenWidth/4;
    
    /** 获取用户其他资料 */
    [self gethistoryPictureArray];
    
    /** 创建视图  */
    [self createViewAction];
    
    /** 注册删除图片通知  */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePicRequest:) name:@"deletePic" object:nil];
    
    
}


/**
 * 创建视图方法
 * 创建选择照片按钮
 * 创建展示图片的CollectionView
 **/
- (void)createViewAction{
    
    /** 1.创建查看历史图片的视图、按钮  */
    UIView * historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45)];
    historyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:historyView];
    
    
    
    /** 2.资料照片信息Label*/
    self.historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, LDScreenWidth -45, historyView.frame.size.height)];
    self.historyLabel.textAlignment = NSTextAlignmentLeft;
    self.historyLabel.textColor = WHColorFromRGB(0x323232);
    self.historyLabel.font = [UIFont systemFontOfSize:15];
    self.historyLabel.text = @"已有0张资料照片,可从中选择";
    [historyView addSubview:self.historyLabel];
    
    /** 3.箭头图片 */
    UIImageView * arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 19, 17, 6, 11)];
    arrowImage.image = [UIImage imageNamed:@"返回"];
    [historyView addSubview:arrowImage];
    
    /** 4.覆盖在上面的按牛 */
    HDBaseButton * historyButton = [[HDBaseButton alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 45)];
    [historyView addSubview:historyButton];
    [historyButton addTarget:self action:@selector(clickHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 分割线  */
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, LDScreenWidth , 0.5)];
    lineView.backgroundColor = LDRGBColor(50, 50, 50, 0.2);
    [historyView addSubview:lineView];
    
    
    /** 图片调回Label*/
    UILabel * subLabel = subLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, LDScreenWidth-30, 45)];
    subLabel.textColor = WHColorFromRGB(0x323232);
    subLabel.textAlignment = NSTextAlignmentLeft;
    
    subLabel.backgroundColor = [UIColor whiteColor];
    subLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:subLabel];
    subLabel.text = @"如工资流水、信用卡正面照、近三个月社保/公积金缴纳凭证或截图";
    subLabel.numberOfLines = 2;
    
    
    /** 5.创建加载图片的CollectionView  */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 2; //上下的间距 可以设置0看下效果
    
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0);
    self.collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0,90 , LDScreenWidth, LDScreenHeight - 115 -  45 - 40 ) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView1];
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    self.collectionView1.backgroundColor = [UIColor whiteColor];
    [self.collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView1 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    
    NSLog(@"%f",self.collectionView1.frame.size.height);
    NSLog(@"%f",self.collectionView1.frame.origin.y);
    /** 6.下一步按钮  */
    float buttonHeight = 45;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - buttonHeight - 64, LDScreenWidth, buttonHeight)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setBackgroundColor:WHColorFromRGB(0x4279d6)];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    
}

/** 点击查看更多历史照片按钮 */
- (void)clickHistoryButton:(HDBaseButton *)sender{
    
    if (self.historyPictureCount > 0) {
        HDHistoryPictureController * historyVC = [[HDHistoryPictureController alloc]init];
        historyVC.sendMaterial = self;
        [self.navigationController pushViewController:historyVC animated:YES];
    }
    
}

#pragma mark -- collectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.otherArray.count+1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString * CellIdentifier = @"cell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView *subImageView= nil;
    
    
    for (UIImageView * selectView in cell.contentView.subviews) {
        subImageView = selectView;
    }
    if (subImageView == nil) {
        subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [cell.contentView addSubview:subImageView];
    }
    subImageView.image = [UIImage imageNamed:@"相机"];
    
    if (indexPath.row != 0) {
        HDPictureModel * picModel = self.otherArray[indexPath.row - 1];
        if ( [picModel.picUrl rangeOfString:@"http"].length > 0) {
            [subImageView sd_setImageWithURL:[NSURL URLWithString:picModel.picUrl] placeholderImage:[UIImage imageNamed:@"相机"]];
        }else{
            subImageView.image = picModel.thumbnail;
        }
    }
    return cell;
    
}
//设置元素的的大小框

#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((LDScreenWidth -10)/4-2, (LDScreenWidth -10)/4-2);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0,5);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    if (indexPath.row != 0) {
        UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
        HDPictureModel * picModel = self.otherArray[indexPath.row -1];
        //        if (picModel.thumbnail != nil) {
        //
        //            [SSImageView viewWithImage:[HDMaterialOperate readImageWithImageName:picModel.picUrl] picID:picModel.picId];
        //
        //        }else{
        //
        //
        //        }
        for (UIImageView * selectView in cell.contentView.subviews) {
            
            [SSImageView viewWithImage:selectView.image picID:picModel.picId];
        }
    }
    else{
        [self presentViewController:self.alertVC animated:YES completion:nil];
    }
    
}

//选择相机
- (void)chooseCamera{
    
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.picker.delegate = self;
        //设置拍照后的图片可被编辑
        self.picker.allowsEditing = NO;
        
    }
    [self presentViewController:self.picker animated:YES completion:nil];
}


//选择相册
- (void)choosePhoto{
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        self.picker.delegate = self;
        //设置拍照后的图片可被编辑
        self.picker.allowsEditing = NO;
        
    }
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    //退出相机或相册界面
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    
    //开启子线程
    dispatch_queue_t queue = dispatch_queue_create("SecondConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
        [self showWithImageWithString:@"上传中..."];
        //获取选择的图片
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        //发送上传图片请求
        [self sendImageRequestWithImageData:image];
        
        
    });
    
}



//发送图片请求
- (void)sendImageRequestWithImageData:(UIImage *) image{
    
    //压缩图片
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil){
        data = UIImageJPEGRepresentation(image, 0.0);
    }else{
        data = UIImageJPEGRepresentation(image, 0.0);
        NSLog(@"------%zu",sizeof(data));
    }
    
    NSString * str = [NSString stringWithFormat:@"%@upload",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    NSString * imageName = @"other";
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:@"other" forKey:@"name"];
    [params setObject:@"jpg" forKey:@"type"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params imageData:data name:imageName fileName:@"image.jpg" mimeType:@"image.jpg" callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.请求错误提示*/
            [self showFailViewWithString:@"网络错误"];
            
            /** 2.打印错误信息 */
            LDLog(@"UIImagePickerControllerOriginalImage--error请求失败%@",error);
        }else{
            
            HDPicBackModel * backModel = [HDPicBackModel mj_objectWithKeyValues:response];
            
            //code == 200请求成功
            if ([backModel.errcode isEqualToString:@"200"]) {
                [self dismissHDLoading];
                
                //给窗新的图片模型
                self.pictureModel = [[HDPictureModel alloc]init];
                //self.pictureModel.picUrl = [self getCurrentTime];
                self.pictureModel.picUrl = backModel.absolutePath;
                self.pictureModel.picId = backModel.picId;
                
                //保存新上传的图片到本地
                
                [HDMaterialOperate saveMaterialImageWith:[self fixOrientation:image] ImageName:self.pictureModel.picUrl];
                
                //生成缩略图
                self.pictureModel.thumbnail = [self imageCompressForWidth:image targetWidth:self.self.imageViewWdith*2];
                
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[self.otherArray addObject:self.pictureModel];
                    if (self.otherArray.count == 0) {
                        [self.otherArray addObject:self.pictureModel];
                    }
                    else{
                        [self.otherArray insertObject:self.pictureModel atIndex:0];
                    }
                    
                    
                    self.historyPictureCount += 1;
                    self.historyLabel.text = [NSString stringWithFormat:@"已有%ld张资料照片,可从中选择", (long)self.historyPictureCount];
                    
                    [self.collectionView1 reloadData];
                });
                
            }else{
                // 显示失败信息
                [self showFailViewWithString:backModel.msg];
            }
            LDLog(@"%@",response);
        }
    }];
}




//跳转加载银行卡
-(void)clickNext{
    
    [self.reviewInfonmation.pictureArr removeAllObjects];
    [self.reviewInfonmation.pictureArr addObjectsFromArray:[self.otherArray copy]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//删除图片
- (void)deletePicRequest:(NSNotification *) notification{
    
    /** 4.删除数组数据，*/
    [self.otherArray removeObjectAtIndex:self.currentIndexPath.row -1];
    
    [_collectionView1 reloadData];
    
    
}
- (void)reloadCollection{
    
    
    [_collectionView1 reloadData];
    
    [self.reloadTimer invalidate];
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (NSString *)getCurrentTime{
    //把当前时间转化成字符串
    NSDate* now = [NSDate date];
    
    NSString* nowDateString = [self.fmt stringFromDate:now];
    return nowDateString;
}


- (void)gethistoryPictureArray{
    
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/historyPictureInfo",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            NSLog(@"%@",error);
            
            /** 1.网络请求错误提示*/
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 2.解析返回结果  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 3.解析返回的照片数据 */
                if (backInfo.result != nil) {
                    HDHistoryPictureModel * materialModel = [HDHistoryPictureModel mj_objectWithKeyValues:backInfo.result];
                    
                    for (HDHistoryPictureList * picureList in materialModel.others) {
                        self.historyPictureCount += picureList.picList.count;
                    }
                    
                }
                
                
                self.historyLabel.text = [NSString stringWithFormat:@"已有%ld张资料照片,可从中选择", (long)self.historyPictureCount];
                
                
            }else{
                /** 6.请求异常提示 **/
                [self showFailViewWithString:backInfo.message];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

@end
