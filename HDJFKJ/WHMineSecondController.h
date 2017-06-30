

#import <UIKit/UIKit.h>

@interface WHMineSecondController : LDBaseUIViewController
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
//用户姓名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
//用户姓名Label
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//图片按钮
@property (weak, nonatomic) IBOutlet UIButton *imageButton;


//调取相机或相册选择的照片
@property (nonatomic, strong) UIImage * selectImage;

@end
