//
//  LDNMineTableViewCell.m
//  OCLDProject
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDNMineTableViewCell.h"
#import "WHSaveAndReadInfomation.h"
#import "HDScoreModel.h"

#define Width 96 * LDScreenWidth/375
#define TOP 7 * LDScreenWidth/375
@interface LDNMineTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@property (weak, nonatomic) IBOutlet UIButton *bottomButon;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (weak, nonatomic) IBOutlet UIView *scoreView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scoreHeight;

@end


@implementation LDNMineTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = WHColorFromRGB(0xfd5d14);
    self.scoreView.backgroundColor = LDRGBColor(0, 0, 0, 12.81/100);
}
- (void)layoutSubviews{
    
    [super layoutSubviews];

    self.width.constant = Width;
    self.height.constant = Width;
    self.top.constant = TOP;
    
    self.headerImageView.image = [UIImage imageNamed:@"touxiang-weidenglu"];
        
    /** 电话号码  */
    if ([LDUserInformation sharedInstance].phoneNumber != nil) {
        NSMutableString *phone = [[NSMutableString alloc] initWithString:[LDUserInformation sharedInstance].phoneNumber];
        [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneNum.text = phone;
        
        
    }
    
    /** 实名认证设置 */
    if ([LDUserInformation sharedInstance].userName != nil) {
        self.bottomButon .hidden = NO;
    }
    else{
        self.bottomButon.hidden = YES;
    }
    
    /** 5.获取旧的信用分 */
    NSString * score = [WHSaveAndReadInfomation readXinYongFen];
    
    NSArray * array = [score componentsSeparatedByString:@"-"];
    score = array[0];
    
    if ([score intValue] > 0) {
        self.scoreLable.text = [NSString stringWithFormat:@"信用分：%@",score] ;
    }else{
        [self getCreditScore] ;
    }

    if (Is_Iphone4) {
        
        self.phoneNum.font = [UIFont systemFontOfSize:13];
        self.bottomButon.titleLabel.font =[UIFont systemFontOfSize:8];
        self.width.constant = 60;
        self.height.constant = 60;
        self.scoreLable.font = [UIFont systemFontOfSize:10];
        
    }
    
    if (Is_Iphone5) {
        
        self.phoneNum.font = [UIFont systemFontOfSize:15];
        self.bottomButon.titleLabel.font =[UIFont systemFontOfSize:9];
        self.scoreLable.font = [UIFont systemFontOfSize:11];
        
    }
    self.scoreHeight.constant = 30 * LDScreenWidth/375;
    self.scoreWidth.constant = 112 * LDScreenWidth/375 + 30 * LDScreenWidth/375/2;
    
    //实名认证
    [self.bottomButon.layer setCornerRadius:3.0];
    //设置矩形四个圆角半径
    [self.bottomButon.layer setBorderWidth:1.0];
    //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255, 255, 255, 1 });
    [self.bottomButon.layer setBorderColor:colorref];
    [self.bottomButon.layer setMasksToBounds:YES];

   
    self.scoreView.layer.cornerRadius = 30 * LDScreenWidth/375/2;
    self.scoreView.layer.masksToBounds = YES;
    
//    if (Is_Iphone4) {
//        
//        self.headerImageView.layer.cornerRadius = 30;
//
//    }else if (Is_Iphone5)
//        
//        self.headerImageView.layer.cornerRadius = 96 * LDScreenWidth/375/2;
//
//    else{
//        
//        self.headerImageView.layer.cornerRadius = self.headerImageView.LDWidth/2;
//
//    }
   // self.headerImageView.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getCreditScore{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/getCreditScore",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
           
            
        }
        else
        {
            NSLog(@"%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                /** 4.解析信用分  */
                if (backInfo.result != nil) {
                    HDScoreModel * scoreModel = [HDScoreModel mj_objectWithKeyValues:backInfo.result];
                    
                    if (scoreModel.creditScore == nil) {
                        scoreModel.creditScore = @"100";
                    }
                    self.scoreLable.text = [NSString stringWithFormat:@"信用分：%@",scoreModel.creditScore];
                    /** 9.存储新的信用分*/
                    NSString * nesScore = [NSString stringWithFormat:@"%@-%@",scoreModel.creditScore,scoreModel.level];
                    [WHSaveAndReadInfomation saveXinYongFen:nesScore];
                }
            }
        }
    }];
    
}


@end
