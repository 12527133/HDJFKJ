//
//  LDReviewModel.h
//  HDJFKJ
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDReviewModel : NSObject
/** 人脸识别是否通过  */
@property (nonatomic,strong) NSString * faceVerified;
/** 客户名称  */
@property (nonatomic,strong) NSString * idName;
/** 身份证号  */
@property (nonatomic,strong) NSString * idNo;
/** 身份：
 1 学生
 2 上班族
 3 创业者
  */
@property (nonatomic,strong) NSString * occupation;
/** 单位名称  */
@property (nonatomic,strong) NSString * company;
/** 联系人集合  */
@property (nonatomic,strong) NSArray * hdCustContactsList;
/** 其他资料图片地址  */
@property (nonatomic,strong) NSMutableArray * picList;
/** 学信网授权  */
@property (nonatomic,strong) NSString * learningAuthorizeStatus;
/** 运营商授权  */
@property (nonatomic,strong) NSString * operatorAuthorizeStatus;
/** 淘宝授权  */
@property (nonatomic,strong) NSString * taobaoAuthorizeStatus;
/** 社保授权  */
@property (nonatomic,strong) NSString * securityauthorizeStatus;

/** 海尔消费金服标示 */
@property (nonatomic, strong) NSString * fundDescription;
/** 海尔图片url*/
@property (nonatomic, strong) NSString * fundLogoUrl;

@end
@interface LDReviewContactModel : NSObject



@end
@interface LDReviewOtherModel : NSObject
/** 联系人名称  */
@property (nonatomic,strong) NSString * name;
/** 联系人电话  */
@property (nonatomic,strong) NSString * phone;
/** 客户与联系人1关系  */
@property (nonatomic,strong) NSString * relation;
/** 联系人类型  */
@property (nonatomic,strong) NSString * type;




@end