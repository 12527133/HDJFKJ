

#import "LDBaseUIViewController.h"

/** 图锐拍照 */
#import "Globaltypedef.h"
#import "SCCaptureCameraController.h"
#import "IOSOCRAPI.h"

@interface HDReviewPictureController : LDBaseUIViewController

/** name  */
@property (nonatomic,strong) NSString * packageId;

//@property (nonatomic, strong) HDPreviewModel * previewModel;

/** 1.身份证照 */
@property (nonatomic, strong) UIImage * zhengmianImage;
@property (nonatomic, strong) UIImage * fanmianImage;
@property (nonatomic, strong) UIImage * faceImage;

/** 2.贷款申请表  */
@property (nonatomic, strong) NSMutableArray * rentContractArr;

/** 3.收入证明  */
@property (nonatomic, strong) NSMutableArray * actContractArr;

@end
