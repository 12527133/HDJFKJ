

#import "WHImageSaveAndLoad.h"

@implementation WHImageSaveAndLoad

//图片保存到沙河目录
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension {
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        
        [UIImagePNGRepresentation(image) writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]] options:NSAtomicWrite error:nil];
        
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        
    } else {
        NSLog(@"文件后缀不认识");
    }
}

//从沙河目录读取图片
+(UIImage *) loadImage:(NSString *)fileName{
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",documentsDirectoryPath);
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, fileName]];
    
    return result;
}

//删除沙河目录中的图片
+ (void)deleteImage:(NSString *)fileName{
    
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, fileName];
    
    //获取文件操作对象
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
    //判断要删除的文件是否存在
    if ([defaultManager isDeletableFileAtPath:filePath]) {
        //如果存在，删除。
        [defaultManager removeItemAtPath:filePath error:nil];
    }
}
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    //CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width/10, rect.size.height/10), image.CGImage);
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
@end
