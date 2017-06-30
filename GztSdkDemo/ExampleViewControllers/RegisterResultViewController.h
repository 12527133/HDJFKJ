

#import <UIKit/UIKit.h>
#import "LivenessResultDelegate.h"

@interface RegisterResultViewController : UIViewController

/**
 *  设置注册结果页面的信息
 *
 *  @param image 翻拍捕获到的照片
 *  @param label 上传照片结果
 */
- (void) setResultImage: (UIImage *) image;

@end
