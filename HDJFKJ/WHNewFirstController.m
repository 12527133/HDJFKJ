

#import "WHNewFirstController.h"
#import "LDSignInViewController.h"
#import "WHUserLoginModel.h"
#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LDBusnessController.h"
#import "LDTaoBaoVC.h"
#import "WHImageSaveAndLoad.h"
#import "LDThirdViewController.h"
#import "CashLoanController.h"
#import "WHWorkViewController.h"
#import "LDContactInformationViewController.h"
#import "LDNavgationVController.h"
#import "LDBaseInformationTableViewController.h"
#import "AuthorizViewController.h"
#import "WHRightButtonView.h"
#import "WHMessageController.h"
#import "LDPostIDCard.h"
#import "WHCashAndSaomaView.h"
#import "MJRefresh.h"
#import "LDMySore.h"
#import "WHQROrderController.h"
#import "WHQRInvalidController.h"
#import "HDFexOrderDetail.h"
#import "WHQROrderModel.h"
#import "WHSaveAndReadInfomation.h"
#import "HDMaterialOperate.h"
#import "LDNewOrderDetailVC.h"
#import "WHWithOutOrderController.h"
#import "HDFirstNoLoginCell.h"
#import "HDFirstNoLoginTopCell.h"
#import "HDFirstPageCheckCell.h"
#import "HDFirstPageOrderCell.h"
#import "HDFirstPageScoreCell.h"
#import "HDFirstPageModel.h"
#import "HDFirstPageBanner.h"

#import "HDReviewPictureController.h"

/** 信用分模型 */
#import "HDScoreModel.h"
/** 租房界面  */
#import "HDZuFangOrderController.h"
/** Banner跳转  */
#import "WHXinYongFenAgreementController.h"
#import "WHCustomInfoInfoStepAll.h"
#import "HDNSNotificModel.h"
#import "HDARZaixianzhifuController.h"
#import "HDOrderRepays.h"


@interface WHNewFirstController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) WHUserLoginModel * user;
//信息完善程度码值
@property (nonatomic, assign) NSInteger currentCode;

//首页模型
@property (nonatomic, strong)  HDFirstPageModel * firstPageModel;
//告诉下一页是从哪跳过去的
@property (nonatomic, strong) NSString * fromWhere;

// 导航栏右侧按钮视图
@property (nonatomic, strong) WHRightButtonView * rightTitleButtonView;

//现金贷，扫码视图
@property (nonatomic, strong) WHCashAndSaomaView * cashAndSaoma;
//self.view上覆盖的子视图
@property (nonatomic, strong) UITableView * coverView;

//子试图背景色变色的定时器
@property (nonatomic, weak) NSTimer * timer;

/** 是否授权通讯录 */
@property (nonatomic, assign) BOOL isaAddressBook;

/** Banner轮播ScrollView*/
@property (nonatomic, strong) UIScrollView * bannerScroll;

/** 广告轮换的位置 */
@property (nonatomic, assign) NSInteger indexAdver;
/** 轮换广告是顺时针个，还是逆时针 */
@property (nonatomic, assign) BOOL isShunshizhen;
/** banner轮换的计时器  */
@property (nonatomic, strong) NSTimer * bannerTimer;

/** 扫码结果*/
@property (nonatomic, strong) NSMutableDictionary * dict;

@end

@implementation WHNewFirstController

- (NSMutableDictionary *)dict{
    
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    /** 一级界面取消侧滑返回  */
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            
        }
    }
}

- (void)setNavgationBackground{

    
    /** 设置状态栏的前景色为白色*/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    /** 设置导航背景图 */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /** 设置导航栏背景  */
    [self setNavgationBackground];
    
    if ([LDUserInformation sharedInstance].token != nil && [LDUserInformation sharedInstance].UserId != nil) {
        self.coverView.scrollEnabled = YES;
    }
    //2、获取首页数据
    [self firstPageRequest];
    
    /** 3.推送消息的处理 */
    [self operateNSNotificationInfo];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /** 设置二级界面导航栏背景色为白色 */
    [self setNavgationBackgroundWight];
    
    /** 非一级界面添加侧滑功能 */
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

/** 设置二级界面导航栏背景色为白色 */
- (void)setNavgationBackgroundWight{
    
    /** 设置状态栏的前景色为黑色 */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    /** 设置导航栏字体为白色 */
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHColorFromRGB(0x323232)}];
    
    /** 设置导航背景图 */
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_3.0"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_white_3.0"] forBarMetrics:UIBarMetricsDefault];
    
    /** 是否显示下划线 */
    self.navigationController.navigationBar.shadowImage = nil;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self noMustGetAddressBook];
    
    //1.创建侧导航栏按钮
    [self createRightNavButton];
    [self createLeftNavButton];
    
    //2.创建子试图
    [self createCoverView];
    
    [HDMaterialOperate deleteGroup];
    
    
    
}

/** 有推消息 推出界面吗  */
- (void)operateNSNotificationInfo{
    
    
    
    
    NSString * infoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"noticInfo.data"];
    
    id userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:infoPath];
    
    if (userInfo != nil) {
        
        
        /** 解析推送内容 */
        HDNSNotificModel * noticModel = [HDNSNotificModel mj_objectWithKeyValues:userInfo];
        
        [[HDNSNotificModel sharedInstance] setApplyId:noticModel.applyId];
        [[HDNSNotificModel sharedInstance] setPushType:noticModel.pushType];
        
        
        if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
            LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
            
            signVC.fromWhere = @"tongzhi";
            LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:signVC];
            
            [self.navigationController presentViewController:nav animated:NO completion:^{
                
            }];
        }
        else{
            
            if ([[HDNSNotificModel sharedInstance].pushType isEqualToString:@"apply"]) {
                LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
                orderDetail.applyId = noticModel.applyId;
                [self.navigationController pushViewController:orderDetail animated:NO];
            }
            if ([[HDNSNotificModel sharedInstance].pushType isEqualToString:@"bill"]){
                LDThirdViewController * vc = [[LDThirdViewController alloc]init];
                [self.navigationController pushViewController:vc animated:NO];
                
            }
            
            /** 删除通知归档数据 */
            NSFileManager *defaultManager = [NSFileManager defaultManager];
            if ([defaultManager isDeletableFileAtPath:infoPath]) {
                [defaultManager removeItemAtPath:infoPath error:nil];
            }
            
            
            
            
        }
        
        
    }
    
}


- (void)mustGetAddressBook{
    if (!self.isaAddressBook) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未授权访问通讯录\n通讯录是贷款征信的重要依据，授权访问通讯录方式：[设置]->[隐私]->[通信录]中打开通信录访问" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
    }
    
    else{
        
        self.user = [WHUserLoginModel createuserInfoModel];
        if (self.user.id != nil && self.user.token != nil) {
            //1、给单利赋值
            [[LDUserInformation sharedInstance] setPhoneNumber:self.user.phone];
            [[LDUserInformation sharedInstance] setUserId:self.user.id];
            [[LDUserInformation sharedInstance] setToken:self.user.token];
            [[LDUserInformation sharedInstance] setUserName:self.user.idName];
            //2、获取信用分、还款计划、消息
            
            
        }
        
    }
    
    
}
- (void)noMustGetAddressBook{
    self.user = [WHUserLoginModel createuserInfoModel];
    if (self.user.id != nil && self.user.token != nil) {
        //1、给单利赋值
        [[LDUserInformation sharedInstance] setPhoneNumber:self.user.phone];
        [[LDUserInformation sharedInstance] setUserId:self.user.id];
        [[LDUserInformation sharedInstance] setToken:self.user.token];
        [[LDUserInformation sharedInstance] setUserName:self.user.idName];
        
        
    }
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:QDAPP];
    
}


//2.0.3之后修改首页之后的视图
- (void)createCoverView{
    
    
    //1.创建背景视图
    self.coverView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, LDScreenHeight - 49 - 64)];
    
    self.coverView.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    self.coverView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.coverView.showsVerticalScrollIndicator = NO;
    
    if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
        if (Is_Iphone4) {
            self.coverView.scrollEnabled = YES;
        }
        else{
            self.coverView.scrollEnabled = NO;
        }
        
    }
    
    self.coverView.dataSource = self;
    self.coverView.delegate = self;
    [self registerCell];
    
    self.coverView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefersh)];
    
    
    self.coverView.mj_header.automaticallyChangeAlpha = YES;
    [self.view addSubview:self.coverView];
}

static NSString * const nologin = @"nologin";
static NSString * const nologinTop = @"nologinTop";
static NSString * const checkCell = @"checkCell";
static NSString * const orderCell = @"orderCell";
static NSString * const scoreCell = @"scoreCell";
/** 注册tableView的cell */
- (void)registerCell{
    
    [self.coverView registerNib:[UINib nibWithNibName:NSStringFromClass([HDFirstNoLoginCell  class]) bundle:nil] forCellReuseIdentifier:nologin];
    
    [self.coverView registerNib:[UINib nibWithNibName:NSStringFromClass([HDFirstNoLoginTopCell  class]) bundle:nil] forCellReuseIdentifier:nologinTop];
    
    [self.coverView registerNib:[UINib nibWithNibName:NSStringFromClass([HDFirstPageCheckCell  class]) bundle:nil] forCellReuseIdentifier:checkCell];
    
    [self.coverView registerNib:[UINib nibWithNibName:NSStringFromClass([HDFirstPageOrderCell  class]) bundle:nil] forCellReuseIdentifier:orderCell];
    
    [self.coverView registerNib:[UINib nibWithNibName:NSStringFromClass([HDFirstPageScoreCell  class]) bundle:nil] forCellReuseIdentifier:scoreCell];
    
}

//下拉刷新
- (void)headerRefersh{
    
    /** 请求首页数据  */
    [self firstPageRequest];
    
}
#pragma mark -- tableViewDatasource,delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    /** 未登录情况下 返回2个section  */
    if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil) {
        return 2;
    }
    /** 登录情况下 */
    else{
        
        /** 无订单且无账单 返回2个section */
        if ([self.firstPageModel.debtInfo.repaymentAmt floatValue] == 0 && self.firstPageModel.orderInfo.applyId == nil) {
            return 2;
        }
        /** 有订单但无账单  返回3个section */
        else if ([self.firstPageModel.debtInfo.repaymentAmt floatValue] == 0 && self.firstPageModel.orderInfo.applyId != nil){
            return 3;
        }
        /** 有订单并且有账单 */
        else{
            
            return 4;
        }
        
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /** 第一个section 返回2行 */
    if (section == 0) {
        return 2;
    }
    /** 第二个section  */
    else if (section == 1){
        
        /** 未登录，登录后无账单且户订单，返回2行 ，有订单 返回1行 */
        if (self.firstPageModel.orderInfo.applyId == nil  && [self.firstPageModel.debtInfo.repaymentAmt floatValue] == 0) {
            return 2;
        }
        else{
            return 1;
        }
    }
    /** 第三、四个section 返回1行*/
    else {
        return 1;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    /** 第一个Section 的header 高度为0；其他的高度为8.0  */
    switch (section) {
        case 0:
            return 0;
            break;
        default:
            return 8.0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /** 第一个section ，第一行高度为100，第二行高度为90 */
    if (indexPath.section == 0) {
        return indexPath.row == 0 ? 100*bili : 90*bili;
    }
    /** 第二个section */
    else if (indexPath.section == 1){
        /** 未登录 情况 第一行高为 80 第二行高度为 更具屏幕适配 */
        if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil) {
            if (indexPath.row == 0) {
                return 80.0;
            }
            else{
                /** 480的苹果高度，cell高度是定值*/
                if (Is_Iphone4 || Is_Iphone5) {
                    return 204.0;
                }
                /** 屏幕高度大于480 cell根据屏幕高度自动布局  */
                else{
                    return LDScreenHeight - 114 - 190 * LDScreenWidth/375 - 168;
                }
            }
        }
        else{
            
            if (indexPath.row == 0) {
                return 160.0;
            }
            else{
                if (Is_Iphone4 || Is_Iphone5) {
                    return 204.0;
                }
                /** 屏幕高度大于480 cell根据屏幕高度自动布局  */
                else{
                    return LDScreenHeight - 114 - 190 * LDScreenWidth/375 - 168;
                }
            }
        }
    }
    else if (indexPath.section == 2){
        if (self.firstPageModel.orderInfo.applyId != nil && [self.firstPageModel.debtInfo.repaymentAmt floatValue] == 0) {
            return 180.0;
        }
        else{
            
            return 160.0;
        }
    }
    else{
        return 180.0;
    }
}
/** Banner轮播方法*/
-(void)changeCurrentView
{
    if (self.indexAdver == self.firstPageModel.banner.count - 1) {
        self.isShunshizhen = NO;
    }
    
    if (self.indexAdver == 0) {
        self.isShunshizhen = YES;
    }
    
    [UIView animateWithDuration:0.35f animations:^{
        
        self.bannerScroll.contentOffset = CGPointMake(LDScreenWidth * (float)_indexAdver, 0);
        
        if (self.isShunshizhen) {
            _indexAdver += 1;
        }
        else{
            _indexAdver -= 1;
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]init];
        }
        
        /** 视图顶部的Banner */
        if (indexPath.row == 0) {
            
            self.bannerScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 100 * LDScreenWidth/375)];
            [cell addSubview:self.bannerScroll];
            
            self.bannerScroll.pagingEnabled = YES;
            self.bannerScroll.showsHorizontalScrollIndicator = NO;
            self.bannerScroll.showsVerticalScrollIndicator = NO;
            self.bannerScroll.directionalLockEnabled = YES;
            self.bannerScroll.bounces = NO;
            self.bannerScroll.delegate = self;
            
            if (self.firstPageModel.banner.count == 0) {
                
                
                UIImage * bannerImage = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"banner0.png"]];
                if (bannerImage == nil) {
                    bannerImage = [UIImage imageNamed:@"banner_3.0"];
                }
                
                UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, LDScreenWidth, 100 * LDScreenWidth/375)];
                topImageView.image = bannerImage;
                [self.bannerScroll addSubview:topImageView];
                self.bannerScroll.contentSize = CGSizeMake(LDScreenWidth, self.bannerScroll.frame.size.height);
                
                
                UIButton * button = [[UIButton alloc]initWithFrame:topImageView.frame];
                [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                
                [button addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.bannerScroll addSubview:button];
                
                
                
            }
            else {
                
                self.bannerScroll.contentSize = CGSizeMake(LDScreenWidth * self.firstPageModel.banner.count, self.bannerScroll.frame.size.height);
                
                for (int i = 0; i < self.firstPageModel.banner.count; i++) {
                    
                    UIImage * bannerImage = [WHImageSaveAndLoad loadImage:[NSString stringWithFormat:@"banner%d.png",i]];
                    if (bannerImage == nil) {
                        bannerImage = [UIImage imageNamed:@"banner_zhanwei"];
                    }
                    
                    
                    
                    HDFirstPageBanner * banner = self.firstPageModel.banner[i];
                    UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LDScreenWidth * i, 0, LDScreenWidth, 100 * LDScreenWidth/375)];
                    [topImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:banner.pic] placeholderImage:bannerImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [WHImageSaveAndLoad saveImage:image withFileName:[NSString stringWithFormat:@"banner%d.png",i] ofType:@"png"];
                    }];
                    [self.bannerScroll addSubview:topImageView];
                    
                    
                    UIButton * button = [[UIButton alloc]initWithFrame:topImageView.frame];
                    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    button.tag = i;
                    [button addTarget:self action:@selector(clickBannerButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.bannerScroll addSubview:button];
                }
            }
            
            [self.bannerTimer invalidate];
            if (self.bannerScroll.contentSize.width == LDScreenWidth) {
                self.bannerScroll.scrollEnabled = NO;
                
            }else{
                self.bannerScroll.scrollEnabled = YES;
                
                self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                                                    target:self
                                                                  selector:@selector(changeCurrentView)
                                                                  userInfo:nil
                                                                   repeats:YES];
            }
            
        }
        /** 现金贷，扫码按钮*/
        else{
            
            if (self.cashAndSaoma == nil) {
                self.cashAndSaoma = [WHCashAndSaomaView view];
                
                self.cashAndSaoma.frame = CGRectMake(0, 0, LDScreenWidth, 90 * LDScreenWidth/375);
                
                
                [self.cashAndSaoma.leftButton addTarget:self action:@selector(clickLetfButton:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.cashAndSaoma.leftButton addTarget:self action:@selector(clickLetfButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
                
                [self.cashAndSaoma.leftButton addTarget:self action:@selector(clickLetfButtonTouchCancel) forControlEvents:UIControlEventTouchCancel];
                
                [self.cashAndSaoma.leftButton addTarget:self action:@selector(clickLeftButtonTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
                
                [self.cashAndSaoma.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
                [self.cashAndSaoma.rightButton addTarget:self action:@selector(clickRightButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
                [self.cashAndSaoma.rightButton addTarget:self action:@selector(clickRightButtonTouchCancel) forControlEvents:UIControlEventTouchCancel];
                [self.cashAndSaoma.rightButton addTarget:self action:@selector(clickRightButtonTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
            }
            
            [cell addSubview:self.cashAndSaoma];
            
        }
        
        return cell;
    }
    /** 第二个section */
    else if (indexPath.section == 1){
        /** 未登录 情况 第一行高为 80 第二行高度为 更具屏幕适配 */
        if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil) {
            if (indexPath.row == 0) {
                HDFirstNoLoginTopCell * cell = [tableView dequeueReusableCellWithIdentifier:nologinTop];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
                
            }
            else{
                HDFirstNoLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:nologin];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        else{
            
            if (indexPath.row == 0) {
                if ([self.firstPageModel.debtInfo.repaymentAmt floatValue] != 0) {
                    HDFirstPageCheckCell * cell = [tableView dequeueReusableCellWithIdentifier:checkCell];
                    cell.debtInfo = self.firstPageModel.debtInfo;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.checkButton addTarget:self action:@selector(clickCheckButton:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.huankuanButton addTarget:self action:@selector(clickHuankuanButton:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                else{
                    
                    HDFirstPageScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:scoreCell];
                    cell.firstPageModel = self.firstPageModel;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell.scoreButton addTarget:self action:@selector(clickScoreButton:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
            }
            else{
                HDFirstNoLoginCell * cell = [tableView dequeueReusableCellWithIdentifier:nologin];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    else if (indexPath.section == 2){
        if (self.firstPageModel.orderInfo.applyId != nil && [self.firstPageModel.debtInfo.repaymentAmt floatValue] == 0) {
            HDFirstPageOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:orderCell];
            cell.orderInfo = self.firstPageModel.orderInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.orderButton addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else{
            
            HDFirstPageScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:scoreCell];
            cell.firstPageModel = self.firstPageModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.scoreButton addTarget:self action:@selector(clickScoreButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    else{
        HDFirstPageOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:orderCell];
        cell.orderInfo = self.firstPageModel.orderInfo;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.orderButton addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

/** 查看账单 */
- (void)clickCheckButton:(UIButton *)sender{

    if (self.firstPageModel.debtInfo.applyId != nil) {
        //统计买点
        [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:HKSY];
        LDThirdViewController * checkList = [[LDThirdViewController alloc]init];
        //checkList.payBackID = self.firstPageModel.debtInfo.applyId;
        [self.navigationController pushViewController:checkList animated:YES];
    }

}

/** 立即还款 */
- (void)clickHuankuanButton:(UIButton *)sender{
    
    /** 查询账单信息 */
    [self sendBillListRequest];

}

/** 查看信用分 */
- (void)clickScoreButton:(UIButton *)sender{

    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:ZLSY];
    
    LDMySore * myScore = [[LDMySore alloc]init];
    [self.navigationController pushViewController:myScore animated:YES];

}

/** 查看订单 */
- (void)clickOrderButton:(UIButton *)sender{

    LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
    orderDetail.applyId = self.firstPageModel.orderInfo.applyId;
    [self.navigationController pushViewController:orderDetail animated:YES];

}

/** 点击Banner */
- (void)clickBannerButton:(UIButton *)sender{
    
    if (self.firstPageModel.banner.count > 0) {
        HDFirstPageBanner * banner = self.firstPageModel.banner[sender.tag];
        
        if ([banner.jumpType isEqualToString:@"1"]) {
            LDTaoBaoVC * goodsDetail = [[LDTaoBaoVC alloc]init];
            goodsDetail.goodsID = banner.id;
            [self.navigationController pushViewController:goodsDetail animated:YES];
        }
        else if ([banner.jumpType isEqualToString:@"2"]){
            
            WHXinYongFenAgreementController * vc = [[WHXinYongFenAgreementController alloc]initWithURL:banner.pageUrl title:@"分付君"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        if (indexPath.row == 1) {
            
        }
    }
    else{
        
        if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil){
            
            //推出登录界面
            LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
            signinVC.fromWhere = @"shouye";
            LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
            [self.navigationController presentViewController:nvc animated:YES completion:nil];
        }
    }
}

/**
 *  点击扫码购按钮
 */
//扫码背景变色
- (void)clickLetfButtonTouchDown:(UIButton *)sender{
    self.cashAndSaoma.leftView.backgroundColor = WHColorFromRGB(0xdedede);
}
//再不触发TouchUpInside方法时修改扫码分背景色为白色
- (void)clickLetfButtonTouchCancel{
    self.cashAndSaoma.leftView.backgroundColor = [UIColor whiteColor];
}
//在控件内拖动，不触发TouchUpInside方法修改扫码背景色为白色
- (void)clickLeftButtonTouchDragInside{
    self.cashAndSaoma.leftView.backgroundColor = [UIColor whiteColor];
}
//弹出扫码界面
- (void)clickLetfButton:(UIButton *)sender{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:SMSY];
    
    self.cashAndSaoma.leftView.backgroundColor = WHColorFromRGB(0xdedede);
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                              target:self
                                            selector:@selector(timerFire)
                                            userInfo:nil
                                             repeats:YES];
    
    if ([self validateCamera] && [self canUseCamera]) {
        [self showQRViewController];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (void)timerFire{
    [_timer invalidate];
    
    self.cashAndSaoma.leftView.backgroundColor = [UIColor whiteColor];
    self.cashAndSaoma.rightView.backgroundColor = [UIColor whiteColor];
}
/**
 *  点击现金贷按钮
 */
//修改现金贷背景色
- (void)clickRightButtonTouchDown:(UIButton *)sender{
    self.cashAndSaoma.rightView.backgroundColor = WHColorFromRGB(0xdedede);
}
//再不触发TouchUpInside方法时修改现金贷分背景色为白色
- (void)clickRightButtonTouchCancel{
    self.cashAndSaoma.rightView.backgroundColor = [UIColor whiteColor];
}
//在控件内拖动，不触发TouchUpInside方法修改现金贷背景色为白色
- (void)clickRightButtonTouchDragInside{
    self.cashAndSaoma.rightView.backgroundColor = [UIColor whiteColor];
}
//现金贷请求
-(void)clickRightButton:(UIButton *)sender{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:XJSY];
    
    self.cashAndSaoma.rightView.backgroundColor = WHColorFromRGB(0xdedede);
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                              target:self
                                            selector:@selector(timerFire)
                                            userInfo:nil
                                             repeats:YES];
    
    [MBProgressHUD showError:@"此功能暂未开通"];
    
    //    if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
    //        //推出登录界面
    //        LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
    //        signinVC.fromWhere = @"shouye";
    //        LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
    //        [self.navigationController presentViewController:nvc animated:YES completion:nil];
    //    }else{
    //
    //
    //        self.fromWhere = @"shouye";
    //        [self yanzhengyonghuziliaoRequest];
    //    }
    
}
//5.创建导航栏右侧按钮
- (void)createRightNavButton{
    
    //初始化当行列右侧按钮的视图
    self.rightTitleButtonView = [WHRightButtonView view];
    self.rightTitleButtonView.frame = CGRectMake(self.view.frame.size.width-60, 0, 50, 30);
    self.rightTitleButtonView.messageBgView.layer.cornerRadius = self.rightTitleButtonView.messageBgView.frame.size.width/2;
    
    self.rightTitleButtonView.messageBgView.layer.borderWidth = self.rightTitleButtonView.messageBgView.frame.size.width/2;
    
    self.rightTitleButtonView.messageBgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.rightTitleButtonView.messageBgView.hidden = YES;
    [self.rightTitleButtonView.button addTarget:self action:@selector(clickRightTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightTitleButtonView];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//6.创建导航栏左侧按钮
- (void)createLeftNavButton{
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 74 , 40)];
    [leftButton setImage:[UIImage imageNamed:@"first_leftnav_3.0"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickNavLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
/** 点击扫码记录按钮*/
- (void)clickNavLeftButton:(UIButton *)sender{
    
    
    
    if (([LDUserInformation sharedInstance].token == nil)||([LDUserInformation sharedInstance].UserId == nil)) {//未登录
        
        
        LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
        signinVC.fromWhere = @"shouye";
        LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
        
    }else{
        
        WHWithOutOrderController * withOutOrder = [[WHWithOutOrderController alloc]init];
        [self.navigationController pushViewController:withOutOrder animated:YES];
        
    }
}
//导航栏右侧按钮响应方法
- (void)clickRightTitleButton:(UIButton *)sender{
    
    //统计买点
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:XXSY];
    
    if (([LDUserInformation sharedInstance].token == nil)||([LDUserInformation sharedInstance].UserId == nil)) {//未登录
        
        
        LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
        signinVC.fromWhere = @"shouye";
        LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
        
    }else{//登录状态下,跳转消息页,
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://18203316907"]];
        WHMessageController * messageController = [[WHMessageController alloc]init];
        
        [self.navigationController pushViewController:messageController animated:YES];
        
    }
    
}

//判断是否有相机
-(BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
//获取打开相机授权
-(BOOL)canUseCamera {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

//推出扫码界面
- (void)showQRViewController {
    
    QRViewController *qrVC = [[QRViewController alloc] init];
    qrVC.qrUrlBlock = ^(NSString * url){
        
        NSArray * array1 = [url componentsSeparatedByString:@"?"];
        if (array1.count > 1) {
            
            NSString * urlLast = array1[1];
            NSArray * array2 = [urlLast componentsSeparatedByString:@"&"];
            
            if (array2.count > 1) {
                for (NSString * str in array2) {
                    NSArray * array3 = [str componentsSeparatedByString:@"="];
                    
                    if (array3.count > 1) {
                        [self.dict setObject:array3[1] forKey:array3[0]];
                    }
                }
                
                
                if (([LDUserInformation sharedInstance].token == nil)||([LDUserInformation sharedInstance].UserId == nil)) {//未登录
                    
                    //                    //跳转到登录提示
                    //                    WHQROrderController * signVC = [[WHQROrderController alloc] init];
                    //                    [self.navigationController pushViewController:signVC animated:YES];
                    
                    [MBProgressHUD showError:@"请登录!"];
                    
                    LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
                    signVC.fromWhere = @"saomadenglu";
                    
                    LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:signVC];
                    
                    [self.navigationController presentViewController:nav animated:YES completion:^{
                        
                        /** 添加扫码登录成功通知 */
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saomaLoginSuccess) name:@"saomaLoginSuccess" object:nil];
                    }];
                    
                }else{
                    
                    [self qrOrderRequest:self.dict];
                }
                
            }else{
                if (array2 > 0) {
                    NSString * string = array2[0];
                    NSArray * array3 = [string componentsSeparatedByString:@"="];
                    
                    if (array3.count > 1) {
                        
                        /** 普通商品码 */
                        if ([array3[0] isEqualToString:@"commodityId"] ) {
                            [MBProgressHUD hideHUD];
                            
                            LDTaoBaoVC * goodsDetail = [[LDTaoBaoVC alloc]init];
                            goodsDetail.goodsID = array3[1];
                            [self.navigationController pushViewController:goodsDetail animated:YES];
                        }
                        /** 普通商户吗 */
                        else if ([array3[0] isEqualToString:@"businessId"]){
                            [MBProgressHUD hideHUD];
                            
                            [[LDGoodsIDAndZhuanAnId sharedInstance] setBusnessID:array3[1]];
                            LDBusnessController * beiyongBusniess = [[LDBusnessController alloc]init];
                            [self.navigationController pushViewController:beiyongBusniess animated:YES];
                            
                        }else{
                            [MBProgressHUD showError:@"无效的二维码！"];
                        }
                        
                        
                    }else{
                        
                        [MBProgressHUD showError:@"无效的二维码！"];
                    }
                    
                }else{
                    
                    [MBProgressHUD showError:@"无效的二维码！"];
                }
                
            }
            
        }
        else{
            
            [MBProgressHUD showError:@"无效的二维码！"];
        }
    };
    
    
    
    [self.navigationController pushViewController:qrVC animated:YES];
}
/** 扫码登录成功通知方法 */
- (void)saomaLoginSuccess{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"saomaLoginSuccess" object:nil];
    
    [self qrOrderRequest:self.dict];
}



/**
 *  获取用户信息完成程度
 */
- (void)yanzhengyonghuziliaoRequest{
    
    [MBProgressHUD showMessage:@"正在加载"];
    NSString * url = [NSString stringWithFormat:@"%@customInfo/infoStepAll",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
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
                    WHCustomInfoInfoStepAll * customInfo = [WHCustomInfoInfoStepAll mj_objectWithKeyValues:model.result];
                    
                    [self clickCashLoanButton:customInfo];
                }
                
            }
            else{
                [MBProgressHUD showError:model.message];
            }
        }
        
    }];
}



- (void)clickCashLoanButton:(WHCustomInfoInfoStepAll *)customInfo {
    
    if ([LDUserInformation sharedInstance].token == nil || [LDUserInformation sharedInstance].UserId == nil){
        LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
        signinVC.fromWhere = @"shouye";
        LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
        [self.navigationController presentViewController:nvc animated:YES completion:nil];
        
        //用户登陆后验证资料是否完善
    }else{
        
        
        //基本信息
        if (![customInfo.advancedInfo isEqualToString:@"1"] || ![customInfo.basicInfo isEqualToString:@"1"] ) {
            
            [MBProgressHUD showError:@"基本信息未完善！"];
            [self goBaseInformation];
        }
        
        //从业信息
        else if (![customInfo.workInfo isEqualToString:@"1"]) {
            [MBProgressHUD showError:@"从业信息未完善！"];
            [self goJob];
        }
        //联系人信息
        else if (![customInfo.contactInfo isEqualToString:@"1"]) {
            
            [MBProgressHUD showError:@"联系人信息未完善！"];
            [self goContactInformation];
        }
        else{
            
            [self sendRequestBuyNow];
        }
        
    }
}








/**
 *  网络请求,立即购买,购买验证
 */
- (void)sendRequestBuyNow{
    
    NSString * url = [NSString stringWithFormat:@"%@order/buyCheck",KBaseUrl];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].token) forKey:@"token"];
    
    [params setObject:NULLOBJ([LDUserInformation sharedInstance].UserId) forKey:@"id"];
    
    [params setObject:NULLSTR([LDUserInformation sharedInstance].phoneNumber) forKey:@"phoneNo"];
    
    
    [[LDNetworkTools sharedTools]request:POST url:url params:params callback:^(id response, NSError *error) {
        if(error != nil){
            
            [MBProgressHUD showError:@"网络错误"];
            
        }else{
            
            LDBackInformation * backInfor = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfor.code isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                
                CashLoanController * cashLoan = [[CashLoanController alloc]init];
                [self.navigationController pushViewController:cashLoan animated:YES];
                
                
            }else if ([backInfor.code intValue] == -100){
                
                //服务器异常
                [MBProgressHUD showError:backInfor.message];
                
                return ;
                
            }else if ([backInfor.code intValue] == -2) {
                
                [MBProgressHUD hideHUD];
                
                //未登录
                LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
                signinVC.fromWhere = @"shouye";
                LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
                [self.navigationController presentViewController:nvc animated:YES completion:nil];
                
                LDLog(@"未登录1234");
                
                return ;
                
            }else if([backInfor.code intValue] == -3) {
                //有未完结订单,无法购买
                [MBProgressHUD showError:backInfor.message];
                return;
                
            }else if([backInfor.code intValue] == -4) {
                
                //三个月内有被拒绝订单,无法购买.
                [MBProgressHUD showError:backInfor.message];
                return;
                
            }else{
                [MBProgressHUD showError:backInfor.message];
            }
            
        }
    }];
    
}

//登录失效，或者本地保存的用户数据为空前去登录
- (void)gologinAction{
    [_timer invalidate];
    LDSignInViewController * signinVC = [[LDSignInViewController alloc]init];
    signinVC.fromWhere = @"shouye";
    LDNavgationVController * nvc = [[LDNavgationVController alloc]initWithRootViewController:signinVC];
    [self.navigationController presentViewController:nvc animated:YES completion:nil];
    
}
//去完善基本信息
- (void)goBaseInformation{
    
    [_timer invalidate];
    LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
    PostIDCard.fromeWhere = self.fromWhere;
    PostIDCard.requestImage = YES;
    [self.navigationController pushViewController:PostIDCard animated:YES];
}

//去完善身份信息
- (void)goType{
    [_timer invalidate];
    LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
    PostIDCard.fromeWhere = self.fromWhere;
    PostIDCard.requestImage = NO;
    [self.navigationController pushViewController:PostIDCard animated:YES];
}
//去完善从业信息
- (void)goJob{
    [_timer invalidate];
    //完善工作信息
    WHWorkViewController * jobInfo = [[WHWorkViewController alloc]init];
    jobInfo.fromeWhere = self.fromWhere;
    [self.navigationController pushViewController:jobInfo animated:YES];
}

//去完善高级信息，
- (void)goPostIDCard{
    [_timer invalidate];
    LDPostIDCard * PostIDCard = [[LDPostIDCard alloc] init];
    PostIDCard.fromeWhere = self.fromWhere;
    PostIDCard.requestImage = NO;
    [self.navigationController pushViewController:PostIDCard animated:YES];
    
}
//去完善联系人信息
- (void)goContactInformation{
    [_timer invalidate];
    LDContactInformationViewController * ContactInfo = [[LDContactInformationViewController alloc] init];
    ContactInfo.fromeWhere = self.fromWhere;
    [self.navigationController pushViewController:ContactInfo animated:YES];
}

/**
 * 订单二维码请求
 **/
- (void)qrOrderRequest:(NSMutableDictionary *)dict{
    
    if ([LDUserInformation sharedInstance].UserId != nil && [LDUserInformation sharedInstance].token != nil) {
        NSString * str = [NSString stringWithFormat:@"%@package/scan",KBaseUrl ];
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
        [params setObject:[dict objectForKey:@"packageId"] forKey:@"packageId"];
        [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        
        [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
            if (error != nil) {
                
                /** 1.请求错误提示  */
                [MBProgressHUD showError:@"网络错误"];
                
                /** 2.打印错误信息  */
                LDLog(@"%@",error);
            }else{
                
                LDLog(@"二维码数据 ===== %@",response);
                
                /** 3.解析返回数据  */
                LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
                
                if ([backInfo.code isEqualToString:@"0"]) {
                    
                    [MBProgressHUD hideHUD];
                    
                    /** 4.解析二维码数据 */
                    if (backInfo.result != nil){
                        
                        WHQROrderModel * qrModel = [WHQROrderModel mj_objectWithKeyValues:backInfo.result];
                        
                        if ([[dict objectForKey:@"type"] isEqualToString:@"4"]) {
                            
                            
                            
                            HDZuFangOrderController * zufang = [[HDZuFangOrderController alloc]init];
                            zufang.detailModel = qrModel;
                            [self.navigationController pushViewController:zufang animated:YES];
                            
                        }else{
                            
                            /** 5.推出二维码订单详情页 */
                            HDFexOrderDetail * fexOrder = [[HDFexOrderDetail alloc]init];
                            fexOrder.detailModel = qrModel;
                            [self.navigationController pushViewController:fexOrder animated:YES];
                        }
                        
                    }else{
                        
                        [MBProgressHUD showError:@"此版本暂不支持扫描该二维码"];
                        
                    }
                }
                /** 6.二维码失效处理 */
                else if ([backInfo.code isEqualToString:@"-100"]){
                    [MBProgressHUD showError:backInfo.message];
                    
                    WHQRInvalidController * invalid = [[WHQRInvalidController alloc]init];
                    [self.navigationController pushViewController:invalid animated:YES];
                    
                }
                
                
                else
                {
                    /** 7.请求异常提示  */
                    [MBProgressHUD showError:backInfo.message];
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"saomaRuestLoginSuccess" object:nil];
            }
        }];
        
    }
}

/**
 * 3.0新首页数据请求
 **/
- (void)firstPageRequest{
    
    NSString * str = [NSString stringWithFormat:@"%@home/",KBaseUrl ];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    if ([LDUserInformation sharedInstance].token != nil && [LDUserInformation sharedInstance].UserId != nil){
        
        [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
        
        [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
        
    }
    
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        /**  结束刷新 */
        [self.coverView.mj_header endRefreshing];
        
        
        if (error != nil) {
            
            /** 1.请求错误提示  */
            [MBProgressHUD showError:@"网络错误"];
            /** 2.打印错误信息  */
            LDLog(@"%@",error);
        }else{
            
            LDLog(@"首页%@",response);
            
            /** 3.解析返回数据  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                
                
                /** 4.解析二维码数据 */
                if (backInfo.result != nil){
                    
                    self.firstPageModel = [HDFirstPageModel mj_objectWithKeyValues:backInfo.result];
                    
                    /** 9.存储新的信用分*/
                    NSString * nesScore = [NSString stringWithFormat:@"%@-%@",self.firstPageModel.creditScore,self.firstPageModel.level];
                    [WHSaveAndReadInfomation saveXinYongFen:nesScore];
                    
                    /** 发送统计刷新我的界面的信用分  */
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadScore" object:nil];
                    
                    [self.coverView reloadData];
                    
                }
                else{
                    [MBProgressHUD showError:backInfo.message];
                }
                
            }else if ([backInfo.code isEqualToString:@"-2"]){
                
                LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
                
                
                LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:signVC];
                
                [self.navigationController presentViewController:nav animated:YES completion:^{
                    
                }];
            }
            else{
                
            }
            
            LDLog(@"%@",response);
        }
    }];
}

/**
 * 主动还款请求  
 */
/** 获取账单列表 */
- (void)sendBillListRequest{
    
     [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@order/billList",KBaseUrl ];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    [params setObject:@"1" forKey:@"status"];
    
    
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        
        if (error != nil) {
            
            /** 1.打印请求错误信息*/
            NSLog(@"%@",error);
            
            /** 2.请求错误提示  */
            [self showFailViewWithString:@"网络错误"];
           
            
        }else{
            
            
            
            LDLog(@"billList == %@",response);
            
            /** 3.解析返回信息*/
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 4.解析账单 */
                HDOrderRepays * orderRepays = [HDOrderRepays mj_objectWithKeyValues:backInfo.result];
                
                HDARZaixianzhifuController * zaixianzhifu = [[HDARZaixianzhifuController alloc]init];
                zaixianzhifu.orderRepays = orderRepays;
                zaixianzhifu.sevenAmount = self.firstPageModel.debtInfo.repaymentAmt;
                [self.navigationController pushViewController:zaixianzhifu animated:YES];
                
                
            }else{
                
                [self showFailViewWithString:backInfo.message];
            }
            
        }
    }];
}

@end
