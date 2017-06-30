//
//  FaceVerificationResult.h
//  LivenessDetector
//
//  Created by Xiaoyang Lin on 16/1/22.
//  Copyright © 2016年 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceVerificationResult : NSObject

// 请参考接口文档《CS102.1 身份验证: 身份比对接口》

@property int rtn;//请求处理结果的错误代码
@property NSString * message;//请求处理结果的错误信息，会对错误的rtn值进行解释
@property int pairVerifyResult;//0 表示认为是查询照片中出现了给定身份的人,1表示不是
@property double pairVerifySimilarity;//相似值， 值越大越相似 分数取值范围在0-100

// 比对数据包
@property NSString *customerDefinedContent; // 客户定制数据内容
@property NSArray *queryImageContents; // 身份比对数据包中保存的图像

@end
