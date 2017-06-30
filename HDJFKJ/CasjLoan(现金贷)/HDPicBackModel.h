

#import <Foundation/Foundation.h>

@interface HDPicBackModel : NSObject

//返回码，200标示成功
@property (nonatomic, strong) NSString * errcode;

//返回描述
@property (nonatomic, strong) NSString * msg;

//不知道是啥
@property (nonatomic, strong) NSString * object;

//图片ID
@property (nonatomic, strong) NSString * picId;

//图片Url
@property (nonnull, strong) NSString * absolutePath;

//相对路径
@property (nonnull, strong) NSString * relativePath;

//本地使用的图片Url
@property (nonnull, strong) NSString * picUrl;
@end
