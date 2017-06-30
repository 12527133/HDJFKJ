

#import <Foundation/Foundation.h>
//用于图片保存在沙河目录
@interface WHImageSaveAndLoad : NSObject
//保存图片到沙河目录
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension;

//从沙河目录读取图片
+(UIImage *) loadImage:(NSString *)fileName;

//从沙河目录中删除图片
+ (void)deleteImage:(NSString *)fileName;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end


