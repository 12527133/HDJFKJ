//
//  LDMyScoreDown.h
//  HDJFKJ
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LDMySoreModel;
@interface LDMyScoreDown : UITableViewCell
/** 模型  */
@property (nonatomic,strong) LDMySoreModel * SoreModel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *whichInfor;
@property (weak, nonatomic) IBOutlet UILabel *isCompleted;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
