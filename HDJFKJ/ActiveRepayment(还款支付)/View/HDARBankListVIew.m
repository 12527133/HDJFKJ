

#import "HDARBankListVIew.h"
@interface HDARBankListVIew()<UITableViewDelegate,UITableViewDataSource>


@end
@implementation HDARBankListVIew

- (void)dealloc{

    LDLog(@"销毁支付选择银行卡半窗");
}




/** 创建子视图 */
- (void)createSubView{

    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 8.0;
    self.layer.borderWidth = 0.0;
    
    
    /** 标题Label */
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*bili, self.frame.size.width, 24*bili)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = WHColorFromRGB(0x3e3e3e);
    titleLabel.text = @"选择银行卡";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17*bili];
    [self addSubview:titleLabel];
    
    /** 副标题 Label */
    UILabel * smallLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38*bili, self.frame.size.width, 14*bili)];
    smallLabel.backgroundColor = [UIColor clearColor];
    smallLabel.textColor = WHColorFromRGB(0x4279d6);
    smallLabel.text = @"选择的银行卡将作为主动还款卡使用";
    smallLabel.textAlignment = NSTextAlignmentCenter;
    smallLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:smallLabel];
    
    /** 创建关闭按钮 */
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 59*bili, 59*bili)];
    [self.cancelButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15*bili];
    [self addSubview:self.cancelButton];
    
    /** 创建分割线 */
    UILabel * lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 59*bili-0.5, self.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = WHColorFromRGB(0xdddddd);
    [self addSubview:lineLabel1];
    
    
    /** 创建银行卡tableView */
    self.bankTableView = [[UITableView alloc]init];
    
    if (self.bankCardArray.count > 3) {
        self.bankTableView.frame = CGRectMake(0, 59*bili, self.frame.size.width, 201*bili);
        self.bankTableView.scrollEnabled = YES;
    }
    else{
        self.bankTableView.frame = CGRectMake(0, 59*bili, self.frame.size.width, 67*bili*self.bankCardArray.count);
        self.bankTableView.scrollEnabled = NO;
    }
    self.bankTableView.backgroundColor = [UIColor clearColor];
    self.bankTableView.delegate = self;
    self.bankTableView.dataSource = self;
    self.bankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.bankTableView];
    
    
    
    
    
    /** 创建选择新银行卡北京视图  */
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 260*bili, self.frame.size.width, 60*bili)];
    if (self.bankCardArray.count > 3) {
        bgView.frame = CGRectMake(0, 260*bili, self.frame.size.width, 60*bili);
    }
    else{
        bgView.frame = CGRectMake(0, 59*bili + 67*bili*self.bankCardArray.count, self.frame.size.width, 60*bili);
    }
    
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    /** 新银行卡label */
    UILabel * bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(19*bili, 0, 150*bili, bgView.frame.size.height)];
    bankLabel.backgroundColor = [UIColor clearColor];
    bankLabel.textColor = WHColorFromRGB(0x252525);
    bankLabel.text = @"选择新的银行卡";
    bankLabel.textAlignment = NSTextAlignmentCenter;
    bankLabel.font = [UIFont systemFontOfSize:15*bili];
    [bgView addSubview:bankLabel];
    
    /** 创建箭头 */
    /** 右侧蓝色箭头 */
    UIImageView * arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.frame.size.width - 23*bili, (bgView.frame.size.height - 14*bili)/2.0, 8*bili, 14*bili)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_blue_8x14"];
    [bgView addSubview:arrowImageView];
    
    /** 创建横线 */
    UILabel * lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0,bgView.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    lineLabel2.backgroundColor = WHColorFromRGB(0xdddddd);
    [bgView addSubview:lineLabel2];
    
    
    /** 创建选新银行卡按钮 */
    self.bankButton = [[UIButton alloc]initWithFrame:CGRectMake( 0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    [bgView addSubview:self.bankButton];
   
}

#pragma mark ---  tableVIew的协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bankCardArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 67*bili;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDBankNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if(cell == nil)
    {
        cell = [[HDBankNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.size = CGSizeMake(LDScreenWidth, 67*bili);
        
        [cell createSubViews];
        
        
        /** 创建横线Label */
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 67*bili - 0.5, LDScreenWidth, 0.5)];
        lineLabel.backgroundColor = WHColorFromRGB(0xdddddd);
        [cell addSubview:lineLabel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    LDHaveCardListModel * listModel = self.bankCardArray[indexPath.row];
    
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:listModel.pic] placeholderImage:[UIImage imageNamed:@"wode_yinhangka_2.0.4"]];
    [cell.iconImage setContentMode:UIViewContentModeScaleAspectFit];
    cell.bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",listModel.bank,listModel.cardtailno];
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LDHaveCardListModel * bankList = self.bankCardArray[indexPath.row];
    
    if ([bankList.jdSignFlag isEqualToString: @"0"]) {
        
        
        
        NSString * message = [NSString stringWithFormat:@"是否将尾号%@银行卡同事作为主动还款卡使用",bankList.cardtailno];
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alertView.tag = indexPath.row;
        [alertView show];
        
    }else{

        _selectBank(bankList);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        LDHaveCardListModel * bankList = self.bankCardArray[alertView.tag];
        _selectBank(bankList);
    }

}

@end
