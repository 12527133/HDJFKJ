

#import <Foundation/Foundation.h>

@interface HDMaterialOperate : NSObject

//保存图片
+ (void)saveMaterialImageWith:(UIImage *)image ImageName:(NSString *)imageName;
//读取图片
+ (UIImage *)readImageWithImageName:(NSString *)imageName;
//删除文件夹
+ (void)deleteGroup;
@end
