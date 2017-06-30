//
//  LDReViewInformation.h
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseUIViewController.h"
#import "LDReviewModel.h"



@interface LDReViewInformation : LDBaseUIViewController
/**
 *  商品ID
 */
@property(nonatomic,copy) NSString * goodsID;

/** 跳转来源  */
@property (nonatomic, strong) NSString * fromWhere;

/** 审核信息模型  */
@property (nonatomic, strong) LDReviewModel * reviewModel;

@property (nonatomic, strong) NSMutableArray * pictureArr;
@end
