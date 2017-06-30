//
//  LDNetworkTools.h
//  HDJFKJ
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "AFNetworking/AFNetworking.h"
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, LDRequestMethod) {
    GET,
    POST,
};

@interface LDNetworkTools : AFHTTPSessionManager
/// 网络请求的全局访问点
+ (instancetype)sharedTools;

//单独用于发送通讯录的请求
+ (instancetype)sharedToolsForAddressBook;
/// 请求方法
///
/// @param method  方式 get/post
/// @param url     请求地址
/// @param params  请求参数
/// @param success 请成功的回调
/// @param failure 请求失败的回调
- (void)request:(LDRequestMethod)method url:(NSString *)url params:(id)params callback:(void(^)(id response, NSError *error))callback;
/**
 *  文件上传
 /// @param method  post
 /// @param url     请求地址
 /// @param params  请求参数
 /// @param success 请成功的回调
 /// @param failure 请求失败的回调
 */
- (void)request:(LDRequestMethod)method url:(NSString *)url params:(id)params imageData:(NSData *)imageData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *) mimeType callback:(void (^)(id response, NSError *error))callback;

@end
