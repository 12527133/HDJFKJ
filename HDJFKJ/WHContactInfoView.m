

#import "WHContactInfoView.h"

@implementation WHContactInfoView

/** 销毁联系人View */
- (void)dealloc{

    LDLog(@"销毁联系人View");
}

- (void)createSubViews{

    
    self.backgroundColor = LDBackroundColor;
    
    
    /** 创建顶部提示内容的背景视图 */
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40*bili)];
    self.topView.backgroundColor = WHColorFromRGB(0xedf4ff);
    [self addSubview:self.topView];
    
    /** 创建定提示内容label */
    self.topLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, self.frame.size.width - 15*bili, 40*bili)];
    self.topLabel.backgroundColor = [UIColor clearColor];
    self.topLabel.textColor = WHColorFromRGB(0x4279d6);
    self.topLabel.text = @"已婚请优先填写配偶，未婚请优先填写父母";
    self.topLabel.textAlignment = NSTextAlignmentLeft;
    self.topLabel.font = [UIFont systemFontOfSize:13*bili];
    [self.topView addSubview:self.topLabel];
    
    /** 创建联系人1标题 */
    self.titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 56*bili, self.frame.size.width - 15*bili, 18*bili)];
    self.titleLabel1.backgroundColor = [UIColor clearColor];
    self.titleLabel1.textColor = WHColorFromRGB(0x9fa8b7);
    self.titleLabel1.text = @"第一联系人 ";
    self.titleLabel1.textAlignment = NSTextAlignmentLeft;
    self.titleLabel1.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.titleLabel1];
    
    /** 第一联系人内容背景视图 */
    self.relatioView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 82*bili, self.frame.size.width, 135*bili)];
    self.relatioView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.relatioView1];
    
    /** 第一联人姓名Label */
    UILabel * nameLanel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, 50*bili, 45*bili)];
    nameLanel1.backgroundColor = [UIColor clearColor];
    nameLanel1.textColor = WHColorFromRGB(0x292929);
    nameLanel1.text = @"姓名 ";
    nameLanel1.textAlignment = NSTextAlignmentLeft;
    nameLanel1.font = [UIFont systemFontOfSize:15*bili];
    [self.relatioView1 addSubview:nameLanel1];
    
    /** 第一联系人电话Label*/
    UILabel * phoneLable1 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 45*bili, 50*bili, 45*bili)];
    phoneLable1.backgroundColor = [UIColor clearColor];
    phoneLable1.textColor = WHColorFromRGB(0x292929);
    phoneLable1.text = @"手机号";
    phoneLable1.textAlignment = NSTextAlignmentLeft;
    phoneLable1.font = [UIFont systemFontOfSize:15*bili];
    [self.relatioView1 addSubview:phoneLable1];
    
    /** 第一联系人关系Label */
    UILabel * relationLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 90*bili, 50*bili, 45*bili)];
    relationLabel1.backgroundColor = [UIColor clearColor];
    relationLabel1.textColor = WHColorFromRGB(0x292929);
    relationLabel1.text = @"关系";
    relationLabel1.textAlignment = NSTextAlignmentLeft;
    relationLabel1.font = [UIFont systemFontOfSize:15*bili];
    [self.relatioView1 addSubview:relationLabel1];
    
    
    /** 第一联系人选择Button */
    
    UILabel * addLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 77*bili, 61*bili, 77*bili, 14*bili)];
    addLabel1.textAlignment = NSTextAlignmentCenter;
    addLabel1.text = @"选择联系人";
    addLabel1.font = [UIFont systemFontOfSize:10];
    addLabel1.textColor = WHColorFromRGB(0x4279d6);
    [self.relatioView1 addSubview:addLabel1];
    
    UIImageView * addImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(325*bili, 29*bili, 29*bili, 24*bili)];
    addImage1.image = [UIImage imageNamed:@"联系人"];
    [self.relatioView1 addSubview:addImage1];
    
    self.contactButton1 = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 77*bili, 0, 77*bili, 90*bili)];

    [self.relatioView1 addSubview:self.contactButton1];
    
    
    /** 第一联系人姓名textField */
    self.contactName1 = [[UITextField alloc]initWithFrame:CGRectMake(83*bili, 0, self.frame.size.width - 160*bili, 45*bili)];
    self.contactName1.textColor = WHColorFromRGB(0x292929);
    self.contactName1.font = [UIFont systemFontOfSize:15*bili];
    self.contactName1.textAlignment = NSTextAlignmentLeft;
    self.contactName1.placeholder = @"请输入姓名";
    [self.relatioView1 addSubview:self.contactName1];
    
    
    /** 第一联系人电话textField */
    self.phoneNumber1 = [[UITextField alloc]initWithFrame:CGRectMake(83*bili, 45*bili, self.frame.size.width - 160*bili, 45*bili)];
    self.phoneNumber1.textColor = WHColorFromRGB(0x888888);
    self.phoneNumber1.font = [UIFont systemFontOfSize:15*bili];
    self.phoneNumber1.textAlignment = NSTextAlignmentLeft;
    self.phoneNumber1.placeholder = @"请输入手机号";
    [self.relatioView1 addSubview:self.phoneNumber1];
    self.phoneNumber1.userInteractionEnabled = NO;
    
    /** 第一联系人关系textField */
    self.relationship1 = [[UITextField alloc]initWithFrame:CGRectMake(83*bili, 90*bili, self.frame.size.width - 160*bili, 45*bili)];
    self.relationship1.textColor = WHColorFromRGB(0x292929);
    self.relationship1.font = [UIFont systemFontOfSize:15*bili];
    self.relationship1.textAlignment = NSTextAlignmentLeft;
    self.relationship1.placeholder = @"选择关系";
    [self.relatioView1 addSubview:self.relationship1];
    
    /** 箭头iocn */
    UIImageView * arrowImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 23*bili, 105*bili, 8*bili, 14*bili)];
    arrowImageView1.image = [UIImage imageNamed:@"arrow_blue_8x14"];
    [self.relatioView1 addSubview:arrowImageView1];
    
    /** 第一联系人关系选择Button */
    self.relationButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 90*bili, self.frame.size.width, 45*bili)];
    [self.relatioView1 addSubview:self.relationButton1];
    
    
    
    /** 分割线 */
    
    
    UILabel * lineLabel12 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*bili, self.frame.size.width - 77*bili, 0.5)];
    lineLabel12.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView1 addSubview:lineLabel12];
    
    UILabel * lineLabel13 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90*bili, self.frame.size.width, 0.5)];
    lineLabel13.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView1 addSubview:lineLabel13];
    
    UILabel * lineLabel15 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 77*bili, 0, 0.5, 90*bili)];
    lineLabel15.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView1 addSubview:lineLabel15];
    
    
    /** 未填联系人 视图 */
    self.noRelationView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 90*bili)];
    self.noRelationView1.backgroundColor = [UIColor whiteColor];
    [self.relatioView1 addSubview:self.noRelationView1];
    
    UILabel * noAddLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 53*bili, self.noRelationView1.frame.size.width, 18*bili)];
    noAddLabel1.textAlignment = NSTextAlignmentCenter;
    noAddLabel1.text = @"选择联系人";
    noAddLabel1.font = [UIFont systemFontOfSize:13*bili];
    noAddLabel1.textColor = WHColorFromRGB(0x4279d6);
    [self.noRelationView1 addSubview:noAddLabel1];
    
    UIImageView * noAddImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(173*bili, 22*bili, 29*bili, 24*bili)];
    noAddImage1.image = [UIImage imageNamed:@"联系人"];
    [self.noRelationView1 addSubview:noAddImage1];
    
    self.noRelationButton1 = [[UIButton alloc]initWithFrame:self.noRelationView1.frame];
    [self.noRelationView1 addSubview:self.noRelationButton1];
    
    
    
    /** 上下分割线 */
    UILabel * lineLabel11 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    lineLabel11.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView1 addSubview:lineLabel11];
    
    
    UILabel * lineLabel14 = [[UILabel alloc]initWithFrame:CGRectMake(0, 135*bili, self.frame.size.width, 0.5)];
    lineLabel14.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView1 addSubview:lineLabel14];
    /**********************************************************************/
    
    
    /** 创建联系人2标题 */
    self.titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 234*bili, self.frame.size.width - 15*bili, 18*bili)];
    self.titleLabel2.backgroundColor = [UIColor clearColor];
    self.titleLabel2.textColor = WHColorFromRGB(0x9fa8b7);
    self.titleLabel2.text = @"第二联系人 ";
    self.titleLabel2.textAlignment = NSTextAlignmentLeft;
    self.titleLabel2.font = [UIFont systemFontOfSize:13*bili];
    [self addSubview:self.titleLabel2];
    
    /** 第2联系人内容背景视图 */
    self.relatioView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 260*bili, self.frame.size.width, 135*bili)];
    self.relatioView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.relatioView2];
    
    /** 第2联人姓名Label */
    UILabel * nameLanel2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 0, 50*bili, 45*bili)];
    nameLanel2.backgroundColor = [UIColor clearColor];
    nameLanel2.textColor = WHColorFromRGB(0x292929);
    nameLanel2.text = @"姓名 ";
    nameLanel2.textAlignment = NSTextAlignmentLeft;
    nameLanel2.font = [UIFont systemFontOfSize:15*bili];
    [self.relatioView2 addSubview:nameLanel2];
    
    /** 第2联系人电话Label*/
    UILabel * phoneLable2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 45*bili, 50*bili, 45*bili)];
    phoneLable2.backgroundColor = [UIColor clearColor];
    phoneLable2.textColor = WHColorFromRGB(0x292929);
    phoneLable2.text = @"手机号";
    phoneLable2.textAlignment = NSTextAlignmentLeft;
    phoneLable2.font = [UIFont systemFontOfSize:15*bili];
    [self.relatioView2 addSubview:phoneLable2];
    
    /** 第2联系人关系Label */
    UILabel * relationLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15*bili, 90*bili, 50*bili, 45*bili)];
    relationLabel2.backgroundColor = [UIColor clearColor];
    relationLabel2.textColor = WHColorFromRGB(0x292929);
    relationLabel2.text = @"关系";
    relationLabel2.textAlignment = NSTextAlignmentLeft;
    relationLabel2.font = [UIFont systemFontOfSize:15*bili];
    [self.relatioView2 addSubview:relationLabel2];
    
    
    /** 第2联系人选择Button */
    
    UILabel * addLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 77*bili, 61*bili, 77*bili, 14*bili)];
    addLabel2.textAlignment = NSTextAlignmentCenter;
    addLabel2.text = @"选择联系人";
    addLabel2.font = [UIFont systemFontOfSize:10];
    addLabel2.textColor = WHColorFromRGB(0x4279d6);
    [self.relatioView2 addSubview:addLabel2];
    
    UIImageView * addImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(325*bili, 29*bili, 29*bili, 24*bili)];
    addImage2.image = [UIImage imageNamed:@"联系人"];
    [self.relatioView2 addSubview:addImage2];
    
    
    self.contactButton2 = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 77*bili, 0, 77*bili, 90*bili)];
    [self.relatioView2 addSubview:self.contactButton2];
    
    
    /** 第2联系人姓名textField */
    self.contactName2 = [[UITextField alloc]initWithFrame:CGRectMake(83*bili, 0, self.frame.size.width - 160*bili, 45*bili)];
    self.contactName2.textColor = WHColorFromRGB(0x292929);
    self.contactName2.font = [UIFont systemFontOfSize:15*bili];
    self.contactName2.textAlignment = NSTextAlignmentLeft;
    self.contactName2.placeholder = @"请输入姓名";
    [self.relatioView2 addSubview:self.contactName2];
    
    
    /** 第2联系人电话textField */
    self.phoneNumber2 = [[UITextField alloc]initWithFrame:CGRectMake(83*bili, 45*bili, self.frame.size.width - 160*bili, 45*bili)];
    self.phoneNumber2.textColor = WHColorFromRGB(0x888888);
    self.phoneNumber2.font = [UIFont systemFontOfSize:15*bili];
    self.phoneNumber2.textAlignment = NSTextAlignmentLeft;
    self.phoneNumber2.placeholder = @"请输入手机号";
    [self.relatioView2 addSubview:self.phoneNumber2];
    self.phoneNumber2.userInteractionEnabled = NO;
    
    /** 第2联系人关系textField */
    self.relationship2 = [[UITextField alloc]initWithFrame:CGRectMake(83*bili, 90*bili, self.frame.size.width - 160*bili, 45*bili)];
    self.relationship2.textColor = WHColorFromRGB(0x292929);
    self.relationship2.font = [UIFont systemFontOfSize:15*bili];
    self.relationship2.textAlignment = NSTextAlignmentLeft;
    self.relationship2.placeholder = @"选择关系";
    [self.relatioView2 addSubview:self.relationship2];
    
    /** 箭头iocn */
    UIImageView * arrowImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 23*bili, 105*bili, 8*bili, 14*bili)];
    arrowImageView2.image = [UIImage imageNamed:@"arrow_blue_8x14"];
    [self.relatioView2 addSubview:arrowImageView2];
    
    /** 第一联系人关系选择Button */
    self.relationButton2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 90*bili, self.frame.size.width, 45*bili)];
    [self.relatioView2 addSubview:self.relationButton2];
    
    
    /** 分割线 */
    UILabel * lineLabel22 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45*bili, self.frame.size.width - 77*bili, 0.5)];
    lineLabel22.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView2 addSubview:lineLabel22];
    
    UILabel * lineLabel23 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90*bili, self.frame.size.width, 0.5)];
    lineLabel23.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView2 addSubview:lineLabel23];
    
   
    
    UILabel * lineLabel25 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 77*bili, 0, 0.5, 90*bili)];
    lineLabel25.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView2 addSubview:lineLabel25];
    
    
    /** 无联系人视图 */
    self.noRelationView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 90*bili)];
    self.noRelationView2.backgroundColor = [UIColor whiteColor];
    [self.relatioView2 addSubview:self.noRelationView2];
    
    UILabel * noAddLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 53*bili, self.noRelationView1.frame.size.width, 18*bili)];
    noAddLabel2.textAlignment = NSTextAlignmentCenter;
    noAddLabel2.text = @"选择联系人";
    noAddLabel2.font = [UIFont systemFontOfSize:13*bili];
    noAddLabel2.textColor = WHColorFromRGB(0x4279d6);
    [self.noRelationView2 addSubview:noAddLabel2];
    
    UIImageView * noAddImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(173*bili, 22*bili, 29*bili, 24*bili)];
    noAddImage2.image = [UIImage imageNamed:@"联系人"];
    [self.noRelationView2 addSubview:noAddImage2];
    
    self.noRelationButton2 = [[UIButton alloc]initWithFrame:self.noRelationView2.frame];
    [self.noRelationView2 addSubview:self.noRelationButton2];
    
    /**上下分割线  */
    UILabel * lineLabel21 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    lineLabel21.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView2 addSubview:lineLabel21];
    
    UILabel * lineLabel24 = [[UILabel alloc]initWithFrame:CGRectMake(0, 135*bili, self.frame.size.width, 0.5)];
    lineLabel24.backgroundColor = WHColorFromRGB(0xdddddd);
    [self.relatioView2 addSubview:lineLabel24];
    
    
    
    
    /** 提交按钮 */
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(16*bili, 449*bili, LDScreenWidth- 32*bili, 50*bili)];
    [self addSubview:self.nextButton];
    self.nextButton.backgroundColor = WHColorFromRGB(0x4279d6);
    [self.nextButton setTitle:@"提交" forState:UIControlStateNormal];
    self.nextButton.layer.cornerRadius = 5.0;
    self.nextButton.layer.borderWidth = 0.0;
    
    
    /** 信息真实提示 */
    UIButton * checkOrderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 400*bili, self.frame.size.width, 45*bili)];
    [checkOrderButton setImage:[UIImage imageNamed:@"check_yiwen"] forState:UIControlStateNormal];
    [checkOrderButton setTitle:@" 请您确保联系人的姓名、手机号真实有效" forState:UIControlStateNormal];
    [checkOrderButton setTitleColor:WHColorFromRGB(0x9fa8b7) forState:UIControlStateNormal];
    checkOrderButton.userInteractionEnabled = NO;
    checkOrderButton.titleLabel.font = [UIFont systemFontOfSize:12*bili];
    [self addSubview:checkOrderButton];
    
    
}

















@end
