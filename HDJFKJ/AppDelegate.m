//
//  AppDelegate.m
//  北京互动金服科技
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "LDTabBarController.h"
#import "LDNavgationVController.h"
#import "LDGuideView.h"
#import "BaiduMobStat.h"
#import "UMessage.h"
#import "LDNewOrderDetailVC.h"
#import <UserNotifications/UserNotifications.h>
#import "LDSignInViewController.h"
#import "HDNSNotificModel.h"
#import "HDNotificAlert.h"
#import "HDNotificAps.h"
#import "LDThirdViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate,UNUserNotificationCenterDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic,assign) int isLogin;

@property (nonatomic, strong) CLLocationManager * locationManager;

@property (nonatomic, assign) BOOL isEnterBack;

@end


@implementation AppDelegate
- (void)pushGuide{
    
    NSString *key = @"CFBundleShortVersionString";
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        
        
        self.window.rootViewController = [[LDGuideView alloc] init];
        
    }else{
        
        LDTabBarController * tab = [[LDTabBarController alloc] init];
        

        self.window.rootViewController = tab;
        
            }

}
// 启动百度移动统计
- (void)startBaiduMobileStat{
    /*若应用是基于iOS 9系统开发，需要在程序的info.plist文件中添加一项参数配置，确保日志正常发送，配置如下：
     NSAppTransportSecurity(NSDictionary):
     NSAllowsArbitraryLoads(Boolen):YES
     详情参考本Demo的BaiduMobStatSample-Info.plist文件中的配置
     */
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableDebugOn = YES;
    
    [statTracker startWithAppId:@""]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
}

//校准位置
- (void)newLocation{
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    //判断是否启动了定位服务
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务没打开，请启动定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            //向用户请求授权
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    //设置定位的精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    //开始定位用户的位置
    [_locationManager startUpdatingLocation];
}


/** 友盟通知 */
- (void)UMessageSet:(NSDictionary *)launchOptions{

    /** 初始化消息数为0 */
    [NSKeyedArchiver archiveRootObject:@"0" toFile:pushMsgCount];
    
    //设置 AppKey 及 LaunchOptions
    
    [UMessage startWithAppkey:@"" launchOptions:launchOptions httpsenable:YES];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }else
    {
        [UMessage registerForRemoteNotifications:categories];
    }
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    [UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
    //for log
    [UMessage setLogEnabled:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    [_locationManager stopUpdatingLocation];

    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    
    [revGeo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error && [placemarks count] > 0){
            NSDictionary *dict =[[placemarks objectAtIndex:0] addressDictionary];
            //记录地址
            NSLog(@"%@",dict);
            
            NSString * city = [dict objectForKey:@"City"];
            NSString * name = [dict objectForKey:@"Name"];
            [[LDUserInformation sharedInstance] setLocationName:name];
            [[LDUserInformation sharedInstance] setLocationCity:city];
            //归档存储用户信息
            [NSKeyedArchiver archiveRootObject:city toFile:LoacationArea];
        
        }
        else{
            LDLog(@"ERROR: %@", error);
        }
    }];
}

- (void)changeRootViewController{
    
    self.window.rootViewController = [[LDTabBarController alloc] init];
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /** 进入后台默认值为NO */
    self.isEnterBack = NO;
    
    /** 百度统计 */
    //[self startBaiduMobileStat];
    //延长启动图时间
    //[NSThread sleepForTimeInterval:1.0];
    
    /** 友盟通知 */
    [self UMessageSet:launchOptions];
    
    //数据赋值
    [self shareInstance];
    //启动定位服务
    [self newLocation];
    
    
    //设置SDWebImageView的缓存
    SDImageCache * cache = [SDImageCache sharedImageCache];
    cache.maxCacheSize = 1024 * 5;
    cache.maxMemoryCountLimit = 10;
    

    
    [[UIApplication sharedApplication] setStatusBarStyle:
     UIStatusBarStyleLightContent animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootViewController) name:@"registerSucess" object:nil];
    
    //创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //设置窗口的根控制器
    
    [self pushGuide];

    self.window.backgroundColor = LDBackroundColor;
    //显示窗口控制器
    [self.window makeKeyAndVisible];
    
    /** 请求更新数据 */
    //[self sendRequest];
    
    
    /** 程序从杀死状态进入APP 如果由推送消息 的处理过程 */
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo != nil) {

        
        [self saveNotificInfo:userInfo];
        
    }
    
    
   
    return YES;
   
}

/** 从杀死状态进入app 存储消息信息 */
- (void)saveNotificInfo:(id)noticInfo{

    NSString * infoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"noticInfo.data"];
    
    [NSKeyedArchiver archiveRootObject:noticInfo toFile:infoPath];
}


/**
 *  数据存储,单例赋值
 */
- (void)shareInstance{
    
    //保存ID和token

    [[LDUserInformation sharedInstance] setPassWord:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    [[LDUserInformation sharedInstance] setPhoneNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
  
}



- (void)sendRequest{
    
    NSString * str = nil;
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    str = [NSString stringWithFormat:@"地址"];

    [[LDNetworkTools sharedTools] request:POST url:str params:nil callback:^(id response, NSError *error) {
        if (error != nil) {
            
           
        }else{
            
            NSLog(@"%@",response);
            
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            
            //code == 200请求成功
            if ([backInfo.code isEqualToString:@"0"]) {
                NSDictionary * dict = [response objectForKey:@"result"];
                NSString * version = [dict objectForKey:@"iosversion"];
                
                /** 版本号不为保存版本号 */
                if (version.length > 0) {
                    [[LDUserInformation sharedInstance] setIosVerson:version];
                }
                
                NSString *key = @"CFBundleShortVersionString";
                NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
                
                if (version == nil || [version isEqualToString:@""]) {
                    
                }
                else {
                    if (![version isEqualToString:currentVersion]) {
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"升级提示" message:@"检测到新版本，是否立即更新？" delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles: nil];
                        alert.tag = 13;
                        [alert show];
                    }
                }
                
            }else{
                
            }
        }
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 13) {
        NSString * str = nil;
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
    /** 消息通知弹窗 */
    if (alertView.tag == 1226){
    
        /** 点击确定按钮 */
        if (buttonIndex == 1) {
            
            /** 获取到最当前 的控制器的NavgationController */
            LDTabBarController * tabBarController = self.window.rootViewController;
            NSInteger index = tabBarController.selectedIndex;
            LDNavgationVController * nav = [tabBarController.viewControllers objectAtIndex:index];
            
            /** 判断是否在登录状态 */
            if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
                
                
                /** 未登录推出登录界面  ，登录结束后再有原控制器的Controller推出对应界面 */
                LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
                signVC.fromWhere = @"tongzhi";
                LDNavgationVController * nav2 = [[LDNavgationVController alloc]initWithRootViewController:signVC];
                [nav presentViewController:nav2 animated:YES completion:nil];
                
            }else{
            
                /** 判断推送消息的类型 */
                if ([[HDNSNotificModel sharedInstance].pushType isEqualToString:@"apply"]) {
                    
                    /** 订单类型的通知  ，推出订单详情界面 */
                    LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
                    orderDetail.applyId = [HDNSNotificModel sharedInstance].applyId;
                    [nav pushViewController:orderDetail animated:YES];
                }
                if ([[HDNSNotificModel sharedInstance].pushType isEqualToString:@"bill"]){
                    LDThirdViewController * vc = [[LDThirdViewController alloc]init];
                    [nav pushViewController:vc animated:YES];
                
                }
                
            }

        }
    
    }
}
//监听app前台后天转换
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //
    [WHTongJIRequest sendTongjiRequestWithBusinessId:nil oprType:GBAPP];
    
    /** 进入后台设置yes */
    self.isEnterBack = YES;
    NSLog(@"进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // 回到前台
    LDLog(@"进入前台");
    
    if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [LDUserInformation sharedInstance].deviceToken = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongzhikaiqi" object:@{@"device_token":@""}];
    };
    
}


//iOS10以前接收的方法
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //这个方法用来做action点击的统计
    [UMessage sendClickReportForRemoteNotification:userInfo];
    //下面写identifier对各个交互式的按钮进行业务处理
}



//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    
    LDLog(@"%@",userInfo);
    
    /** 解析推送内容 */
    HDNSNotificModel * noticModel = [HDNSNotificModel mj_objectWithKeyValues:userInfo];
    
    [[HDNSNotificModel sharedInstance] setApplyId:noticModel.applyId];
    [[HDNSNotificModel sharedInstance] setPushType:noticModel.pushType];
    
    /** 在前台  */
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        
        /** 解析提示内容 */
        HDNotificAps * noticAps = [HDNotificAps mj_objectWithKeyValues:noticModel.aps];
        if (noticAps.alert != nil) {
            HDNotificAlert * noticAlert = [HDNotificAlert mj_objectWithKeyValues:noticAps.alert];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:noticAlert.title
                                                                message:noticAlert.body
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",nil];
            alertView.tag = 1226;
            [alertView show];
        }
        
    }
    
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
   
    }
    /** 在后台 */
    else{
    
    
        /** 获取到当前控制器的NangationController */
        LDTabBarController * tabBarController = self.window.rootViewController;
        NSInteger index = tabBarController.selectedIndex;
        LDNavgationVController * nav = [tabBarController.viewControllers objectAtIndex:index];
        
        /** 判断当前用户是否登录 */
        if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
            
            /**未登录状态推出登录界面，登录成功后由原控制器推出对应界面  */
            LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
            signVC.fromWhere = @"tongzhi";
            LDNavgationVController * nav2 = [[LDNavgationVController alloc]initWithRootViewController:signVC];
            [nav presentViewController:nav2 animated:YES completion:nil];
        }else{
            
            /** 登录状态推出相应界面  */
            if ([noticModel.pushType isEqualToString:@"apply"]) {
                LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
                orderDetail.applyId = noticModel.applyId;
                [nav pushViewController:orderDetail animated:NO];
            }
            if ([[HDNSNotificModel sharedInstance].pushType isEqualToString:@"bill"]){
                LDThirdViewController * vc = [[LDThirdViewController alloc]init];
                [nav pushViewController:vc animated:NO];
                
            }
        }
    
    }

}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        
        LDLog(@"%@",userInfo);
        
        /** 解析推送内容 */
        HDNSNotificModel * noticModel = [HDNSNotificModel mj_objectWithKeyValues:userInfo];
        
        [[HDNSNotificModel sharedInstance] setApplyId:noticModel.applyId];
        [[HDNSNotificModel sharedInstance] setPushType:noticModel.pushType];
        
        /** 解析提示内容 */
        HDNotificAps * noticAps = [HDNotificAps mj_objectWithKeyValues:noticModel.aps];
        
        if (noticAps.alert != nil) {
            HDNotificAlert * noticAlert = [HDNotificAlert mj_objectWithKeyValues:noticAps.alert];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:noticAlert.title
                                                                message:noticAlert.body
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定",nil];
            alertView.tag = 1226;
            [alertView show];
        }
        
    }else{
        
       
        
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    //completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        /** 解析推送内容 */
        HDNSNotificModel * noticModel = [HDNSNotificModel mj_objectWithKeyValues:userInfo];
        
        [[HDNSNotificModel sharedInstance] setApplyId:noticModel.applyId];
        [[HDNSNotificModel sharedInstance] setPushType:noticModel.pushType];
        
        
        /** 用于判断是再后台运行状态，还是App再杀死状态，初始值为NO，当触发进入后台时设置为YES */
        if (self.isEnterBack) {
            
            /** 获取到当前控制器的NangationController */
            LDTabBarController * tabBarController = self.window.rootViewController;
            NSInteger index = tabBarController.selectedIndex;
            LDNavgationVController * nav = [tabBarController.viewControllers objectAtIndex:index];
            
            /** 判断当前用户是否登录 */
            if ([LDUserInformation sharedInstance].UserId == nil || [LDUserInformation sharedInstance].token == nil) {
                
                /**未登录状态推出登录界面，登录成功后由原控制器推出对应界面  */
                LDSignInViewController * signVC = [[LDSignInViewController alloc] init];
                signVC.fromWhere = @"tongzhi";
                LDNavgationVController * nav2 = [[LDNavgationVController alloc]initWithRootViewController:signVC];
                [nav presentViewController:nav2 animated:YES completion:nil];
            }else{
                
                /** 登录状态推出相应界面  */
                if ([noticModel.pushType isEqualToString:@"apply"]) {
                    LDNewOrderDetailVC * orderDetail = [[LDNewOrderDetailVC alloc]init];
                    orderDetail.applyId = noticModel.applyId;
                    [nav pushViewController:orderDetail animated:NO];
                }
                if ([[HDNSNotificModel sharedInstance].pushType isEqualToString:@"bill"]){
                    LDThirdViewController * vc = [[LDThirdViewController alloc]init];
                    [nav pushViewController:vc animated:NO];
                    
                }
            }
        }
        
        

    }else{
        //应用处于后台时的本地推送接受
        
        NSString * megCount = [NSKeyedUnarchiver unarchiveObjectWithFile:pushMsgCount];
        NSInteger count = [megCount integerValue];
        count ++;
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = count;
        
        [NSKeyedArchiver archiveRootObject:[NSString stringWithFormat:@"%ld",(long)count] toFile:pushMsgCount];
    }
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    /** 1.2.7版本开始不需要用户再手动注册devicetoken */
    //[UMessage registerDeviceToken:deviceToken];
    
    
    
    
    
    NSString * device_Token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[LDUserInformation sharedInstance] setDeviceToken:device_Token];
    
    
    if ([LDUserInformation sharedInstance].UserId != nil){
    
        [UMessage setAlias:[LDUserInformation sharedInstance].UserId type:@"hudong" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            
            NSLog(@"%@",responseObject);
        }];
    }
    
    LDLog(@"deviceToken = %@",device_Token);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tongzhikaiqi" object:@{@"device_token":device_Token}];
    
}



@end
