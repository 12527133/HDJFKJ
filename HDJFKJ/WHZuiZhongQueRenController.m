//
//  WHZuiZhongQueRenController.m
//  HDJFKJ
//
//  Created by 石伟浩 on 16/4/6.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "WHZuiZhongQueRenController.h"
#import "WHSignController.h"
#import "WHComfierOrderPassword.h"
#import "WHUserLoginModel.h"
@interface WHZuiZhongQueRenController ()


@property (nonatomic,strong) WHUserLoginModel * user;


@end

@implementation WHZuiZhongQueRenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTopViewLabel];
    
    [self createMiddleLabel];
    
    [self createBottomViewLabel];
    
    self.aginSignButton.hidden= YES;
    self.sureButton.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.user = [WHUserLoginModel createuserInfoModel];
    
    self.orderIDLabel.text = self.orderDetailModel.orderno;
    self.orderTimeLabel.text = self.orderDetailModel.time;
    self.fenqiLabel.text = self.orderDetailModel.duration;
    self.qigongjinELabel.text = [NSString stringWithFormat:@"%@元",self.orderDetailModel.periodamount];
}


//创建上部分视图的label
- (void)createTopViewLabel{
    UILabel * labe1 = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375, LDScreenHeight * 16/667, 52, 13)];
    labe1.text = @"订单号：";
    labe1.textColor = WHColorFromRGB(0x051b28);
    labe1.font = [UIFont systemFontOfSize:13];
    [self.topView addSubview:labe1];
    
    self.orderIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375 + 52, LDScreenHeight * 16/667, 155, 13)];
    self.orderIDLabel.text = @"213485960210203-1230";
    self.orderIDLabel.textColor = WHColorFromRGB(0xc8c7cc);
    self.orderIDLabel.font = [UIFont systemFontOfSize:13];
    [self.topView addSubview:self.orderIDLabel];
    
    UILabel * labe2 = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375, LDScreenHeight * (16+13+23)/667 , 65, 13)];
    labe2.text = @"下单时间：";
    labe2.textColor = WHColorFromRGB(0x051b28);
    labe2.font = [UIFont systemFontOfSize:13];
    [self.topView addSubview:labe2];
    
    self.orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375 + 65, LDScreenHeight * (16+13+23)/667 , 140, 13)];
    self.orderTimeLabel.text = @"2016-02-10 00:24:18";
    self.orderTimeLabel.textColor = WHColorFromRGB(0xc8c7cc);
    self.orderTimeLabel.font = [UIFont systemFontOfSize:13];
    [self.topView addSubview:self.orderTimeLabel];
    

}

//创建中间视图的Label
- (void)createMiddleLabel{

//    UILabel * labe1 = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375, LDScreenHeight * 16/667, 65, 13)];
//    labe1.text = @"支付方式：";
//    labe1.textColor = WHColorFromRGB(0x051b28);
//    labe1.font = [UIFont systemFontOfSize:13];
//    [self.middleView addSubview:labe1];
//    
//    self.paywayLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375 + 65, LDScreenHeight * 16/667, 140, 13)];
//    self.paywayLabel.text = @"互动金服";
//    self.paywayLabel.textColor = WHColorFromRGB(0xc8c7cc);
//    self.paywayLabel.font = [UIFont systemFontOfSize:13];
//    [self.middleView addSubview:self.paywayLabel];
    
    UILabel * labe2 = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375, LDScreenHeight * (16+13+23)/667 , 52, 13)];
    labe2.text = @"分期数：";
    labe2.textColor = WHColorFromRGB(0x051b28);
    labe2.font = [UIFont systemFontOfSize:13];
    [self.middleView addSubview:labe2];
    
    self.fenqiLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375 + 52, LDScreenHeight * (16+13+23)/667 , 130, 13)];
    self.fenqiLabel.text = @"12";
    self.fenqiLabel.textColor = WHColorFromRGB(0xc8c7cc);
    self.fenqiLabel.font = [UIFont systemFontOfSize:13];
    [self.middleView addSubview:self.fenqiLabel];
    
    UILabel * labe3 = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375, LDScreenHeight * (16+13+23+13+23)/667 , 65, 13)];
    labe3.text = @"每期支付：";
    labe3.textColor = WHColorFromRGB(0x051b28);
    labe3.font = [UIFont systemFontOfSize:13];
    [self.middleView addSubview:labe3];
    
    self.qigongjinELabel = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375 + 65, LDScreenHeight * (16+13+23+13+23)/667 , 130, 13)];
    self.qigongjinELabel.text = @"366.7元";
    self.qigongjinELabel.textColor = WHColorFromRGB(0xd33a31);
    self.qigongjinELabel.font = [UIFont systemFontOfSize:13];
    [self.middleView addSubview:self.qigongjinELabel];
}

//创建下部分视图的label
- (void)createBottomViewLabel{
    UILabel * labe1 = [[UILabel alloc]initWithFrame:CGRectMake(LDScreenHeight * 11/375, LDScreenHeight * 16/667, 65, 13)];
    labe1.text = @"客户签名";
    labe1.textColor = WHColorFromRGB(0x051b28);
    labe1.font = [UIFont systemFontOfSize:13];
    [self.bottomView addSubview:labe1];
    
}


//点击签名按钮
- (IBAction)clickSignButton:(UIButton *)sender {
    
    
    [self.imageView removeFromSuperview];
    
    WHSignController * signController = [[WHSignController alloc]init];
    
    
    [self.navigationController presentViewController:signController animated:YES completion:nil];
    
    signController.complationBlock = ^(UIImage * signImage){
        self.imageView = [[UIImageView alloc]initWithImage:signImage];
        
        self.imageView.frame = CGRectMake(LDScreenHeight * 11/375 + 100, 10, (self.bottomView.frame.size.height - 20) * self.imageView.frame.size.width/self.imageView.size.height, self.bottomView.frame.size.height - 20);
        
        [self.bottomView addSubview:self.imageView];
        
        self.sureButton.hidden = NO;
        self.aginSignButton.hidden = NO;

    
    };
    
}

- (IBAction)clickSureButton:(UIButton *)sender {
    
    NSString * str = [NSString stringWithFormat:@"%@picture/upload",KBaseUrl ];
    NSData * imageData = UIImageJPEGRepresentation(self.imageView.image, 0.0);
    [HDLoading showWithImageWithString:@"正在提交"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:self.user.ids forKey:@"id"];
    [params setObject:self.user.token forKey:@"token"];
    [params setObject:@"3" forKey:@"type"];
    [params setObject:self.orderDetailModel.orderno forKey:@"applyId"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params imageData:imageData name:@"signPic" fileName:@"image.jpg" mimeType:@"image.jpg" callback:^(id response, NSError *error) {
        if (error != nil) {
            
            [HDLoading showFailViewWithString:@"网络错误"];
            
            LDLog(@"UIImagePickerControllerOriginalImage--error请求失败%@",error);
        }else{
            NSString * code = [response objectForKey:@"code"] ;
            //code == 200请求成功
            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
                [HDLoading dismissHDLoading];
                
                WHComfierOrderPassword * confirmPassword = [[WHComfierOrderPassword alloc]init];
                confirmPassword.orderDetailModel = self.orderDetailModel;
                [self.navigationController pushViewController:confirmPassword animated:YES];
                
                
            }else{
              
                [HDLoading showFailViewWithString:[response objectForKey:@"message"]];
            }
            LDLog(@"%@",response);
            
        }
    }];
}

















@end
