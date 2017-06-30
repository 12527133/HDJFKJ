

#import "HDHalfBgView.h"
#import "PrefixHeader.pch"
#import "LDHaveCardListModel.h"


#import "HDHalfbanKCell.h"
#import "WHPasswordView.h"
#import "TZMD5.h"

@interface HDHalfBgView()<UITableViewDelegate,UITableViewDataSource>





/**  支付密码  */
@property (nonatomic, strong) UIView * passwordBgView;

/**  密码窗   */
@property (nonatomic, strong) WHPasswordView * passwordView;

@end
@implementation HDHalfBgView

/**  创建背景视图 */
+ (HDHalfBgView *)createHDHalfBgViewWithView:(UIView *)view{
    return [[self alloc] initWithView:view];
}

/**  重写init方法*/
- (instancetype)initWithView:(UIView *)view{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, LDScreenWidth, LDScreenHeight);
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];

        [view addSubview:self];
    }
    
    return self;
}



/** 延迟加载确认分期试图 */
- (HDComfirmComitView *)comfimView{
    if (!_comfimView) {
        _comfimView = [HDComfirmComitView view];
        _comfimView.frame = CGRectMake(0, LDScreenHeight, LDScreenWidth, 400);
        _comfimView.layer.cornerRadius = 8.0;
        _comfimView.layer.borderWidth = 0;
        _comfimView.layer.borderColor = [[UIColor clearColor]  CGColor];
        [_comfimView.closeButton addTarget:self action:@selector(clickColseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_comfimView.chooseCardBank addTarget:self action:@selector(clickChooseCardBank:) forControlEvents:UIControlEventTouchUpInside];
        [_comfimView.confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _comfimView;
}

/** 延迟加载选择银行卡试图*/
- (HDChooseBankView *)chooseBankView{
    if (!_chooseBankView) {
        
       
        _chooseBankView = [HDChooseBankView view];
        _chooseBankView.frame = CGRectMake(LDScreenWidth, LDScreenHeight  - 400, LDScreenWidth, 400);
        _chooseBankView.layer.cornerRadius = 8.0;
        _chooseBankView.layer.borderWidth = 0;
        _chooseBankView.layer.borderColor = [[UIColor clearColor]  CGColor];
        _chooseBankView.tableView.delegate = self;
        _chooseBankView.tableView.dataSource = self;
        _chooseBankView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_chooseBankView.closeBankButton addTarget:self action:@selector(clickBankButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _chooseBankView;
}





/** 添加确认分视图 */
- (void)addComfimComiteView{
    [self addSubview:self.comfimView];
    
    if (self.bankCardArray.count > 0) {
        LDHaveCardListModel * bankCard = self.bankCardArray[0];
        self.comfimView.bankCardLabel.text = [NSString stringWithFormat:@"%@(%@)",bankCard.bank,bankCard.cardtailno];
        self.bankCardID = bankCard.id;
    }
    self.comfimView.businessNameLabel.text = [HDSubmitOrder shardSubmitOrder].goodsName;
    
    if ([LDUserInformation sharedInstance].phoneNumber != nil) {
        NSMutableString *phone = [[NSMutableString alloc] initWithString:[LDUserInformation sharedInstance].phoneNumber];
        [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.comfimView.phoneNmuLabel.text = phone;
    }
    
    self.comfimView.caseLabel.text = [HDSubmitOrder shardSubmitOrder].caseDetail;
    
    [UIView animateWithDuration:0.35f animations:^{
        self.comfimView.frame = CGRectMake(0, LDScreenHeight - self.comfimView.frame.size.height, self.comfimView.frame.size.width, self.comfimView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];

}
/** 关闭确认分期按钮 */
- (void)clickColseButton:(UIButton *)sender{
    [self closeComfirmComiteView];
}
- (void)closeComfirmComiteView{
    [UIView animateWithDuration:0.35 animations:^{
        self.comfimView.frame = CGRectMake(0, LDScreenHeight, LDScreenWidth, 400);
    } completion:^(BOOL finished) {
        [self.comfimView removeFromSuperview];
        [self removeFromSuperview];
        
        
        
    }];
}

/** 确认分期页，选择银行卡界面 */
- (void)clickChooseCardBank:(UIButton *)sender{
    
    [self addChooseBankView];
    
    [self.chooseBankView.tableView reloadData];
}

/** 确认分期页，确认提交按钮  */
- (void)clickConfirmButton:(UIButton *)sender{
    
    if (self.bankCardID == nil) {
        [self showErrorWithString:@"请先选中银行卡"];
    }
    else{
        
        /** 验证成功发送block */
        self.successBlock(self.bankCardID);
        
        [self closeComfirmComiteView];
    }
    
    
}

/** 选择银行卡相应方法*/
- (void)addChooseBankView{
    [self addSubview:self.chooseBankView];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.chooseBankView.frame = CGRectMake(0, LDScreenHeight  - 400, LDScreenWidth, 400);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)clickBankButton:(UIButton *)sender{
    [self closeChooseBankView];
}
- (void)closeChooseBankView{
    [UIView animateWithDuration:0.35 animations:^{
        self.chooseBankView.frame = CGRectMake(LDScreenWidth, LDScreenHeight  - 400, LDScreenWidth, 400);
    } completion:^(BOOL finished) {
        [self.chooseBankView removeFromSuperview];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bankCardArray.count + 1;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDHalfbanKCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HDHalfbanKCell" owner:nil options:nil]lastObject];
    }
    if (indexPath.row != self.bankCardArray.count) {
        
        
        LDHaveCardListModel * bankCard = self.bankCardArray[indexPath.row];
        
        cell.leftLabel.text = [NSString stringWithFormat:@"%@(%@)",bankCard.bank,bankCard.cardtailno];
        
        if (!self.bankCardID) {
            if (indexPath.row == 0) {
                cell.rightImageView.hidden = NO;
                self.bankCardID = bankCard.id;
            }
            else{
                cell.rightImageView.hidden = YES;
            }
        }else{
        
            if ([bankCard.id isEqualToString:self.bankCardID]) {
                cell.rightImageView.hidden = NO;
            }
            else{
                cell.rightImageView.hidden = YES;
            }
        }

    }else{
        
        cell.rightImageView.hidden = YES;
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth - 26, 22, 6, 11)];
        imageView.image = [UIImage imageNamed:@"返回"];
        [cell addSubview:imageView];
        cell.leftLabel.text = @"使用新银行卡";
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.bankCardArray.count) {
        
        LDHaveCardListModel * bankCard = self.bankCardArray[indexPath.row];
        self.bankCardID = bankCard.id;
        self.comfimView.bankCardLabel.text = [NSString stringWithFormat:@"%@(%@)",bankCard.bank,bankCard.cardtailno];
        
        [self closeChooseBankView];
        
    }
    else{
        
        _addbankCard();
    }

}
- (void)reloadAddBankTableViewWith:(NSArray *)bankCardArr{

    self.bankCardArray = bankCardArr;
    [self.chooseBankView.tableView reloadData];
    
    [self.chooseBankView.tableView scrollsToTop];

}
/** 添加支付密码界面 */
- (void)addPasswordBgView{
    
    
    _passwordBgView= [[UIView alloc]initWithFrame:CGRectMake(LDScreenWidth, LDScreenHeight - 400, LDScreenWidth, 410)];
    _passwordBgView.backgroundColor = WHColorFromRGB(0xf0f0f0);
    _passwordBgView.layer.cornerRadius = 8.0f;
    _passwordBgView.layer.borderColor = [[UIColor clearColor] CGColor];
    _passwordBgView.layer.borderWidth = 0;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 50)];
    titleLabel.text = @"输入支付密码";
    titleLabel.textColor = WHColorFromRGB(0x2b2b2b);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_passwordBgView addSubview:titleLabel];
    
    
    UIButton * cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [cancelButton setImage:[UIImage imageNamed:@"shenhe_tanchuang_guanbi"] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:@"shenhe_tanchuang_guanbi"] forState:UIControlStateHighlighted];
    [_passwordBgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(removePasswordView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, LDScreenWidth, 0.5)];
    lineView.backgroundColor = WHColorFromRGB(0xd9d9d9);
    [_passwordBgView addSubview:lineView];
    
    _passwordView= [[WHPasswordView alloc]initWithFrame:CGRectMake((LDScreenWidth-270*LDScreenWidth/375)/2, 80, 270*LDScreenWidth/375, 270*LDScreenWidth/375/6)];
    __weak typeof(self) weakSelf = self;
    _passwordView.complationBlock = ^(NSString * password){
        
        if (password.length == 6) {
            //[weakSelf closePasswordView];
            
            [weakSelf sendZhifuPassword:password];
            
            
            
        }
        
    };
    [_passwordBgView addSubview:_passwordView];

    [self addSubview:self.passwordBgView];
    
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.passwordBgView.frame = CGRectMake(0, LDScreenHeight - 400, LDScreenWidth, 410);
        
    } completion:^(BOOL finished) {
        [self.passwordView.textField becomeFirstResponder];
    }];

}

/** 关闭支付密码界面 */
- (void)removePasswordView:(UIButton *)sender{
    [self.passwordView.textField resignFirstResponder];
    [self closePasswordView:nil];
}
- (void)closePasswordView:(NSString *)password{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.passwordBgView.frame = CGRectMake(LDScreenWidth, LDScreenHeight - 400, LDScreenWidth, 410);
        
    } completion:^(BOOL finished) {
        [self.passwordBgView removeFromSuperview];
        
        if (password != nil) {
            /** 4.关闭弹窗  */
            [self closeComfirmComiteView];
        }
        
    }];

}
/**
 * 发送支付密码
 **/
- (void)sendZhifuPassword:(NSString *)password{
    [self showMessageWithString:@"正在验证"];
    
    NSString * str = [NSString stringWithFormat:@"%@order/pay",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:[TZMD5 md5:password] forKey:@"payPassword"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showErrorWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self closePasswordView:password];
                
                /** 验证成功发送block */
                self.successBlock(self.bankCardID);
                
                
                
            }else{
                
                /** 5.请求异常提示  */
                [self showErrorWithString:backInfo.message];
            }
        }
    }];
    
}


/** 错误提示 */
- (void)showErrorWithString:(NSString *)error{
    
    [MBProgressHUD showError:error afterDelay:2.0];
}

/** 加载提示 */
- (void)showMessageWithString:(NSString *)message{
    [MBProgressHUD showMessage:message];
}

/** 成功提示 */
- (void)showSuccessWithString:(NSString *)success{
    [MBProgressHUD showSuccess:success];
}
/** 取消加载 */
- (void)hiddenJiaZai{
    [MBProgressHUD hideHUD];
}
@end
