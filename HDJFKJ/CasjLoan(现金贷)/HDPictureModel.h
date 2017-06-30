

#import <Foundation/Foundation.h>

@interface HDPictureModel : NSObject

/** 图片url*/
@property (nonatomic, strong) NSString * picUrl;

/** 图片id */
@property (nonatomic, strong) NSString * picId;

/** 缩略图 */
@property (nonatomic, strong) UIImage * thumbnail;
@end
