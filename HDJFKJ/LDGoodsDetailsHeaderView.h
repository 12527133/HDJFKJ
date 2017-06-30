//
//  LDGoodsDetailsHeaderView.h
//  HDJFKJ
//
//  Created by apple on 16/3/24.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDGoodsDetailsHeaderView : UIView
/**
 *  商品详情图片轮播
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
/**
 *  分割线
 */
@property (weak, nonatomic) IBOutlet UIView *separatorLine;
/**
 *  商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
/**
 *  五个button
 */
@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *tow;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;
/**
 *  商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyCount;
/**
 *  image-免费
 */
@property (weak, nonatomic) IBOutlet UIImageView *freeImageView;
/**
 *  首付价格 + 分期数
 */
@property (weak, nonatomic) IBOutlet UILabel *downPay;


@end
