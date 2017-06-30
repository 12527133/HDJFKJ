

#import <UIKit/UIKit.h>
#import "AccessInfo.h"
#import "OnDatabaseImageCapturedEventListener.h"
#import "UserRegisterImageType.h"
#import "FaceRect.h"

@interface CaptureDatabaseImageViewController : UIViewController

typedef NS_ENUM(int, DatabaseImageCaptureMode)
{
    DEFAULT = 0, // 默认模式
    IDCARD_FRONT = 1, // 身份证正面照片
    IDCARD_BACK = 2 // 身份证背面照片
};
@property DatabaseImageCaptureMode captureMode;

/**
 *  启动登记照片捕获
 *
 *  @param onCapturedListener 捕获成功后的回调
 *  @param accessInfo 客户信息
 *  @param mode 拍摄模式，参考DatabaseImageCaptureMode
 *
 *  @return 是否拍摄成功
 */
- (BOOL) startDatabaseImageCapture:(id<OnDatabaseImageCapturedEventListener>) onCapturedListener
                    withAccessInfo:(AccessInfo*) accessInfo
                   withCaptureMode:(DatabaseImageCaptureMode) mode;

-(void)passValues:(NSString *)value1 withSecondValue:(NSString*)value2;

@end
