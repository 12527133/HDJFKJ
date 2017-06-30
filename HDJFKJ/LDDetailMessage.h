//
//  LDDetailMessage.h
//  HDJFKJ
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseUIViewController.h"
@class WHMessageModel;
@interface LDDetailMessage : LDBaseUIViewController
/**
 *  消息ID,消息标识
 */
@property (nonatomic,strong) WHMessageModel * detaileModel;

@end
