//
//  LDPostIDCard.m
//  OCLDProject
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//
#define LDBackroundColor [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]
#import "LDPostIDCard.h"
#import "LDIDCardModel.h"
#import "LDBaseInformationTableViewController.h"
#import "LDBackModel.h"
#import "WHPersonProcessTopView.h"
#import "WHBaseInfoModel.h"
#import "WHImagPickerController.h"
#import "HDYangLiController.h"

#define padding 17 * LDScreenWidth/375
@interface LDPostIDCard ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIButton * Textbutton1;
@property (nonatomic,strong) UIButton * Textbutton2;
@property (nonatomic,strong) UIButton * button1;
@property (nonatomic,strong) UIButton * button2;
@property (nonatomic,strong) UIButton * button3;
@property (nonatomic ,strong) WHImagPickerController *picker;
@property (nonatomic,strong) UIImageView * image1;
@property (nonatomic,strong) UIImageView * image2;

@property (nonatomic,strong) UIImageView * image3;

@property (nonatomic,strong) LDIDCardModel * IDCardModel;

@property (nonatomic,strong) SCCaptureCameraController * CameraController;

@property (nonatomic,strong) LDBackModel * backModel;

/**
 *  是否是正面
 */
@property (nonatomic,assign) BOOL IsPositive;

/**
 *  扫描后获得的照片
 */
@property (nonatomic,strong) UIImage * IDImage;
/**
 *  正面身份证
 */
@property (nonatomic,strong) UIImage * ForImage;
@property (nonatomic,strong) UIImage * ForImage1;

/**
 *  反面身份证
 */
@property (nonatomic,strong) UIImage * BacImage;
@property (nonatomic,strong) UIImage * BacImage1;

/**
 *  正反面image状态记录记录变量
 */
@property (nonatomic,assign) BOOL button1Image;
@property (nonatomic,assign) BOOL button2Image;
@property (nonatomic,strong) UIImage * handImage;
/**
 *  图片是否加载完成
 */
@property (nonatomic,assign) BOOL PositiveBool;
@property (nonatomic,assign) BOOL dispositiveBool;
@property (nonatomic,assign) BOOL handBool;

@end

@implementation LDPostIDCard
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"身份证信息";
    
    [self setupScro];
    
    self.view.backgroundColor = LDBackroundColor;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(CameraControllerSuccessButtonClick) name:@"CameraControllerSuccessButtonClick" object:nil];
    
    [center addObserver:self selector:@selector(cancleButtonRemove) name:@"cancleNotication" object:nil];
    self.PositiveBool = NO;
    self.handBool = NO;
    self.dispositiveBool = NO;
    
    if ( self.requestImage ) {
        
        self.sendUserMessage = YES;
        
        //获取身份证信息
        [self requestUserMessageRequest];
    }
}


/**
 * 网络请求,获取用户的高级信息（身份证照片）
 **/
- (void)requestUserMessageRequest{
    
    [MBProgressHUD showMessage:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/advanced",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
           
            
        }else{
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                
                /** 4.解析身份证图片信息 */
                if (backInfor.result != nil) {
                    self.backModel = [LDBackModel mj_objectWithKeyValues:backInfor.result];
                    
                    /** 5.加载身份证图片 */
                    [self getImageFromNet];
                    
                    
                }
                
                /** 6.获取基本信息*/
                [self requestBasicMessageRequest];
                
            }
            else{
                
                [MBProgressHUD showError:backInfor.message];
                
            }
        }
    }];
}
- (void)getImageFromNet{
    
    LDLog(@"%@", self.backModel.idCardBackImg);
    LDLog(@"%@", self.backModel.idCardFaceImg);
    LDLog(@"%@", self.backModel.idCardFrontImg);
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString: self.backModel.idCardFrontImg] placeholderImage:[UIImage imageNamed:@"拍摄身份证正面"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        LDLog(@"1下载完成");
        self.ForImage1 = image;
        self.PositiveBool = YES;
        [self chencBoolImage];
        
    }];
    
    [self.image2 sd_setImageWithURL:[NSURL URLWithString: self.backModel.idCardBackImg] placeholderImage:[UIImage imageNamed:@"拍摄身份证反面"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        LDLog(@"2下载完成");
        self.BacImage1 = image;
        self.dispositiveBool = YES;
        [self chencBoolImage];
        
    }];
    
    [self.image3 sd_setImageWithURL:[NSURL URLWithString: self.backModel.idCardFaceImg] placeholderImage:[UIImage imageNamed:@"Group 2"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        LDLog(@"3下载完成");
        self.handImage = image;
        self.handBool = YES;
        [self chencBoolImage];
    }];
    
    
    [self.Textbutton1 setImage:[UIImage imageNamed:@"图标 彩色"] forState:UIControlStateNormal];
    
    
    [self.Textbutton2 setImage:[UIImage imageNamed:@"图标 彩色"] forState:UIControlStateNormal];
    
}
- (void)chencBoolImage{
    
    if ((self.PositiveBool == 1)&&(self.dispositiveBool == 1)&&(self.handBool == 1)) {
        
        [MBProgressHUD hideHUD];
        
    }else{
    
        [self performSelector:@selector(hiddenMBP) withObject:nil afterDelay:25];
    }
    
}
/** 25秒后取消加载 */
- (void)hiddenMBP{
    [MBProgressHUD hideHUD];
}

- (void)cancleButtonRemove{
    self.CameraController = nil;
}

- (void)CameraControllerSuccessButtonClick{
    
    if ((self.IsPositive == YES)&& (self.CameraController.IsPositive== YES)) {
        
        [self.image1 setClipsToBounds:YES];
        
        [self.image1 setContentMode:UIViewContentModeScaleToFill];
        
        [self.image1 setImage:self.IDImage];
        
        self.ForImage1 = self.image1.image;
        
        
        
    }
    
    if ((self.IsPositive == NO)&& (self.CameraController.IsPositive == NO)) {
        
        [self.image2 setClipsToBounds:YES];
        
        [self.image2 setContentMode:UIViewContentModeScaleToFill];
        
        self.image2.image = self.IDImage;
        
        self.BacImage1 = self.image2.image;
        
    }
    
    [self checkImage];
    
    self.CameraController = nil;
    
}


- (void)checkImage{
    
    if ((self.ForImage1 != nil)&&(self.BacImage1 != nil)) {
        
        [self.Textbutton1 setImage:[UIImage imageNamed:@"图标 彩色"] forState:UIControlStateNormal];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CameraControllerSuccessButtonClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancleNotication" object:nil];
}

- (void)buttonClick:(UIButton *)button{
    
    self.picker.delegate = self;
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (button == self.button3) {
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //[self chooseLogoFromTakingPhoto];
            [self pushYangli];
        }]];
        
        
    }else{
        
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        
        [alertVC addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            [self showAliveVC:(UIButton *)button];
            
        }]];
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)showAliveVC:(UIButton *)button{
    
    SCCaptureCameraController * CameraController = [[SCCaptureCameraController alloc] init];
    
    CameraController.scNaigationDelegate = self;
    
    CameraController.iCardType = TIDCARD2;
    
    CameraController.isDisPlayTxt = NO;
    
    if (button == self.button1) {
        
        CameraController.IsPositive = YES;
        
        self.IsPositive = YES;
        
    }else{
        
        CameraController.IsPositive = NO;
        
        self.IsPositive = NO;
    }
    
    self.CameraController = CameraController;
    
    [self presentViewController:CameraController animated:YES completion:nil];
    
}

// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    
    self.IsPositive = YES;
    self.IDCardModel.name = name;
    self.IDCardModel.sex = sex;
    self.IDCardModel.folk = folk;//民族
    self.IDCardModel.birthday = birthday;
    self.IDCardModel.address = address;
    self.IDCardModel.IDCardNumber = num;//身份证号
    
    
    
    
}
// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period
{
    self.IsPositive = NO;
    self.IDCardModel.IDCardTimer = period;
    NSArray * arr = [period componentsSeparatedByString:@"-"];
    if (arr.count == 2) {
        self.IDCardModel.idTermBegin = [self getSumeTimeWithCurrentTime:arr[0] minute:0 dataFormet:@"yyyy-MM-dd"];
        
        if ([arr[1] isEqualToString:@"长期"]){
            self.IDCardModel.idTermEnd = arr[1];
            
        }else{
            self.IDCardModel.idTermEnd = [self getSumeTimeWithCurrentTime:arr[1] minute:0 dataFormet:@"yyyy-MM-dd"];
        }
      
    }
  
}

//获取拍照的图片
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
{
    
    self.IDImage = cardImage;
    
    //    [self.image3 setClipsToBounds:YES];
    [self.image3 setContentMode:UIViewContentModeScaleAspectFit];
    
    self.CameraController.successButton.hidden = YES;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self CameraControllerSuccessButtonClick];
    }];
}


- (void)chooseLogoFromPhotoLibrary{
    
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //设置选择后的图片可被编辑
    self.picker.allowsEditing = NO;
    
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)pushYangli{
    
    HDYangLiController * yangli = [[HDYangLiController alloc]init];
    [self.navigationController pushViewController:yangli animated:YES];
    
    yangli.completionBlock = ^{
        [self chooseLogoFromTakingPhoto];
    };
    
}

- (void)chooseLogoFromTakingPhoto{
    
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.picker.delegate = self;
        //设置拍照后的图片可被编辑
        self.picker.allowsEditing = NO;
        
    }
    
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    self.handImage = image;
    [self.image3 setImage:image];
    [self.Textbutton2 setImage:[UIImage imageNamed:@"图标 彩色"] forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupScro{
    
    UIScrollView * scrol = [UIScrollView new];
    scrol.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrol];
    [scrol makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView *container = [UIView new];
    [scrol addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrol);
        make.width.equalTo(LDScreenWidth);
    }];
    self.Textbutton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Textbutton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView * image1 = [[UIImageView alloc] init];
    UIImageView * image2 = [[UIImageView alloc] init];
    UIImageView * image3 = [[UIImageView alloc] init];
    
    self.image1 = image1;
    self.image2 = image2;
    self.image3 = image3;
    [self.image3 setClipsToBounds:YES];
    
    [self.image3 setContentMode:UIViewContentModeScaleAspectFill];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIButton * button4 = [UIButton buttonWithType:UIButtonTypeCustom];

    [button4 setBackgroundColor:WHColorFromRGB(0x4279d6)];
    button4.layer.borderWidth = 0.0;
    button4.layer.cornerRadius = 5.0;
    
    [button4 setTitle:@"下一步" forState:UIControlStateNormal];
    
    
    [self.button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [button4 addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:image1];
    [container addSubview:image2];
    [container addSubview:image3];
    
    [container addSubview:self.Textbutton1];
    [container addSubview:self.Textbutton2];
    
    [image1 addSubview:self.button1];
    [image2 addSubview:self.button2];
    [image3 addSubview:self.button3];
    
    [container addSubview:button4];
    image1.image = [UIImage imageNamed:@"拍摄身份证正面"];
    image2.image = [UIImage imageNamed:@"拍摄身份证反面"];
    image3.image = [UIImage imageNamed:@"Group 2"];
    
    UIView *lastView = nil;
    
    
    WHPersonProcessTopView * topView = [WHPersonProcessTopView view];
    [container addSubview:topView];
    topView.frame = CGRectMake(0, 0, 0, 0);
    
    
    [self.Textbutton1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(padding);
        make.top.equalTo(topView.bottom).offset(18.5);
        make.width.equalTo(200);
        make.height.equalTo(18);
    }];
    self.Textbutton1.font = [UIFont systemFontOfSize:15];
    [self.Textbutton1 setTitle:@"拍摄身份证正反面照片" forState:UIControlStateNormal];
    [self.Textbutton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Textbutton1 setImage:[UIImage imageNamed:@"图标"] forState:UIControlStateNormal];
    self.Textbutton1.userInteractionEnabled  = NO;
    self.Textbutton1.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    
    [image1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(padding);
        make.top.equalTo(topView.bottom).offset(45);
        make.height.equalTo(107 * LDScreenWidth/375);
        make.width.equalTo(161 * LDScreenWidth/375);
    }];
    
    
    [image2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(container).offset(-padding);
        make.top.equalTo(image1);
        make.height.equalTo(image1);
        make.width.equalTo(image1);
    }];
    
    image1.userInteractionEnabled = YES;
    [self.button1 makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(image1);
    }];
    image2.userInteractionEnabled = YES;
    [self.button2 makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(image2);
    }];
    [self.Textbutton2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(padding);
        make.top.equalTo(self.button1.bottom).offset(30);
        make.width.equalTo(200);
        make.height.equalTo(18);
    }];
    
    self.Textbutton2.font = [UIFont systemFontOfSize:15];
    [self.Textbutton2 setTitle:@"手持身份证自拍照" forState:UIControlStateNormal];
    [self.Textbutton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Textbutton2 setImage:[UIImage imageNamed:@"图标"] forState:UIControlStateNormal];
    self.Textbutton2.userInteractionEnabled  = NO;
    self.Textbutton2.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
    
    
    [image3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(padding);
        make.right.equalTo(container).offset(-padding);
        make.top.equalTo(self.Textbutton2.bottom).offset(9);
        make.height.equalTo(181* LDScreenWidth/375);
    }];
    image3.userInteractionEnabled = YES;
    [self.button3 makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(image3);
    }];
    
    [button4 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(padding);
        make.right.equalTo(container).offset(-padding);
        make.top.equalTo(self.button3.bottom).offset(50);
        make.height.equalTo(45);
    }];
    
    
    lastView = button4;
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.bottom).offset(20);
    }];
    
}

- (void)nextButtonClick{
    
    if ((self.ForImage1 != nil)&&(self.BacImage1 != nil)&&(self.handImage!= nil)) {
        
        [self upLoad];
        
        
    }else{
        
        [MBProgressHUD showError:@"请将三张图片拍摄完整"];
        
    }
}

-(WHImagPickerController *)picker{
    if (!_picker) {
        _picker = [[WHImagPickerController alloc] init];
    }
    return _picker;
}
-(LDIDCardModel *)IDCardModel{
    
    if (!_IDCardModel) {
        _IDCardModel = [[LDIDCardModel alloc] init];
        
    }
    return _IDCardModel;
}


/**
 * 上传身份证图片请求
 **/
- (void)upLoad{
    
    [MBProgressHUD showMessage:@"正在提交"];
    
    AFHTTPSessionManager * marg = [AFHTTPSessionManager manager];
    //上传头像到服务器
    NSString * urlString = [NSString stringWithFormat:@"%@picture/upload",KBaseUrl];
    ;
    
    NSDictionary *parameter = @{
                                
                                @"token":[LDUserInformation sharedInstance].token ,
                                
                                @"id":[LDUserInformation sharedInstance].UserId,
                                
                                @"type":@"1",
                                
                                
                                
                                };
    
    NSData * data1 = UIImageJPEGRepresentation(self.image1.image, 0.1);
    NSData *data2 = UIImageJPEGRepresentation(self.image2.image, 0.1);
    NSData *data3 = UIImageJPEGRepresentation(self.handImage, 0.1);
    
    [marg POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data1 name:@"idCardFrontImg" fileName:@"data1FileName.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:data2 name:@"idCardBackImg" fileName:@"data1FileName.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:data3 name:@"idCardFaceImg" fileName:@"data1FileName.png" mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        LDLog(@"%@",responseObject);
        LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:responseObject];
        if ([backInfor.code isEqualToString:@"0"]) {
            
            
            
            LDLog(@"%@",self.fromeWhere);
            LDLog(@"%@",self.IDCardModel);
            
            
            if (self.sendUserMessage) {
                
                [MBProgressHUD hideHUD];
                
                LDBaseInformationTableViewController * base = [[LDBaseInformationTableViewController alloc] init];
                base.sendUserMessage = NO;
                base.fromeWhere = self.fromeWhere;
                base.baseModel = self.IDCardModel;
                [self.navigationController pushViewController:base animated:YES];
            }else{
                [self sendRequest];
            }
            
        }else{
            [MBProgressHUD showError:backInfor.message];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showError:@"上传失败"];
        LDLog(@"%@",error);
        
        
    }];
}

//发送部分基本信息
- (void)sendRequest{
    
    
    
    NSString * url = [NSString stringWithFormat:@"%@register/customInfo",KBaseUrl];
    
    [[LDNetworkTools sharedTools] request:POST url:url params:[self getParameters] callback:^(id response, NSError *error) {
        if (error != nil) {
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
            
        }else{
            LDLog(@"%@",response);
            
            /** 3.解析返回的信息 */
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                
                LDBaseInformationTableViewController * base = [[LDBaseInformationTableViewController alloc] init];
                
                base.fromeWhere = self.fromeWhere;
                base.baseModel = self.IDCardModel;
                base.sendUserMessage = YES;
                [self.navigationController pushViewController:base animated:YES];
                
            }else{
                
                /** 4.请求异常提示  */
                [MBProgressHUD showError:backInfor.message];
            }
        }
    }];
    
}

#pragma mark - 拼接参数
- (NSMutableDictionary *)getParameters{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [parameters setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    
    
    //真实姓名
    [parameters setObject:NILSTR(self.IDCardModel.name) forKey:@"idName"];
    
    //身份证
    [parameters setObject:NILSTR(self.IDCardModel.IDCardNumber) forKey:@"idNo"];
    
    //户籍地址
    [parameters setObject:NILSTR(self.IDCardModel.address) forKey:@"regAddrTown"];
    
    
    //身份证有限期
    [parameters setObject:NILSTR(self.IDCardModel.idTermBegin) forKey:@"idTermBegin"];
    [parameters setObject:NILSTR(self.IDCardModel.idTermEnd) forKey:@"idTermEnd"];
    //默认身份为 “工薪”
    [parameters setObject:@"2" forKey:@"occupation"];
    
    return parameters;
    
}

/**
 * 网络请求,获取用户的基本信息
 **/
- (void)requestBasicMessageRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];

            /** 4.code == 0请求成功  */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
                
                
                /** 5.解析基本信息 */
                if (backInfo.result != nil){
                    
                    WHBaseInfoModel * baseInfoModel = [WHBaseInfoModel mj_objectWithKeyValues:backInfo.result];
                    
                    self.IDCardModel.name = baseInfoModel.idName;
                    
                    self.IDCardModel.IDCardNumber = baseInfoModel.idNo;
                    
                    self.IDCardModel.idTermBegin = baseInfoModel.idTermBegin;
                    
                    self.IDCardModel.idTermEnd = baseInfoModel.idTermEnd;
                    
                    self.IDCardModel.address = baseInfoModel.regAddrTown;
                
                }

            }else{
                
                /** 6.请求异常提示 */
                [MBProgressHUD showError:backInfo.message];
            }
            
            LDLog(@"%@",response);
        }
    }];
}

- (NSString *)getSumeTimeWithCurrentTime:(NSString *)time minute:(NSInteger)minute dataFormet:(NSString *)format
{
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = format;
    
    NSDate *date = [fmt dateFromString:time];
    //把当前时间转化成距1970地秒数
    NSTimeInterval secondDate = [date timeIntervalSince1970]*1;
    //减去指定天的秒数
    NSInteger timeDifference = secondDate + 60*minute;
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeDifference];
    NSString *confromTimespStr = [fmt stringFromDate:confromTimesp];
    //返回结果
    return confromTimespStr;
}
@end
