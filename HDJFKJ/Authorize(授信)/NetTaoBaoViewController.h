//
//  NetTaoBaoViewController.h
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TaoBaoBlock)(NSString * string);
@interface NetTaoBaoViewController : LDBaseUIViewController
@property (nonatomic, copy) TaoBaoBlock taobaoBlock;
@end
