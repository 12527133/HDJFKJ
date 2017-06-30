//
//  LDMySore.m
//  HDJFKJ
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDMySore.h"
#import "LDMyScoreDown.h"
#import "LDBaseInformationTableViewController.h"
#import "LDPostIDCard.h"
#import "LDContactInformationViewController.h"
#import "AuthorizViewController.h"
#import "LDGoodsDetailModel.h"
#import "LDPaymentPasswordController.h"
#import "WHScoreTopView.h"
#import "WHRotainView.h"
#import "WHWorkViewController.h"
#import "WHCustomInfoInfoStepAll.h"
#import "WHXinYongFenAgreementController.h"
#import "WHSaveAndReadInfomation.h"
#import "HDScoreModel.h"

#import "HDCreditScoreTopView.h"
#import "HDCreditScoreBottomView.h"

@interface LDMySore ()


/** cell  */
@property (nonatomic,assign) BOOL  IDcard;
@property (nonatomic,assign) BOOL  job;
@property (nonatomic,assign) BOOL  contact;
@property (nonatomic,assign) BOOL  Auto;
@property (nonatomic,assign) BOOL  pay;

//顶部试图
@property (nonatomic, strong) HDCreditScoreTopView * topView;
@property (nonatomic, strong) HDCreditScoreBottomView * bottomView;
@property (nonatomic, strong) UIView * backgroundView;

@property (nonatomic, strong) WHRotainView * rotainView;

//信息完善度模型
@property (nonatomic, strong) WHCustomInfoInfoStepAll * customInfo;

@property (nonatomic, strong) NSTimer * scoreTimer;
@property (nonatomic, assign) NSInteger scoreNum;
@end

@implementation LDMySore



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
   
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //刷新信息完整度
    [self sendRequest];
   
}

- (void)dealloc{
    
    LDLog(@"销毁信用分控制器 ");
}

- (void)viewDidLoad{
    
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    [super viewDidLoad];
    
    self.title = @"我的资料";
    
    /** 1.创建顶部的信用分试图   */
    [self createTopView];
    
    /** 2.创建底部视图         */
    [self createBottomView];
    
   
    
    /** 4.创建导航栏右侧帮助按钮 */
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"帮助" target:self action:@selector(rightButtonClick)];
}

/** 1.创建顶部视图 */
- (void)createTopView{
    
    self.topView = [[HDCreditScoreTopView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 230*bili)];
    [self.view addSubview:self.topView];
    [self.topView createSubViews];

}

/** 2.创建底部信息类型视图 */
- (void)createBottomView{
    self.bottomView = [[HDCreditScoreBottomView alloc]initWithFrame:CGRectMake(0, self.topView.frame.size.height + 15*bili, LDScreenWidth, 200*bili)];
    [self.view addSubview:self.bottomView];
    [self.bottomView createSubViews];
    
    [self.bottomView.button1 addTarget:self action:@selector(clickShiming:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView.button2 addTarget:self action:@selector(clickShenfen:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView.button3 addTarget:self action:@selector(clickLianxiren:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.bottomView.button4 addTarget:self action:@selector(clickShouquan:) forControlEvents:(UIControlEventTouchUpInside)];

}
/** 点击实名按钮 */
- (void)clickShiming:(UIButton *)button{

    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:SFZXXZL];
    
    LDPostIDCard * cardVC = [[LDPostIDCard alloc] init];
    
    cardVC.fromeWhere = @"xinyongfen";
    
    if ([self.customInfo.advancedInfo isEqualToString:@"1"]) {
        cardVC.requestImage = YES;
    }
    else{
        cardVC.requestImage = NO;
    }
    if ([self.customInfo.basicInfo isEqualToString:@"1"]) {
        cardVC.sendUserMessage = YES;
    }
    
    
    [self.navigationController pushViewController:cardVC animated:YES];
}
/** 点击身份按钮 */
- (void)clickShenfen:(UIButton *)button{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:CYXXZL];
    
    if ([self.customInfo.basicInfo isEqualToString:@"1"]) {
        WHWorkViewController * type = [[WHWorkViewController alloc] init];
        
        
        type.fromeWhere = @"xinyongfen";
        type.workInfo = self.customInfo.workInfo;
        
        [self.navigationController pushViewController:type animated:YES];
    }
    else{
        [self showFailViewWithString:@"请先完善基本信息"];
    }
}
/** 点击联系人按钮 */
- (void)clickLianxiren:(UIButton *)button{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:LXRXXZL];
    
    if ([self.customInfo.basicInfo isEqualToString:@"1"]) {
        
        LDContactInformationViewController * contact = [[LDContactInformationViewController alloc] init];
        
        contact.isFinsh = self.customInfo.contactInfo;
        
        contact.fromeWhere = @"xinyongfen";
        
        [self.navigationController pushViewController:contact animated:YES];
    }
    else{
        
        [self showFailViewWithString:@"请先完善基本信息"];
    }
}
/** 点击授权按钮 */
- (void)clickShouquan:(UIButton *)button{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:SQXXZL];
    
    if ([self.customInfo.basicInfo isEqualToString:@"1"]) {
        AuthorizViewController * vc = [[AuthorizViewController alloc] init];
        
        vc.fromWhere = @"xinyongfen";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self showFailViewWithString:@"请先完善基本信息"];
    }
}


/** 3.创建导航栏左侧按钮 */
- (void)createLeftNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 40)];
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
     self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: negativeSpacer,leftItem, nil];
    
}
- (void)clickNavLeftButton:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  获取用户信息完成程度
 */
- (void)sendRequest{
    
    
    [MBProgressHUD showMessage:@"正在加载"];
    NSString * url = [NSString stringWithFormat:@"%@customInfo/infoStepAll",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            //[self hiddenLodJifToView:self.tableView];
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 1.解析返回信息*/
            LDBackInformation * model = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            if ([model.code isEqualToString:@"0"]) {
                
                /** 2.解析完善程度数据 */
                if (model.result != nil)
                {
                    self.customInfo = [WHCustomInfoInfoStepAll mj_objectWithKeyValues:model.result];
                    
                    /** 3.获取信用分*/
                    [self getCreditScore];
                }
                
            }
            else{
                [MBProgressHUD showError:model.message];
            }
        }
        
    }];
}
- (void)rightButtonClick{

    WHXinYongFenAgreementController * vc = [[WHXinYongFenAgreementController alloc]initWithURL:helpCenterUrl title:@"帮助中心"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createAddCreditViewWith:(float)chazhi newScore:(NSString *)newScore{
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];;
    
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.backgroundView];
    
    WHRotainView * rotainView = [WHRotainView view];
    rotainView.frame = CGRectMake((LDScreenWidth - 261)/2, LDScreenHeight, 261, 300);
    
    [self.backgroundView addSubview:rotainView];
    
    [UIView animateWithDuration:0.5 animations:^{
        rotainView.frame = CGRectMake((LDScreenWidth - 261)/2, (LDScreenHeight -300)/2, 261, 300);
    } completion:^(BOOL finished) {
        
        [NSThread sleepForTimeInterval:0.25];
        
        [rotainView imageRotain];
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(131, 245, 130, 55)];
        [rotainView addSubview:button];
        
        [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [rotainView.buzaitishiButton addTarget:self action:@selector(buzaitishi:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(190  , 170, 50, 18)];
        if (chazhi > 0) {
            label.text = [NSString stringWithFormat:@"+%.0f",chazhi];
        }
        else{
            label.text = [NSString stringWithFormat:@"%.0f",chazhi];
        }
        
        label.textColor = WHColorFromRGB(0xfb9b40);
        label.font = [UIFont systemFontOfSize:18];
        [rotainView addSubview:label];
        label.alpha = 0.0;
        [UIView animateWithDuration:0.7 animations:^{
            label.frame = CGRectMake(190, 70, 50, 18);
            label.alpha = 1.0;
        } completion:^(BOOL finished) {
            
             //self.topView.scoreLabel.text = newScore;
            
            self.scoreNum = [newScore integerValue];
            [self setScoreLabel];
        }];
    }];
}

- (void)cancel:(UIButton *)sender{
    [self.backgroundView removeFromSuperview];
}
- (void)buzaitishi:(UIButton *)sender{
    [self.backgroundView removeFromSuperview];
    //存储用户不在提示信用分动画
    [WHSaveAndReadInfomation saveXYFAnimation:@"1"];
}
/**
 * 获取信用分请求
 **/
#pragma mark -- 获取信用分
- (void)getCreditScore{
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/getCreditScore",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
             /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
        
        }
        else
        {
             NSLog(@"%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [MBProgressHUD hideHUD];
               
                /** 4.解析信用分  */
                if (backInfo.result != nil) {
                    HDScoreModel * scoreModel = [HDScoreModel mj_objectWithKeyValues:backInfo.result];
                    
                    if (scoreModel.creditScore == nil) {
                        scoreModel.creditScore = @"100";
                    }
                    
                    /** 5.获取旧的信用分 */
                    NSString * score = [WHSaveAndReadInfomation readXinYongFen];
                    NSArray * array = [score componentsSeparatedByString:@"-"];
                    score = array[0];
                    
                    /** 6.获取是否不在提示 */
                    NSString * prompt = [WHSaveAndReadInfomation readXYFAnimation];
                    /** 7.信用分差值 */
                    float difference = [scoreModel.creditScore floatValue] - [score floatValue];
                    
                    
                    
                    /** 8.差值不等于0并且提示，弹出信用分的窗 */
                    if (difference > 0 && ![prompt isEqualToString:@"1"]) {
                        
                        /** 9.创建弹窗  */
                        [self createAddCreditViewWith:difference newScore:scoreModel.creditScore];
                    }
                    else
                    {
                        //self.topView.scoreLabel.text = scoreModel.creditScore;
                        self.scoreNum = [scoreModel.creditScore integerValue];
                        [self setScoreLabel];
                    }
                    
                    /** 9.存储新的信用分*/
                    NSString * nesScore = [NSString stringWithFormat:@"%@-%@",scoreModel.creditScore,scoreModel.level];
                    [WHSaveAndReadInfomation saveXinYongFen:nesScore];
                }else{
                    //self.topView.scoreLabel.text = @"100";
                    
                }
  
            }else{
                
                /** 10.请求异常提示 */
                [MBProgressHUD showError:backInfo.message];
            }
        }
        
        /** 设置完善程度 */
        [self setBottomViewSubViews];
        
    }];
}

/** 更具请求的完善信息的程度设置icon */
- (void)setBottomViewSubViews{

    /** 实名信息 */
    if ([self.customInfo.basicInfo integerValue] == 1) {
        self.bottomView.icon1.image = [UIImage imageNamed:@"xinyongfen_shiming_wanshan"];
        self.bottomView.label1.textColor = WHColorFromRGB(0x4279d6);
        
        self.bottomView.topLabel.text = @"我的资料(已完善1/4)";
    }else{
        self.bottomView.icon1.image = [UIImage imageNamed:@"xinyongfen_shiming"];
        self.bottomView.label1.textColor = WHColorFromRGB(0x9fa8b7);
    }
    
    /** 身份信息 */
    if([self.customInfo.workInfo integerValue] == 1){
        self.bottomView.icon2.image = [UIImage imageNamed:@"xinyongfen_shenfen_wanshan"];
        self.bottomView.label2.textColor = WHColorFromRGB(0x4279d6);
        
        self.bottomView.topLabel.text = @"我的资料(已完善2/4)";
    }
    else{
        self.bottomView.icon2.image = [UIImage imageNamed:@"xinyongfen_shenfen"];
        self.bottomView.label2.textColor = WHColorFromRGB(0x9fa8b7);
    }

    /** 联系人信息 */
    if ([self.customInfo.contactInfo integerValue] == 1) {
        self.bottomView.icon3.image = [UIImage imageNamed:@"xinyongfen_lianxiren_wanshan"];
        self.bottomView.label3.textColor = WHColorFromRGB(0x4279d6);
        self.bottomView.topLabel.text = @"我的资料(已完善3/4)";
    }
    else{
        self.bottomView.icon3.image = [UIImage imageNamed:@"xinyongfen_lianxiren"];
        self.bottomView.label3.textColor = WHColorFromRGB(0x9fa8b7);
    }
    
    /** 授权信息 */
    if ([self.customInfo.authInfo integerValue] == 1) {
        self.bottomView.icon4.image = [UIImage imageNamed:@"xinyongfen_shouquan_wanshan"];
        self.bottomView.label4.textColor = WHColorFromRGB(0x4279d6);
        
        self.bottomView.topLabel.text = @"我的资料(已完善4/4)";
    }
    else{
        self.bottomView.icon4.image = [UIImage imageNamed:@"xinyongfen_shouquan"];
        self.bottomView.label4.textColor = WHColorFromRGB(0x9fa8b7);
    }
    
}

/** 信用分累加 */
- (void)setScoreLabel{
    
    double interval = 5/self.scoreNum;
    
    self.scoreTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(scoreAdd) userInfo:nil repeats:YES];
}
- (void)scoreAdd{
    
    NSInteger lableNumer = [self.topView.scoreLabel.text integerValue];
    
    if (lableNumer < self.scoreNum) {
        lableNumer += 10;
        self.topView.scoreLabel.text = [NSString stringWithFormat:@"%d",(int)lableNumer];
    }
    else{
        [self.scoreTimer invalidate];
    }
    
}
@end
