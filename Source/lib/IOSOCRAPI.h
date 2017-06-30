//
//  IOSOCRAPI.h
//  IOSOCRAPI
//
//  Created by Turui on 15/8/6.
//  Copyright (c) 2015年 Turui. All rights reserved.
//

#ifndef IOS_OCR_H
#define IOS_OCR_H
#import <UIKit/UIKit.h>
#include "Globaltypedef.h"

NSString *TREC_GetVersionArray();// 获取版本信息
NSString *TREC_GetCopyrightInfoArray();//获取版权信息
NSString *TREC_GetTimeStatus();// 获取引擎测试时间
Int TREC_StartUP();//引擎初始化
Int TREC_SetParam(TPARAM euType, void* pValue);//引擎设置参数
Int TREC_GetParam(TPARAM euType, void* pValue);//引擎获取设置参数
Int TREC_GetSupportEngine(TCARD_TYPE iCardType);
Int TREC_SetSupportEngine(TCARD_TYPE iCardType);
Int TREC_LoadImage(UIImage *uimage);// 引擎 加载图片
Int TREC_LoadImage_Ex(NSString *pImagePath);// 引擎加载图片(图片路径形式)
Int TREC_JudgeExist(Int x1, Int y1, Int x2, Int y2);
Int TREC_SaveImage(NSString *pImagePath);// 保存图片到本地
Int TREC_OCR();// 引擎识别
Int TREC_FreeImage();// 引擎识别(图片路径形式)
TCARD_TYPE TREC_GetCardType();// 引擎识别
NSString *TREC_GetOcrString();// 获取全部的信息
NSString *TREC_GetFieldString(TFIELDID  field);// 获取各个栏的识别信息
Int  TREC_GetCardNumState();// 获取身份证证号状态
UIImage *TREC_GetHeadImage();// 获取人头像图片流
Int TREC_SaveHeadImage(NSString *path);// 保存人头像到本地
Int TREC_ClearUP();//引擎释放

// 银行卡接口
Int TBANK_LoadImage(UIImage *uimage);      // 银行卡导入图片
Int TBANK_JudgeExist(Int x1, Int y1, Int x2, Int y2); //  银行卡找边
Int TBANK_OCR();// 银行卡识别
Int TBANK_SaveImage(NSString *ImagePath);   // 银行卡保存图片
Int TBANK_FreeImage();                      // 银行卡释放函数
UIImage *TBANK_GetSmallImage();             // 获取识别区域图片
NSString *TBANK_GetBankInfoString(TGETBANKINFOID tGetBankId);   // 根据识别到的卡号进行信息查询
NSString *TBANK_GetPublicBankInfoString(TGETBANKINFOID tGetBankId,NSString *BankCardNum);// 根据自定义卡号，获取信息

#endif
