
//
//  LDAdvancedInformation.m
//  HDJFKJ
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//
#import "LDAdvancedInformation.h"
#import "LDContactInformationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LDAdvancedInformation ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *FrontPhoto;
@property (weak, nonatomic) IBOutlet UIButton *backPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *FrontImage;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (nonatomic ,strong) UIImagePickerController *picker;

@end

@implementation LDAdvancedInformation{
    UIButton *tagButton;
}

#pragma mark - Lazy
-(UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
    }
    return _picker;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"高级信息";
}

- (IBAction)FrontphotoButtonClick:(id)sender {
    
    tagButton = (UIButton *)sender;
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
    
        [alertVC addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self chooseLogoFromPhotoLibrary];
        
    }]];

    [alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseLogoFromTakingPhoto];
        
        }]];

        [self presentViewController:alertVC animated:YES completion:nil];
        

    
}

-(void)chooseLogoFromPhotoLibrary{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    
    //设置选择后的图片可被编辑
    self.picker.allowsEditing = NO;
    
    [self presentViewController:self.picker animated:YES completion:^{
        
    }];
}

-(void)chooseLogoFromTakingPhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.picker.delegate = self;
        //设置拍照后的图片可被编辑
        self.picker.allowsEditing = NO;
        self.picker.sourceType = sourceType;
        [self presentViewController:self.picker animated:YES completion:^{
            
        }];
    }else
    {
    }
}



#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    NSLog(@"%@",info);
    //获取图片
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    //图片转成
    NSData * imageData1 = UIImageJPEGRepresentation(image, 1);

    //上传头像到服务器
    NSString * urlString = [NSString stringWithFormat:@"%@picture/upload",KBaseUrl];
    NSDictionary *parameter = @{
                                @"token":[LDUserInformation sharedInstance].token,
                                @"id":[LDUserInformation sharedInstance].UserId,
                                @"type":@"1",
                                @"idTermBegin":@"33",
                                @"idTermEnd":@"44",
                                };
    

    
   [[LDNetworkTools sharedTools] request:POST url:urlString params:parameter imageData:imageData1 name:@"000000" fileName:@"4444444.png" mimeType:@"image.png" callback:^(id response, NSError *error) {
       if (error != nil) {
           
           
           LDLog(@"11111122222222222221112error请求失败%@",error);
           [self dismissViewControllerAnimated:YES completion:^{
               
           }];

       }else{
           
           [self dismissViewControllerAnimated:YES completion:^{
               
           }];
           LDLog(@"%@",response);
           
       }
   }];
    
    
    switch (tagButton.tag) {
        case 11111:
            self.FrontImage.image = image;
            break;
        case 22222:
            self.backImage.image = image;
            break;
        default:
            break;
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}


- (IBAction)nextButtonClick:(id)sender {
    
    
        
        LDContactInformationViewController * vc = [[LDContactInformationViewController alloc] init];
    
        vc.fromeWhere  =self.fromeWhere;
        
        [self.navigationController pushViewController:vc animated:YES];
        
}






@end
