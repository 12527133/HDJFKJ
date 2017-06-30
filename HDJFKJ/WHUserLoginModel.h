

#import <Foundation/Foundation.h>

@interface WHUserLoginModel : NSObject

//令牌
@property (nonatomic, strong) NSString * token;
//客户id
@property (nonatomic, strong) NSString * id;
//头像url
@property (nonatomic, strong) NSString * avatar;
//昵称
@property (nonatomic, strong) NSString * nickname;
//性别
@property (nonatomic, strong) NSString * sex;
//真实姓名
@property (nonatomic, strong) NSString * idName;
//信用评分
@property (nonatomic, assign) NSInteger creditscore;
//近7日待还
@property (nonatomic, assign) float weekdebt;
//近30日待还
@property (nonatomic, assign) float monthdebt;
//全部待还
@property (nonatomic, assign) float debt;
//待审核订单数
@property (nonatomic, assign) NSInteger examwait;
//手机号
@property (nonatomic, strong) NSString * phone;

//淘宝授信
@property (nonatomic, strong) NSString * taobaoName;
//学信网授信
@property (nonatomic, strong) NSString *xuexinName;
//运营商授信
@property (nonatomic, strong) NSString * OperatorAuth;
//闪银客户id
@property (nonatomic, strong) NSString * syCustId;
//创建用户对象
+ (instancetype)createuserInfoModel;
//删除用户登录信息
+ (void)deleteUserLogin;



@end
