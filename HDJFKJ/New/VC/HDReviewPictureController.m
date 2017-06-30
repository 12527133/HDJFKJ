

#import "HDReviewPictureController.h"
#import "HDPictureModel.h"
#import "HDPicBackModel.h"
#import "SSImageView.h"
#import "WHImagPickerController.h"
#import "HDYangLiController.h"
#import "AFHTTPRequestOperation.h"
#import "USImagePickerController.h"
#import "HDMaterialOperate.h"


@interface HDReviewPictureController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,USImagePickerControllerDelegate>
/** 1.加载图片资料的collectionView */
@property (nonatomic, strong) UICollectionView * collectionView1;

/** 4.当前点击的cell */
@property (nonatomic, strong) NSIndexPath * currentIndexPath;

/** 5.相机，相册选择窗 */
@property (nonatomic, strong) UIAlertController * alertVC;

/** 6.相机相册对象  */
@property (nonatomic, strong) UIImagePickerController * picker;

/** 7.图片模型 */
@property (nonatomic, strong) HDPictureModel * pictureModel;

/** 8.时间格式 */
@property (nonatomic, strong) NSDateFormatter * fmt;

/** 9.图锐相机 */
@property (nonatomic,strong) SCCaptureCameraController * CameraController;

/** 10.扫描后获得的照片 */
@property (nonatomic,strong) UIImage * IDImage;

/** 11.发送图片的管理者 */
@property (nonatomic, strong) AFHTTPSessionManager * marg;

/** 12.显示进度的Label  */
@property (nonatomic, strong) UILabel * progressLabel;

/** 13.当前加载上传图片的Cell */
@property (nonatomic, strong) UICollectionViewCell * currentCell;

/** 14.解析后的图片数组 */
@property (nonatomic, strong) NSMutableArray * handlePicArr;

/** 15.处理后图片数组元素的个数 */
@property (nonatomic, assign) NSInteger handleArrCount;

/** 16.选取一个处理后的照片 */
@property (nonatomic, strong) UIImage * handleImage;

@end

@implementation HDReviewPictureController


/** 贷款申请表 数组*/
- (NSMutableArray *)actContractArr{
    if (!_actContractArr) {
        _actContractArr = [[NSMutableArray alloc]init];
    }
    return _actContractArr;
    
}
/** 收入补充证明 数组 */
- (NSMutableArray *)rentContractArr{
    if (!_rentContractArr) {
        _rentContractArr = [[NSMutableArray alloc]init];
    }
    return _rentContractArr;
}
/** 网络请求管理器 */
- (AFHTTPSessionManager *)marg{
    if (!_marg) {
        _marg = [AFHTTPSessionManager manager];
    }
    return _marg;
}

/** 加载进度label */
- (UILabel *)progressLabel{
    
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth/5, LDScreenWidth/5)];
        
        _progressLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        _progressLabel.textColor = [UIColor whiteColor];
        
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        
        _progressLabel.font = [UIFont systemFontOfSize:10];
        
        _progressLabel.numberOfLines = 2;
        
        _progressLabel.text =@"图片上传中\n0%";
    }
    return _progressLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    /** 1.设置标题  */
    self.title = @"上传合同信息";
    
    /** 2.设置背景色  */
    self.view.backgroundColor = WHColorFromRGB(0xf5f5f9);
    
    self.navigationController.navigationBar.backgroundColor = WHColorFromRGB(0x3492e9);
    
    
    
    /** 3.创建视图    */
    [self createViewAction];
    
    
    LDLog(@"%@",self.packageId);
    
    /** 拍摄成功 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CameraControllerSuccessButtonClick) name:@"CameraControllerSuccessButtonClick" object:nil];
    /** 取消拍照 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancleButtonRemove) name:@"cancleNotication" object:nil];
    /** 创建导航栏左侧按钮  */
    //[self createNavLeftButton];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CameraControllerSuccessButtonClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancleNotication" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deletePic" object:nil];
    
    
    LDLog(@"销毁上传合同信息控制器");
    
}


/** 打开图锐相机拍摄 */
- (void)showAliveVC:(NSInteger )index{
    
    SCCaptureCameraController * CameraController = [[SCCaptureCameraController alloc] init];
    
    CameraController.scNaigationDelegate = self;
    
    CameraController.iCardType = TIDCARD2;
    
    CameraController.isDisPlayTxt = NO;
    
    if (index == 0) {
        
        CameraController.IsPositive = YES;
    
    }else{
        
        CameraController.IsPositive = NO;
    
    }
    
    self.CameraController = CameraController;
    
    [self presentViewController:CameraController animated:YES completion:nil];
    
}
/** 关闭图锐相机 */
- (void)cancleButtonRemove{
    self.CameraController = nil;
}

/** 获取图锐拍摄后的图片*/
- (void)CameraControllerSuccessButtonClick{
    
    if ((self.currentIndexPath.row == 0)&& (self.CameraController.IsPositive== YES)) {
        
        
        self.zhengmianImage = self.IDImage;
        
    }
    
    if ((self.currentIndexPath.row == 1)&& (self.CameraController.IsPositive == NO)) {
        
        self.fanmianImage = self.IDImage;
    }
    
    self.CameraController = nil;
}

// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    
    //    self.IsPositive = YES;
    //    self.IDCardModel.name = name;
    //    self.IDCardModel.sex = sex;
    //    self.IDCardModel.folk = folk;//民族
    //    self.IDCardModel.birthday = birthday;
    //    self.IDCardModel.address = address;
    //    self.IDCardModel.IDCardNumber = num;//身份证号
    //    self.IDCardModel.jobType = self.jobType;
}

// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period
{
    //    self.IsPositive = NO;
    //    self.IDCardModel.IDCardTimer = period;
    //    NSArray * arr = [period componentsSeparatedByString:@"-"];
    //    if (arr.count == 2) {
    //        self.IDCardModel.idTermBegin = [self getSumeTimeWithCurrentTime:arr[0] minute:0 dataFormet:@"yyyy-MM-dd"];
    //
    //        if ([arr[1] isEqualToString:@"长期"]){
    //            self.IDCardModel.idTermEnd = arr[1];
    //
    //        }else{
    //            self.IDCardModel.idTermEnd = [self getSumeTimeWithCurrentTime:arr[1] minute:0 dataFormet:@"yyyy-MM-dd"];
    //        }
    //
    //
    //
    //    }
}

//获取拍照的图片
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
{
    
    /** 主线程中*/
    dispatch_async(dispatch_get_main_queue(), ^{
        self.CameraController.successButton.hidden = YES;
    });
    
    /** 关闭图锐控制器 */
    [self dismissViewControllerAnimated:YES completion:^{
        
        /** 子线程中操作数据 */
        dispatch_queue_t queue = dispatch_queue_create("sendTakeImageQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            
            self.IDImage = cardImage;
            
            [self CameraControllerSuccessButtonClick];
            
            NSMutableArray * array = [[NSMutableArray alloc]init];
            [array addObject:cardImage];
            
            
            [self setHandlePicArrData:array];
        });
        
        
    }];
    
    
}
/**
 * 创建视图方法
 * 创建选择照片按钮
 * 创建展示图片的CollectionView
 **/
- (void)createViewAction{
    float buttonheight = 50 * LDScreenWidth/375;
    
    /** 1.创建加载图片的CollectionView  */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    self.collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0 , LDScreenWidth, LDScreenHeight - 64 - buttonheight ) collectionViewLayout:layout];
    
    [self.view addSubview:self.collectionView1];
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    self.collectionView1.backgroundColor = [UIColor whiteColor];
    [self.collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    /*
     第一个参数:header视图对象的类型
     第二个参数:区分是header还是后面的footer
     // UICollectionElementKindSectionHeader表示header类型
     第三个参数:重用标志
     */
    [self.collectionView1 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    [self.collectionView1 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    
    /** 2.提交审核按钮 */
    UIButton * QRbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - buttonheight -64, LDScreenWidth, buttonheight)];
    [QRbutton setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.view addSubview:QRbutton];
    [QRbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QRbutton setBackgroundColor:WHColorFromRGB(0x3492e9)];
    [QRbutton addTarget:self action:@selector(clickCreateQR:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


#pragma mark -- collectionViewDateSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        
        // 从重用队列里面获取
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        // 设置背景颜色
        header.backgroundColor = [UIColor whiteColor];
        
        //设置标题
        UILabel * subLabel = nil;
        for (UILabel * label in header.subviews) {
            
            
            subLabel = label;
            if (label != nil) {
                break;
            }
        }
        if (subLabel == nil) {
            subLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, LDScreenWidth-15, header.frame.size.height)];
            subLabel.textColor = WHColorFromRGB(0x323232);
            subLabel.textAlignment = NSTextAlignmentLeft;
            subLabel.font = [UIFont boldSystemFontOfSize:14];
            [header addSubview:subLabel];
        }
        if (indexPath.section == 0) {
            subLabel.text = @"上传身份证照片（正，反面，手持身份证照）";
        }
        else if (indexPath.section == 1){
            subLabel.text = @" 贷款申请表（可添加多张）";
            
        }
        else{
            subLabel.text = @"收入补充证明（分期金额大于5万时提供）";
        }
        
        //设置标题下的横线
        UIView * linView = nil;
        if (header.subviews.count > 1) {
            for (UIView * view in header.subviews) {
                linView = view;
            }
        }
        if (linView == nil) {
            linView = [[UIView alloc]initWithFrame:CGRectMake(15, header.frame.size.height -0.5, LDScreenWidth - 15, 0.5)];
            linView.backgroundColor = WHColorFromRGB(0xededed);
            [header addSubview:linView];
        }
        
        
        return header;
        
    }else if (kind == UICollectionElementKindSectionFooter) {
        // footer
        
        // 从重用队列里面获取
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        //设置背景色
        if (indexPath.section != 2) {
            footer.backgroundColor = WHColorFromRGB(0xf5f5f9);
        }
        else{
            footer.backgroundColor = [UIColor clearColor];
        }
        
        return footer;
    }
    
    return nil;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(LDScreenWidth, 43);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(LDScreenWidth, 15);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0){
        
        return 3;
    }
    
    else if (section == 1) {
        if (self.currentIndexPath.section == 1 && self.handlePicArr.count > 0) {
            return self.rentContractArr.count + 2;
        }else{
            
            return self.rentContractArr.count+1;
        }
        
    }
    else{
        
        if (self.currentIndexPath.section == 2 && self.handlePicArr.count > 0) {
            return self.actContractArr.count + 2;
        }
        return self.actContractArr.count+1;
    }
    
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
    
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                subImageView.image = [UIImage imageNamed:@"camer_zheng"];
                break;
            case 1:
                subImageView.image = [UIImage imageNamed:@"camer_fan"];
                break;
            default:
                subImageView.image = [UIImage imageNamed:@"camer_face"];
                break;
        }
        
    }else{
        
        subImageView.image = [UIImage imageNamed:@"相机"];
    }
    
    
    
    if (indexPath.section == 0){
        
        if (indexPath.row == 0 && self.zhengmianImage != nil) {
            subImageView.image = self.zhengmianImage;
        }
        if (indexPath.row == 1 && self.fanmianImage != nil){
            
            subImageView.image = self.fanmianImage;
        }
        if (indexPath.row == 2 && self.faceImage != nil) {
            subImageView.image = self.faceImage;
        }
    }else{
        if (indexPath.row != 0) {
            
            
            
            HDPictureModel * picModel= nil;
            
            UIImage * nowImage = nil;
            
            if (indexPath.section == 1) {
                
                
                if (indexPath.row == self.rentContractArr.count + 1) {
                    nowImage = self.handleImage;
                }else{
                    picModel = self.rentContractArr[indexPath.row - 1];
                    
                    nowImage = picModel.thumbnail;
                }
                
            }
            if(indexPath.section == 2) {
                
                if (indexPath.row == self.actContractArr.count + 1) {
                    nowImage = self.handleImage;
                }else{
                    picModel = self.actContractArr[indexPath.row -1];
                    nowImage = picModel.thumbnail;
                }
                
            }
            
            subImageView.image = nowImage;
            
        }
        
    }
    
    if (indexPath == self.currentIndexPath) {
        
        [cell addSubview:self.progressLabel];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0 && self.zhengmianImage == nil) {
                [self.progressLabel removeFromSuperview];
            }
            if (indexPath.row == 1 && self.fanmianImage == nil) {
                [self.progressLabel removeFromSuperview];
            }
            if (indexPath.row == 2 && self.faceImage == nil) {
                [self.progressLabel removeFromSuperview];
            }
        }
    }
    
    return cell;
    
}
//设置元素的的大小框

#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LDScreenWidth/5, LDScreenWidth/5);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(30 * LDScreenWidth/375, 15, 36* LDScreenWidth/375, 15);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    
    self.currentCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    /** 点击第一行cell 拍摄身份证照片 */
    if (indexPath.section == 0){
        if (indexPath.row != 2) {
            [self showAliveVC:indexPath.row];
        }
        else{
            [self pushYangli];
        }
        
    }else{
    
        if (indexPath.row != 0) {/** 预览上传后照片 */
            
            HDPictureModel * picModel = nil;
            
            if (indexPath.section == 0) {
                picModel = self.rentContractArr[indexPath.row -1];
            }
            else{
                picModel = self.actContractArr[indexPath.row -1];
            }
        }
        else{ /** 选取需要上传的图片 */
            
            [self presentViewController:self.alertVC animated:YES completion:nil];
            
            
        }
    }
    
    
    
    
}
/**拍摄手持身份证照片先，打开样例界面 */
- (void)pushYangli{
    
    HDYangLiController * yangli = [[HDYangLiController alloc]init];
    [self.navigationController pushViewController:yangli animated:YES];
    
    yangli.completionBlock = ^{
        [self chooseCamera];
    };
    
}


/**
 * 相机，相册选择窗
 **/
- (UIAlertController *)alertVC{
    if (!_alertVC) {
        __weak typeof(self)weakself = self;
        
        _alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }]];
        
        [_alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
    }
    return _alertVC;
}

/**
 * 延迟加载相机
 **/
-(UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}


/**
 * 打开相机
 **/
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

- (void)presentImagePickerController:(UIImagePickerControllerSourceType)sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [[[UIAlertView alloc] initWithTitle:@"该设备不支持拍照"
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil, nil] show];
        
        return;
    }
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = sourceType;
        [self presentViewController:controller animated:true completion:nil];
    }
    else {
        USImagePickerController *controller = [[USImagePickerController alloc] init];
        controller.delegate = self;
        controller.allowsEditing = NO;
        controller.cropMaskAspectRatio = 0.5;
        controller.allowsMultipleSelection = YES;
        controller.maxSelectNumber = 9;
        [self presentViewController:controller animated:true completion:nil];
    }
}

- (void)imagePickerController:(USImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)mediaArray
{
    LDLog(@"selectedOriginalImage %zd didFinishPickingMediaWithArray %@", picker.selectedOriginalImage, mediaArray);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /** 子线程中处理选择图片回调的数据 */
    dispatch_queue_t queue = dispatch_queue_create("USImagePickerQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self analysisPictureArray:mediaArray];
    });
}

- (void)analysisPictureArray:(NSArray *)array{
    
    NSMutableArray * picArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < array.count; i++) {
        PHAsset * asset = array[i];
        
        if (!asset || ![asset isKindOfClass:[PHAsset class]]) return;
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.resizeMode   = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        
        
        
        CGSize imageSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        __weak typeof(self) weakself = self;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
            if (image) {
                
                [picArr addObject:image];
                
                if (picArr.count == weakself.handlePicArr.count *2) {
                    
                    [picArr removeObjectsInArray:weakself.handlePicArr];
                    
                    [weakself setHandlePicArrData:picArr];
                }
                
               
            }
        }];
    }
    
    
    self.handlePicArr = [picArr copy];
    
    
}



- (void)imagePickerController:(USImagePickerController *)picker didFinishPickingMediaWithAsset:(id)asset
{
    LDLog(@"didFinishPickingMediaWithAsset\n %@",asset);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(USImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)mediaImage
{
    LDLog(@"didFinishPickingMediaWithImage %@",mediaImage);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/** 图片拍摄完成回调 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    //退出相机或相册界面
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //开启子线程
    dispatch_queue_t queue = dispatch_queue_create("SecondConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
       
        //获取选择的图片
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        
        if (self.currentIndexPath.section == 0) {
            self.faceImage = image;
        }
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        
        [array addObject:image];
        
        [self setHandlePicArrData:array];
        
        LDLog(@"-----------%@", [NSThread currentThread]);
    });
}

/** 给将要加载图片的indexPath赋值  */
- (void)setHandlePicArrData:(NSMutableArray *)array{
    self.handlePicArr = array;
    if (self.currentIndexPath.section == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row  + self.rentContractArr.count inSection:self.currentIndexPath.section];
        self.currentIndexPath = indexPath;
    }
    if (self.currentIndexPath.section == 2) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row  + self.actContractArr.count inSection:self.currentIndexPath.section];
        self.currentIndexPath = indexPath;
        
    }
    
    [self criculatePictureSendRequest];
}

/** 循环发送数组中的图片 */
- (void)criculatePictureSendRequest{
    
    
    if (self.handlePicArr.count > 0) {
        
        if (self.currentIndexPath.section != 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndexPath.row + 1 inSection:self.currentIndexPath.section];
            self.currentIndexPath = indexPath;
        }
        
        self.handleImage = self.handlePicArr[0];
        
        [self sendPictureProgressWithImage:self.handleImage];
    }
    else{
        
        LDLog(@"+++++图片全部发送完成");
    }
    
}



#pragma mark -- 网络请求方法
/** 发送贷款申请表，收入证明的图片 */
- (void)sendPictureProgressWithImage:(UIImage *)image{
    
    /** 回主线程 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView1 reloadData];
    });

    /** 上传身份证几口：picture/upload ；上传其他资料接口：upload */
    NSString * str = [NSString stringWithFormat:@"%@%@",KBaseUrl,(self.currentIndexPath.section == 0 ? @"picture/upload" : @"upload")];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    
    if (self.currentIndexPath.section != 0) {
       
        [params setObject:@"other" forKey:@"name"];
        [params setObject:@"jpg" forKey:@"type"];
    }
    else{
    
        [params setObject:@"1" forKey:@"type"];
    }
    

    [self.marg POST:str parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * imgData = UIImageJPEGRepresentation(image, 0.1);//0.1是把图片压缩
        
         NSString * imageName = @"";
        
        if (self.currentIndexPath.section == 0 && self.currentIndexPath.row == 0) {
            imageName = @"idCardFrontImg";
        }
        else if(self.currentIndexPath.section == 0 && self.currentIndexPath.row == 1){
            imageName = @"idCardBackImg";
        }
        else if (self.currentIndexPath.section == 0 && self.currentIndexPath.row == 2){
        
            imageName = @"idCardFaceImg";
        }
        else{
             imageName = @"other";
        }
        
        [formData appendPartWithFileData:imgData name:imageName fileName:@"data1FileName.jpg" mimeType:@"image.jpg"];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {//进度 NSProgress 配合KVC来使用 反应进度情况
        
        
        LDLog(@"uploadProgress========%@",uploadProgress);
        
        
        [uploadProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        
        
        float complete = (float)uploadProgress.fractionCompleted;
        
        NSString * comStr = [NSString stringWithFormat:@"%.0f%%",complete*100];
        
        
        LDLog(@" 当前线程  %@",[NSThread currentThread]);
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.progressLabel.text = [NSString stringWithFormat:@"图片上传中\n%@",comStr];
            
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        LDLog(@"%@",response);
        
        /** 回到主线程  */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.currentIndexPath.section != 0){
                HDPicBackModel * backModel = [HDPicBackModel mj_objectWithKeyValues:response];
                if ([backModel.errcode isEqualToString:@"200"]) {
                    
                    //给窗新的图片模型
                    self.pictureModel = [[HDPictureModel alloc]init];
                    self.pictureModel.picUrl = backModel.absolutePath;
                    self.pictureModel.picId = backModel.picId;
                    //保存图片本地地址
                    self.pictureModel.picUrl = [self getCurrentTime];
                    
                    //保存新上传的图片到本地
                    [HDMaterialOperate saveMaterialImageWith:[self fixOrientation:image] ImageName:self.pictureModel.picUrl];

                    //生成缩略图
                    self.pictureModel.thumbnail = [self imageCompressForWidth:image targetWidth:200];
                    if (self.currentIndexPath.section == 1){
                        [self.rentContractArr addObject:self.pictureModel];
                    }else{
                        [self.actContractArr addObject:self.pictureModel];
                    }
                    [self.handlePicArr removeObjectAtIndex:0];
                    [self backToMain];
                    [self criculatePictureSendRequest];
                    
                    
                }else{
                    // 显示失败信息
                    [self showFailViewWithString:backModel.msg];
                }
                
            }else{
            
                LDBackInformation * back = [LDBackInformation mj_objectWithKeyValues:response];
                
                if ([back.code isEqualToString:@"0"]) {
                    [self.handlePicArr removeObjectAtIndex:0];
                    [self backToMain];
                    [self criculatePictureSendRequest];
                }
                
            }
        });
        
    }
     /** 上传失败 */
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [self performSelectorOnMainThread:@selector(failureBackToMain) withObject:nil waitUntilDone:YES];
        
        
        
    }];
    
}
/** 计算上传进度，虽然不用此方法，但是不实现该方法报错 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        
        
    }
    
}

/** 图片上传失败 调用的方法 */
- (void)failureBackToMain{
    
    [self showFailViewWithString:@"上传失败"];
    
    if (self.currentIndexPath.section == 0 && self.currentIndexPath.row == 0) {
        self.zhengmianImage = nil;
    }
    else if (self.currentIndexPath.section == 0 && self.currentIndexPath.row == 1){
    
        self.fanmianImage = nil;
    }
    else if (self.currentIndexPath.section == 0 && self.currentIndexPath.row == 2){
        self.faceImage = nil;
    }
    else{
        [self.handlePicArr removeAllObjects];
    }
    
    [self.collectionView1 reloadData];
    
    self.progressLabel.text =@"图片上传中\n0%";
    
    [self.progressLabel removeFromSuperview];
    
}

/** 图片上传完成 调用的方法 */
- (void)backToMain{
    
    
    self.progressLabel.text =@"图片上传中\n0%";
    
    [self.progressLabel removeFromSuperview];
}


/** 修改图片大小 */
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

/** 修改图片的选择角度 */
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

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
/** 获取当前时间字符串 */
- (NSString *)getCurrentTime{
    //把当前时间转化成字符串
    NSDate* now = [NSDate date];
    
    NSString* nowDateString = [self.fmt stringFromDate:now];
    return nowDateString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
