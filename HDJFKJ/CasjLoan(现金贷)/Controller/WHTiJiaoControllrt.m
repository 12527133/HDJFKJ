

#import "WHTiJiaoControllrt.h"
#import "LDtest2222ViewController.h"
#import "WHSendImageRequest.h"
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

@interface WHTiJiaoControllrt ()<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, assign) float labelheight;
@property (nonatomic, assign) float viewHeight;
@property (nonatomic, assign) float imageViewWdith;
@property (nonatomic, assign) float distance;

//第一列
@property (nonatomic, strong) UILabel * firstLabel;
@property (nonatomic, strong) UICollectionView * collectionView1;

//第二列
@property(nonatomic,strong)UILabel * secondLabel;
@property(nonatomic,strong)UICollectionView * collectionView2;

//第三列
@property(nonatomic,strong)UILabel * ThreeLabel;
@property(nonatomic,strong)UICollectionView * collectionView3;


@property (nonatomic, strong) NSMutableArray * liushuiArray;
@property (nonatomic, strong) NSMutableArray * otherArray;
@property (nonatomic, strong) NSMutableArray * zichanArray;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;
@property (nonatomic, assign) NSInteger collectionTag;

@property (nonatomic, strong) UIAlertController * alertVC;
//相机
@property (nonatomic, strong) UIImagePickerController * picker;
//图片模型
@property (nonatomic, strong) HDPictureModel * pictureModel;
//时间格式
@property (nonatomic, strong) NSDateFormatter * fmt;

@property (nonatomic, strong) NSTimer * reloadTimer;
@end

@implementation WHTiJiaoControllrt


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
 * 延迟加载银行卡流水图片
 **/
- (NSMutableArray *)liushuiArray{
    if (!_liushuiArray) {
        _liushuiArray = [[NSMutableArray alloc]init];
    }
    return _liushuiArray;
}
/**
 * 延迟加载其他资料图片
 **/
- (NSMutableArray *)otherArray{
    if (!_otherArray) {
        _otherArray = [[NSMutableArray alloc]init];
    }
    return _otherArray;
}
/**
 * 延迟加载资产证明图片
 **/
- (NSMutableArray *)zichanArray{
    if (!_zichanArray) {
        _zichanArray = [[NSMutableArray alloc]init];
    }
    return _zichanArray;
}

/**
 * 延迟加载时间格式
 **/
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
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提交资料";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.labelheight = self.view.frame.size.width * 30/375.0;
    self.viewHeight = self.view.frame.size.width * 140/375.0;
    
    self.imageViewWdith = self.view.frame.size.width * 100/375;
    self.distance = (self.view.frame.size.width - self.imageViewWdith * 3)/4;
    
    
    [self createFirstLabel];
    [self createtopView];
    [self createsecondLabel];
    [self creatsecondBackground];
    [self createThreeLabel];
    [self createThreeBackground];
    
    
    float buttonHeight = self.view.frame.size.width * 40/375;
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(13, self.view.frame.size.height - buttonHeight - 15, self.view.frame.size.width * 349/375, buttonHeight)];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"下一步按钮"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickNext) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * tishiLbabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - buttonHeight - 40, LDScreenWidth, 20)];
    tishiLbabel.textAlignment = NSTextAlignmentCenter;
    tishiLbabel.textColor = WHColorFromRGB(0xd33a31);
    tishiLbabel.text = @"提示：左右滑动可查看上传照片";
    tishiLbabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tishiLbabel];
    
    [self requestUserMessageRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletePicRequest:) name:@"deletePic" object:nil];
    
    [HDMaterialOperate deleteGroup];
}




- (void)createFirstLabel {
    self.firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,  _labelheight)];
    self.firstLabel.text = @"    上传银行流水证明";
    self.firstLabel.font = [UIFont systemFontOfSize:13];
    self.firstLabel.alpha = 0.5f;
    self.firstLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.view addSubview:self.firstLabel];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 0.5)];
    label.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    [self.view addSubview:label];
    
}

//创建第一行背景图
- (void)createtopView{
    
    UIView * baseview = [[UIView alloc]initWithFrame:CGRectMake(0, 64+_labelheight, LDScreenWidth, _viewHeight)];
    baseview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseview];
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, _viewHeight-20) collectionViewLayout:layout];
    _collectionView1.tag = 1;
    [baseview addSubview:_collectionView1];
    _collectionView1.delegate = self;
    _collectionView1.dataSource = self;
    _collectionView1.backgroundColor = [UIColor clearColor];
    [_collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    
    UILabel * dierText = [[UILabel alloc]initWithFrame:CGRectMake(8, _viewHeight - 20,_collectionView1.frame.size.width - 16, 15)];
    dierText.text = @"到银行卡查询近几个月的银行流水并拍照上传，拍照时请确保信息清晰可见";
    dierText.font = [UIFont systemFontOfSize:9];
    dierText.textColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    [baseview addSubview:dierText];
    
    
}

-(void)createsecondLabel{
    
    self.secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+_viewHeight + _labelheight, self.view.frame.size.width, _labelheight)];
    
    
    self.secondLabel.text = @"    上传资产负债证明";
    self.secondLabel.alpha = 0.5f;
    self.secondLabel.font = [UIFont systemFontOfSize:13];
    self.secondLabel.textColor = [UIColor blackColor];
    self.secondLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.view addSubview:self.secondLabel];
    
    
}
//第二行背景视图
-(void)creatsecondBackground{
    
    UIView * baseview = [[UIView alloc]initWithFrame:CGRectMake(0, 64+_labelheight * 2 + _viewHeight, LDScreenWidth, _viewHeight)];
    baseview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseview];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, _viewHeight-20) collectionViewLayout:layout];
    _collectionView2.tag = 2;
    [baseview addSubview:_collectionView2];
    _collectionView2.delegate = self;
    _collectionView2.dataSource = self;
    _collectionView2.backgroundColor = [UIColor clearColor];
    [_collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UILabel * dierText = [[UILabel alloc]initWithFrame:CGRectMake(8, _viewHeight - 20,_collectionView2.frame.size.width - 16, 15)];
    dierText.text = @"如果您有资产证明，请拍照上传，拍照时请确保信息清晰可见";
    dierText.font = [UIFont systemFontOfSize:9];
    dierText.textColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    
    [baseview addSubview:dierText];
    
}

-(void)createThreeLabel{
    
    self.ThreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+(_viewHeight + _labelheight)*2, self.view.frame.size.width, _labelheight)];
    self.ThreeLabel.text = @"    上传其他图片资料";
    self.ThreeLabel.alpha = 0.5f;
    self.ThreeLabel.font = [UIFont systemFontOfSize:13];
    self.ThreeLabel.textColor = [UIColor blackColor];
    self.ThreeLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.view addSubview:self.ThreeLabel];
    
    
}
//第三行背景视图
-(void)createThreeBackground{
    
    UIView * baseview = [[UIView alloc]initWithFrame:CGRectMake(0, 64+_labelheight * 3 + _viewHeight * 2, self.view.frame.size.width, _viewHeight)];
    baseview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseview];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView3 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, _viewHeight-20) collectionViewLayout:layout];
    _collectionView3.tag = 3;
    [baseview addSubview:_collectionView3];
    _collectionView3.delegate = self;
    _collectionView3.dataSource = self;
    _collectionView3.backgroundColor = [UIColor clearColor];
    [_collectionView3 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UILabel * dierText = [[UILabel alloc]initWithFrame:CGRectMake(8, _viewHeight - 20,_collectionView3.frame.size.width - 16, 15)];
    dierText.text = @"上传工作或者财力证明文件；如工作证、学生证、工资条公司合影等";
    dierText.font = [UIFont systemFontOfSize:9];
    dierText.textColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1];
    
    
    [baseview addSubview:dierText];
    
    
}


#pragma mark -- collectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1) {
        return self.liushuiArray.count+1;
    }
    else if (collectionView.tag == 2){
        return self.zichanArray.count+1;
    }
    else{
        return self.otherArray.count+1;
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
   
    
    
    
    if (collectionView.tag == 1) {
        
        if (indexPath.row != self.liushuiArray.count) {
            HDPictureModel * picModel = self.liushuiArray[indexPath.row];
            if ( [picModel.picUrl rangeOfString:@"http"].length > 0) {
                [subImageView sd_setImageWithURL:[NSURL URLWithString:picModel.picUrl] placeholderImage:[UIImage imageNamed:@"相机"]];
            }else{
                
                subImageView.image = picModel.thumbnail;
            }
            
        }
        else{
             subImageView.image = [UIImage imageNamed:@"相机"];
        
        }
        return cell;
        
    }
    else if (collectionView.tag == 2) {
        
        if (indexPath.row != self.zichanArray.count) {
            HDPictureModel * picModel = self.zichanArray[indexPath.row];
            if ( [picModel.picUrl rangeOfString:@"http"].length > 0) {
                [subImageView sd_setImageWithURL:[NSURL URLWithString:picModel.picUrl] placeholderImage:[UIImage imageNamed:@"相机"]];
            }else{
                subImageView.image = picModel.thumbnail;
            }
        }
        else{
            subImageView.image = [UIImage imageNamed:@"相机"];
            
        }
        return cell;
    }
    else{
        
        if (indexPath.row != self.otherArray.count) {
            HDPictureModel * picModel = self.otherArray[indexPath.row];
            if ( [picModel.picUrl rangeOfString:@"http"].length > 0) {
                [subImageView sd_setImageWithURL:[NSURL URLWithString:picModel.picUrl] placeholderImage:[UIImage imageNamed:@"相机"]];
            }else{
                subImageView.image = picModel.thumbnail;
            }
        }
        else{
            subImageView.image = [UIImage imageNamed:@"相机"];
            
        }
        return cell;
    }
    
    
}
//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    float topAndBottpn = (collectionView.frame.size.height - self.imageViewWdith)/2;
    float leftAndRight = 15 * LDScreenWidth/375;
    UIEdgeInsets top = {topAndBottpn,leftAndRight,topAndBottpn,leftAndRight};
    return top;
}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.imageViewWdith,self.imageViewWdith);
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.collectionTag = collectionView.tag;
    self.currentIndexPath = indexPath;
    
    if (collectionView.tag == 1) {
        if (indexPath.row != self.liushuiArray.count) {
            UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
            HDPictureModel * picModel = self.liushuiArray[indexPath.row];
            
            if (picModel.thumbnail != nil) {
                
                //[SSImageView viewWithImage:[WHImageSaveAndLoad loadImage:picModel.picUrl] picID:picModel.picId];
                [SSImageView viewWithImage:[HDMaterialOperate readImageWithImageName:picModel.picUrl] picID:picModel.picId];
                
            }else{
                for (UIImageView * selectView in cell.contentView.subviews) {
                    
                    [SSImageView viewWithImage:selectView.image picID:picModel.picId];
                }
                
            }
            
        }
        else{
            [self presentViewController:self.alertVC animated:YES completion:nil];
        }
    }
    
    else if (collectionView.tag == 2) {
        if (indexPath.row != self.zichanArray.count) {
            UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
            HDPictureModel * picModel = self.zichanArray[indexPath.row];
            if (picModel.thumbnail != nil) {
                
                //[SSImageView viewWithImage:[WHImageSaveAndLoad loadImage:picModel.picUrl] picID:picModel.picId];
                [SSImageView viewWithImage:[HDMaterialOperate readImageWithImageName:picModel.picUrl] picID:picModel.picId];
                
            }else{
                for (UIImageView * selectView in cell.contentView.subviews) {
                    
                    [SSImageView viewWithImage:selectView.image picID:picModel.picId];
                }
                
            }
        }
        else{
            [self presentViewController:self.alertVC animated:YES completion:nil];
        }
    }
    
    else{
        if (indexPath.row != self.otherArray.count) {
            UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
            HDPictureModel * picModel = self.otherArray[indexPath.row];
            if (picModel.thumbnail != nil) {
                
                //[SSImageView viewWithImage:[WHImageSaveAndLoad loadImage:picModel.picUrl] picID:picModel.picId];
                [SSImageView viewWithImage:[HDMaterialOperate readImageWithImageName:picModel.picUrl] picID:picModel.picId];
                
            }else{
                for (UIImageView * selectView in cell.contentView.subviews) {
                    
                    [SSImageView viewWithImage:selectView.image picID:picModel.picId];
                }
                
            }
        }
        else{
            [self presentViewController:self.alertVC animated:YES completion:nil];
        }
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
        
        [HDLoading showWithImageWithString:@"上传中..."];
        //获取选择的图片
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        //发送上传图片请求
        [self sendImageRequestWithImageData:image];
        
        NSLog(@"-----------%@", [NSThread currentThread]);
    });
    
}

/**
 * 发送图片请求
 **/
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
    
    NSString * imageName = @"";
    
    if (self.collectionTag == 1) {
        imageName = @"liushui";
    }
    else if (self.collectionTag == 2){
        imageName = @"zichan";
    }else{
        imageName = @"other";
    }
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:imageName forKey:@"name"];
    [params setObject:@"jpg" forKey:@"type"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params imageData:data name:imageName fileName:@"image.jpg" mimeType:@"image.jpg" callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.请求错误提示*/
            [HDLoading showFailViewWithString:@"网络错误"];
            
            /** 2.打印错误信息 */
            LDLog(@"UIImagePickerControllerOriginalImage--error请求失败%@",error);
        }else{
            
            HDPicBackModel * backModel = [HDPicBackModel mj_objectWithKeyValues:response];
            
            //code == 200请求成功
            if ([backModel.errcode isEqualToString:@"200"]) {
                [HDLoading dismissHDLoading];
                
                //给窗新的图片模型
                self.pictureModel = [[HDPictureModel alloc]init];
                self.pictureModel.picUrl = [self getCurrentTime];
                self.pictureModel.picId = backModel.picId;
                
                
                //保存新上传的图片到本地
                [HDMaterialOperate saveMaterialImageWith:[self fixOrientation:image] ImageName:self.pictureModel.picUrl];
                
                //生成缩略图
                self.pictureModel.thumbnail = [self imageCompressForWidth:image targetWidth:self.self.imageViewWdith*2];
                
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.collectionTag == 1) {
                        [self.liushuiArray addObject:self.pictureModel];
                        [self.collectionView1 reloadData];
                        
                        //自动滚动到最好
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.liushuiArray.count inSection:0];
                        [self.collectionView1 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                        
                    }
                    else if (self.collectionTag == 2){
                        [self.zichanArray addObject:self.pictureModel];
                        [self.collectionView2 reloadData];
                        
                        //自动滚动到最好
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.zichanArray.count inSection:0];
                        [self.collectionView2 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                        
                        
                    }
                    else{
                        
                        /** 数据插入到数据数组 ，刷新界面 */
                        [self.otherArray addObject:self.pictureModel];
                        [self.collectionView3 reloadData];
                        
                        /**  collectionView自动滚动到最后  */
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.otherArray.count inSection:0];
                        [self.collectionView3 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
                    }
                });
                
                
                
            }else{
                /**  请求异常提示 */
                [HDLoading showFailViewWithString:backModel.msg];
            }
            LDLog(@"%@",response);
            
        }
    }];
    
    
}

//跳转加载银行卡
-(void)clickNext{
    
    
    if (self.liushuiArray.count == 0 || self.zichanArray.count == 0) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"至少上传一张资产证明和银行卡流水证明" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        
        AuthorizViewController * author = [[AuthorizViewController alloc]init];
        author.params = self.params;
        author.fromWhere = self.fromWhere;
        [self.navigationController pushViewController:author animated:YES];
        
    }
}

/**
 * 网络请求,获取用户下单时上传的资料照片
 **/
- (void)requestUserMessageRequest{
    
    
    [HDLoading showWithImageWithString:@"正在加载"];
    NSString * str = [NSString stringWithFormat:@"%@customInfo/pictureInfo",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            NSLog(@"%@",error);
            
            /** 1.网络请求错误提示*/
            [HDLoading showFailViewWithString:@"网络错误"];
        }
        else
        {
            LDLog(@"%@",response);
            
            /** 2.解析返回结果  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"])
            {
                [HDLoading dismissHDLoading];
                
                /** 3.解析返回的照片数据 */
                if (backInfo.result != nil) {
                    HDMaterialModel * materialModel = [HDMaterialModel mj_objectWithKeyValues:backInfo.result];
                    
                    [self.liushuiArray addObjectsFromArray: materialModel.liushui];
                    
                    [self.otherArray addObjectsFromArray:materialModel.others];
                    
                    [self.zichanArray addObjectsFromArray:materialModel.zichan];
                }
                
                /** 4.刷新试图 */
                [_collectionView3 reloadData];
                [_collectionView2 reloadData];
                [_collectionView1 reloadData];
                
                
                /** 5.collection 滑动到最后一个 cell*/
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.liushuiArray.count inSection:0];
                [self.collectionView1 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
                
                indexPath = [NSIndexPath indexPathForRow:self.zichanArray.count inSection:0];
                [self.collectionView2 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
                
                indexPath = [NSIndexPath indexPathForRow:self.otherArray.count inSection:0];
                [self.collectionView3 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            }
            else
            {
                /** 6.请求异常提示 **/
                [HDLoading showFailViewWithString:backInfo.message];
            
            }
            
        }
    }];
}

/**
 * 删除图片请求
 **/
- (void)deletePicRequest:(NSNotification *) notification{
    
    NSString * picid = notification.userInfo[@"picID"];
    
    [HDLoading showWithImageWithString:@"正在删除"];
    NSString * str = [NSString stringWithFormat:@"%@customInfo/delpicture",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:picid forKey:@"picId"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印错误信息 */
            NSLog(@"%@",error);
            
            /** 2.网络错误提示  */
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            LDLog(@"%@",response);
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                [HDLoading showSuccessViewWithString:@"删除成功"];
                
                /** 4.删除数组数据，*/
                if (self.collectionTag == 1) {
                    
                    [self.liushuiArray removeObjectAtIndex:self.currentIndexPath.row];
                    
                    
                }
                else if (self.collectionTag == 2){
                    [self.zichanArray removeObjectAtIndex:self.currentIndexPath.row];
                    
                    
                    
                }else{
                    [self.otherArray removeObjectAtIndex:self.currentIndexPath.row];
                    
                    
                }
                
                /** 5.刷新界面 */
                self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadCollection) userInfo:nil repeats:NO];
            }
            else
            {
                /** 6.请求异常提示 */
                [HDLoading showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}
/** 删除图片后刷新界面 */
- (void)reloadCollection{
    
    
    
    if (self.collectionTag == 1) {
        
        [_collectionView1 reloadData];
    }
    else if (self.collectionTag == 2){
       
        [_collectionView2 reloadData];
    }else{
        
        [_collectionView3 reloadData];
    }
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
//获取当前时间毫秒值
- (NSString *)getCurrentTime{
    //把当前时间转化成字符串
    NSDate* now = [NSDate date];
    NSString* nowDateString = [self.fmt stringFromDate:now];
    return nowDateString;
}


@end
