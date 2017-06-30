

#import "WHMineSecondController.h"
#import "WHUserLoginModel.h"
#import "LDBaseInformationTableViewController.h"
#import "WHImageSaveAndLoad.h"
#import "WEImageCropperViewController.h"

@interface WHMineSecondController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//用户对象
@property (nonatomic, strong) WHUserLoginModel * user;



@property (strong, nonatomic) IBOutlet UILabel *DibuBackground;
@end

@implementation WHMineSecondController


//隐藏taber
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航栏的背景色
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    
    
    if (self.selectImage != nil) {
        self.userIconImageView.image = self.selectImage;
        [WHImageSaveAndLoad saveImage:_selectImage withFileName:[NSString stringWithFormat:@"%@.png",[LDUserInformation sharedInstance].UserId ] ofType:@"png"];
    }
    
    
}
//显示taber
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
//个人信息按钮响应方法
- (IBAction)clickUserInfo:(UIButton *)sender {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    //获得用户对像
    self.user = [WHUserLoginModel createuserInfoModel];
    
    self.userNameLabel.text = [LDUserInformation sharedInstance].userName;
    self.phoneLabel.text = self.user.phone;
    
    UIImage * touxiangImage = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"%@.png",[LDUserInformation sharedInstance].UserId ]];
    if (touxiangImage) {
        
        [self.userIconImageView sd_setImageWithURL:nil placeholderImage:touxiangImage];
    }
    
    
    
    
}
//点击头像打开摄像头或相册
- (IBAction)clickIcon:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",action);
    }];
    
    __typeof(self) weakSelf = self;
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    
    UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf LocalPhoto];
    }];
    
    [alertController addAction:photoAction];
    [alertController addAction:pictureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        WEImageCropperViewController *imageCropperViewController = [[WEImageCropperViewController alloc]initWithImage:portraitImg cropFrame:CGRectMake(0, (self.view.frame.size.height - 230)/2, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        
        imageCropperViewController.vc = self;
        [self presentViewController:imageCropperViewController animated:YES completion:^{
            // TO DO
            
            [WHImageSaveAndLoad saveImage:_selectImage withFileName:[NSString stringWithFormat:@"%@.png",[LDUserInformation sharedInstance].UserId ] ofType:@"png"];
            
        }];
    }];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    switch (buttonIndex) {
//        case 0:{
//            
//            NSInteger    sourceType = UIImagePickerControllerSourceTypeCamera;
//            // 跳转到相机或相册页面
//            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//            
//            imagePickerController.delegate = self;
//            
//            //imagePickerController.allowsEditing = YES;
//            
//            imagePickerController.sourceType = sourceType;
//            
//            [self presentViewController:imagePickerController animated:YES completion:^{}];
//            
//            break;}
//        case 1:{
//            NSInteger    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            
//            // 跳转到相机或相册页面
//            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//            
//            imagePickerController.delegate = self;
//            
//            //imagePickerController.allowsEditing = YES;
//            
//            imagePickerController.sourceType = sourceType;
//            
//            [self presentViewController:imagePickerController animated:YES completion:^{}];
//            
//            break;}
//            
//        default:
//            break;
//    }
//}
//-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    
//    //当选择的类型是图片
//    
//    if ([type isEqualToString:@"public.image"])
//    {
//        _selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        
//        NSData *data;
//        
//        if (UIImagePNGRepresentation(_selectImage) == nil){
//            data = UIImageJPEGRepresentation(_selectImage, 1.0);
//        }else{
//            data = UIImagePNGRepresentation(_selectImage);
//        }
//        
//
//        
//        [picker dismissViewControllerAnimated:YES completion:^{
//            
//            self.userIconImageView.image = _selectImage;
//            
//            //保存头像到本地，第一版没有借口
//            [WHImageSaveAndLoad saveImage:_selectImage withFileName:[NSString stringWithFormat:@"%@.png",[LDUserInformation sharedInstance].UserId ] ofType:@"png"];
//            
//        }];
//    }
//}

@end
