

#import "WHSendImageRequest.h"

@implementation WHSendImageRequest

+(void)SendImageRequestURL:(NSString *)str dict:(NSDictionary *)params data:(NSData *)imageData name:(NSString *)imageName{
    [HDLoading showWithImageWithString:@"上传中..."];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params imageData:imageData name:imageName fileName:@"image.jpg" mimeType:@"image.jpg" callback:^(id response, NSError *error) {
        if (error != nil) {
            
            [HDLoading showFailViewWithString:@"网络错误"];
            
            LDLog(@"UIImagePickerControllerOriginalImage--error请求失败%@",error);
        }else{
            NSString * code = [response objectForKey:@"errcode"] ;
            //code == 200请求成功
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"200"]) {
                [HDLoading dismissHDLoading];
                
            }else{
                // 显示失败信息
                [HDLoading showFailViewWithString:[response objectForKey:@"msg"]];
            }
            LDLog(@"%@",response);
            
        }
    }];

}

@end
