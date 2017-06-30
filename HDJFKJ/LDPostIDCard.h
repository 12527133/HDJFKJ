//
//  LDPostIDCard.h
//  OCLDProject
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globaltypedef.h"
#import "SCCaptureCameraController.h"
#import "IOSOCRAPI.h"

@interface LDPostIDCard : LDBaseUIViewController
/**
 *  哪个流程"zhuce","xiadan","wode",取值情况:三个字符串,
 */
@property (nonatomic,copy) NSString * fromeWhere;

//是否请求上传的图片
@property (nonatomic, assign) BOOL requestImage;

//是否上传扫描的用户基本信息
@property (nonatomic, assign) BOOL sendUserMessage;

//从信信用分传过来的值
@property (nonatomic, strong) NSString *  currentcode;
@end
