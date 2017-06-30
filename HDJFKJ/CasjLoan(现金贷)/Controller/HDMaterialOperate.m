

#import "HDMaterialOperate.h"
#define DirectoryPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation HDMaterialOperate


//create Group And Save Image
+ (void)saveMaterialImageWith:(UIImage *)image ImageName:(NSString *)imageName{

    NSString * imageGroup = [NSString stringWithFormat:@"%@/material",DirectoryPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageGroup])//判断createPath路径文件夹是否已存在，此处createPath为需要新建的文件夹的绝对路径
    {
        NSString * imagePath = [imageGroup stringByAppendingPathComponent:imageName];
        
        [UIImagePNGRepresentation(image) writeToFile:imagePath options:NSAtomicWrite error:nil];
    }
    else
    {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:imageGroup withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        
        NSString * imagePath = [imageGroup stringByAppendingPathComponent:imageName];
        [UIImagePNGRepresentation(image) writeToFile:imagePath options:NSAtomicWrite error:nil];
    }
}

//read Image
+ (UIImage *)readImageWithImageName:(NSString *)imageName{

    //读取图片
    
     NSString * imageGroup = [NSString stringWithFormat:@"%@/material",DirectoryPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageGroup])    {
        
        NSString * imagePath = [imageGroup stringByAppendingPathComponent:imageName];
        UIImage * result = [UIImage imageWithContentsOfFile:imagePath];
        
    
        return result;
    }
    
    return nil;
}

//Delete Group
+ (void)deleteGroup{

    //开启子线程
    dispatch_queue_t queue = dispatch_queue_create("SecondConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
        NSString * imageGroup = [NSString stringWithFormat:@"%@/material",DirectoryPath];
        
        //删除文件夹
        if([[NSFileManager defaultManager] fileExistsAtPath:imageGroup])//如果存在临时文件的配置文件
        {
            [[NSFileManager defaultManager]  removeItemAtPath:imageGroup error:nil];
            
        }
    });
    
    
}

@end
