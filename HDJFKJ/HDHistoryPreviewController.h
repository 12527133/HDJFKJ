

#import "LDBaseUIViewController.h"
#import "HDPictureModel.h"
typedef void(^DeletePictureBlock)(HDPictureModel * picModel);
@interface HDHistoryPreviewController : LDBaseUIViewController

/** 选中图片数组  */
@property (nonatomic, strong) NSMutableArray * pictureArray;

@property (nonatomic, strong) DeletePictureBlock  deletePicBlock;

@end
