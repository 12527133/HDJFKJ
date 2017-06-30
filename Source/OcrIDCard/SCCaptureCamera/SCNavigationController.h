//
//  SCNavigationController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-17.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDefines.h"
#include "Globaltypedef.h"
@protocol SCNavigationControllerDelegate;

@interface SCNavigationController : UINavigationController


- (void)showCameraWithParentController:(UIViewController*)parentController;

@property (nonatomic, assign) id <SCNavigationControllerDelegate> scNaigationDelegate;
@property (nonatomic, assign) TCARD_TYPE iCardType;
@property (nonatomic, assign) BOOL isDisPlayTxt;
@end



@protocol SCNavigationControllerDelegate <NSObject>
@optional
- (BOOL)willDismissNavigationController:(SCNavigationController*)navigatonController;

//- (void)didTakePicture:(SCNavigationController*)navigationController image:(UIImage*)image;

- (void)sendAllValue:(NSString *)text;
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num;
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period;
- (void)sendLPRValue:(NSString *)num;
- (void)sendXSZValue:(NSString *)dp_plateno DP_TYPE:(NSString *)dp_type DP_OWNER:(NSString *)dp_owner DP_ADDRESS:(NSString *)dp_address DP_USECHARACTER:(NSString *) dp_usecharacter DP_MODEL:(NSString *)dp_model DP_VIN:(NSString *) dp_vin DP_ENGINENO:(NSString *)dp_engineno DP_REGISTER_DATE:(NSString *) dp_register_date DP_ISSUE_DATE:(NSString *)dp_issue_date;
- (void)sendJSZValue:(NSString *)dl_num DL_NAME:(NSString *)dl_name DL_SEX:(NSString *)dl_sex DL_COUNTRY:(NSString *) dl_country DL_ADDRESS:(NSString *)dl_address DL_BIRTHDAY:(NSString *)dl_birthday DL_ISSUE_DATE:(NSString *)dl_issue_date DL_CLASS:(NSString *)dl_class DL_VALIDFROM:(NSString *)dl_validfrom DL_VALIDFOR:(NSString *)dl_validfor;
- (void)sendTICValue:(NSString *)tic_start TIC_NUM:(NSString *)tic_num TIC_END:(NSString *)tic_end TIC_TIME:(NSString *)tic_time TIC_SEAT:(NSString *)tic_seat TIC_NAME:(NSString *) tic_name;
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage;
- (void)sendIDCARDBackAction;
@end