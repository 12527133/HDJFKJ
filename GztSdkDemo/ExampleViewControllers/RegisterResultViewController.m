

#import "RegisterResultViewController.h"
#import "LivenessDetectionViewController.h"
#import "ExampleResultViewController.h"
#import "CaptureDatabaseImageViewController.h"

@interface RegisterResultViewController ()
// 捕获到的图片
@property (weak, nonatomic) IBOutlet UIImageView *resultUIImage;

@end

@implementation RegisterResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



/**
 *  设置注册结果页面的信息
 *
 *  @param image 翻拍捕获到的照片
 */
- (void) setResultImage: (UIImage *) image {
    [_resultUIImage setImage:image];
}

@end
