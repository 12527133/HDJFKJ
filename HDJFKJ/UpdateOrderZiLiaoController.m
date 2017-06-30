//
//  WHTiJiaoControllrt.m
//  GuangShengXing
//
//  Created by 石伟浩 on 16/4/7.
//  Copyright © 2016年 史国涛. All rights reserved.
//

#import "UpdateOrderZiLiaoController.h"

#import "LDtest2222ViewController.h"
#import "WHSendImageRequest.h"
#import "WHUserLoginModel.h"
#import "AuthorizViewController.h"
#import "LDtest2222ViewController.h"
#import "SSImageView.h"
#import "WHImageSaveAndLoad.h"

@interface UpdateOrderZiLiaoController ()<UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) float labelheight;

@property (nonatomic, assign) float viewHeight;

@property (nonatomic, assign) float imageViewWdith;
@property (nonatomic, assign) float distance;

//第一列


@property (nonatomic, strong) UICollectionView * collectionView1;


//第三列
@property(nonatomic,strong)UILabel * ThreeLabel;



//图片的个数

@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) int imageCount2;
@property (nonatomic, assign) int imageCount3;
@property (nonatomic, assign) int buttonTag;

@property(nonatomic,strong) UIButton * imageButton;

@property (nonatomic, strong) WHUserLoginModel * user;

@property (nonatomic, strong) NSMutableArray * imageArray;

@property (nonatomic, strong) NSArray * otherArray;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;

@end

@implementation UpdateOrderZiLiaoController

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.user = [WHUserLoginModel createuserInfoModel];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提交资料";
    
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    self.labelheight = self.view.frame.size.width * 30/375.0;
    self.viewHeight = self.view.frame.size.width * 145/375.0;
    
    self.imageViewWdith = self.view.frame.size.width * 100/375;
    self.distance = (self.view.frame.size.width - self.imageViewWdith * 3)/4;
    
 
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

    
    //发送网络请求获取数据
    [self requestUserMessageRequest];
}


-(void)createThreeLabel{
    
    self.ThreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, LDScreenWidth, _labelheight)];
    self.ThreeLabel.text = @"    上传其他图片资料";
    self.ThreeLabel.alpha = 0.5f;
    self.ThreeLabel.font = [UIFont systemFontOfSize:13];
    self.ThreeLabel.textColor = [UIColor blackColor];
    self.ThreeLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.view addSubview:self.ThreeLabel];
    
    
}
//第三行背景视图
-(void)createThreeBackground{
    
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

    return self.otherArray.count + self.imageArray.count + 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
        
        static NSString * CellIdentifier = @"cell";
        
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        UIImageView *subImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        subImageView.image = [UIImage imageNamed:@"相机"];
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:subImageView];
        
        
    if (self.otherArray.count > 0) {
        if (indexPath.row < self.otherArray.count) {
            
            [subImageView sd_setImageWithURL:[NSURL URLWithString:self.otherArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"相机"]];
            
        }
        else if (indexPath.row == self.imageArray.count + self.otherArray.count){
            subImageView.image = [UIImage imageNamed:@"相机"];
        }
        else{
            UIImage * image = self.imageArray[indexPath.row  - self.otherArray.count];
            subImageView.image = image;
        }
    }else{
        if (indexPath.row == self.imageArray.count) {
            subImageView.image = [UIImage imageNamed:@"相机"];
        }
        else{
            subImageView.image = self.imageArray[indexPath.row];
        }
    }
        
    return cell;
        
    
    
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
    
    
    if (indexPath.row == self.otherArray.count + self.imageArray.count) {
        self.imageCount = collectionView.tag;
        self.currentIndexPath = indexPath;
        UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"相片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
        [action showInView:self.view];
    }
    else{
        if (self.otherArray.count > 0) {
            if (indexPath.row < self.otherArray.count) {
                
                UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
                for (UIImageView * selectView in cell.contentView.subviews) {
                    [SSImageView viewWithImage:selectView.image];
                }
                
            }
            else{
                UIImage * image = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"%ldx",indexPath.row]];
                UIImage * newImage = [WHImageSaveAndLoad image:image rotation:UIImageOrientationRight];
                [SSImageView viewWithImage:newImage];
            }
        }else{
            UIImage * image = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"%ldx",indexPath.row]];
            UIImage * newImage = [WHImageSaveAndLoad image:image rotation:UIImageOrientationRight];
            [SSImageView viewWithImage:newImage];
        }
    }
}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{
            
            NSInteger    sourceType = UIImagePickerControllerSourceTypeCamera;
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            //imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;}
        case 1:{
            NSInteger    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            
            //imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;}
            
        default:
            break;
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    
    if ([type isEqualToString:@"public.image"])
    {
        UIImage * _selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *data;
        
        if (UIImagePNGRepresentation(_selectImage) == nil){
            data = UIImageJPEGRepresentation(_selectImage, 0.0);
        }else{
            data = UIImageJPEGRepresentation(_selectImage, 0.0);
            NSLog(@"------%zu",sizeof(data));
        }
        
        [self sendImageRequestWithImageData:data];
        
        [WHImageSaveAndLoad saveImage:_selectImage withFileName:[NSString stringWithFormat:@"%ldx",self.currentIndexPath.row] ofType:@"png"];
        
        _selectImage = [self imageCompressForWidth:_selectImage targetWidth:self.imageViewWdith];
        
        //创建下一个试图
        [self.imageArray addObject:_selectImage];
        [_collectionView1 reloadData];

        //退出相机
        [picker dismissViewControllerAnimated:YES completion:^{

        }];
    }
}



//上传其他资料请求
- (void)sendImageRequestWithImageData:(NSData *) imageData{
    
    
    
    NSString * str = [NSString stringWithFormat:@"%@upload",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    NSString * imageName = @"other";
   
    
    [params setObject:self.user.ids forKey:@"userId"];
    [params setObject:self.user.token forKey:@"token"];
    [params setObject:imageName forKey:@"name"];
    [params setObject:@"jpg" forKey:@"type"];
    
    [WHSendImageRequest SendImageRequestURL:str dict:params data:imageData name:imageName];
    
}
//跳转加载银行卡
-(void)clickNext{
    
    LDtest2222ViewController * secondController = [[LDtest2222ViewController alloc]init];
    
    [self.navigationController pushViewController:secondController animated:YES];
   
}

//网络请求,获取用户下单时上传的其他资料照片
- (void)requestUserMessageRequest{
    
    
    [HDLoading showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/pictureInfo",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            [HDLoading showFailViewWithString:@"网络错误"];
        }else{
            
            NSString * code = [response objectForKey:@"code"] ;
            
            
            //code == 0请求成功
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                [HDLoading dismissHDLoading];
                
                NSDictionary * dict = [response objectForKey:@"result"];
                
                self.otherArray = [dict objectForKey:@"others"];
             
                [_collectionView1 reloadData];
                
            }else{
                [HDLoading showFailViewWithString:[response objectForKey:@"msg"]];
            }
            
            LDLog(@"%@",response);
        }
    }];
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
@end
