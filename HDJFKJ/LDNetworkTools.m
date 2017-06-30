//
//  LDNetworkTools.m
//  HDJFKJ
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNetworkTools.h"

@protocol LDRequestProxy <NSObject>

@optional

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@interface LDNetworkTools ()<LDRequestProxy>

@end
@implementation LDNetworkTools
+ (instancetype)sharedTools{
    static LDNetworkTools *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [LDNetworkTools manager];
        //设置解析类型
        instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
            });
        instance.requestSerializer.timeoutInterval = 20.0;
        [instance.requestSerializer setValue:@"false"forHTTPHeaderField:@"humpJsonStyle"];
    return instance;
}
+ (instancetype)sharedToolsForAddressBook{
    static LDNetworkTools *instanceX;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instanceX = [LDNetworkTools manager];
        //设置解析类型
        instanceX.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
        [instanceX.requestSerializer setValue:@"false"forHTTPHeaderField:@"humpJsonStyle"];
    });
    [instanceX.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return instanceX;
}
#pragma mark - get post普通网络工具类
- (void)request:(LDRequestMethod)method url:(NSString *)url params:(id)params callback:(void (^)(id, NSError *))callback{
    
    //根据传入的请求类型,计算出请求方式的字符串
    NSString * mtd = (method == GET) ? @"GET":@"POST";
    
    [[self dataTaskWithHTTPMethod:mtd URLString:url parameters:params uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        
        
        callback(response,nil);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
        callback(nil, error);
        
    }] resume];
}
/** 发送图片的请求 */
- (void)request:(LDRequestMethod)method url:(NSString *)url params:(id)params imageData:(NSData *)imageData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *) mimeType callback:(void (^)(id, NSError *))callback{
    
    
    [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       callback(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
       callback(nil, error);
        
    }];
}



@end












