

#import <Foundation/Foundation.h>


typedef enum{
    Login = 1,
    HKSY = 2,
    ZDSY = 3,
    FQSY = 4,
    SMSY = 5,
    XJSY = 6,
    WDSY = 7,
    XXSY = 8,
    ZLSY = 9,
    GMSPXQ = 10,
    QRDDXQ = 11,
    ZFSPB = 12,
    DDWD = 13,
    ZDWD = 14,
    ZLWD = 15,
    YHKWD = 16,
    XGZFMM = 17,
    XGDLMM = 18,
    TCDL = 19,
    SFZXXZL = 20,
    CYXXZL = 21,
    LXRXXZL = 22,
    SQXXZL = 23,
    QDAPP = 24,
    GBAPP = 25
}OperateType;

@interface WHTongJIRequest : NSObject


+(instancetype)sharedTongji;

+ (void)sendTongjiRequestWithBusinessId:(NSString *)business_id oprType:(OperateType)opr_type;

//业务id
@property (nonatomic, strong) NSString * business_id;


/**
 * 操作类型opr_type：对应码值
 *
 * 登录按钮（登录页）：             1；
 *
 * 还款计划按钮（首页）：           2；
 *
 * 账单按钮（首页）：               3；
 * 
 * 分期按钮（首页）：               4；
 *
 * 扫码购按钮（首页）：             5；
 *
 * 现金贷按钮（首页）：             6；
 *
 * 我的按钮（首页）：               7；
 *
 * 消息按钮（首页）：               8；
 *
 * 我的资料（首页）：               9；
 *
 * 立即购买（商品详情页）：          10；
 *
 * 确认按钮（订单详情页）：          11；
 *
 * 去支付（商品包详情页）：          12；
 * 
 * 我的订单（我的界面）：            13；
 * 
 * 我的账单（我的界面）：            14；
 *
 * 我的资料（我的界面）：            15；
 *
 * 我的银行卡（我的界面）：           16；
 *
 * 修改支付密码按钮：（安全中心）      17；
 *
 * 修改登录密码按钮：（安全中心）      18；
 *
 * 推出登录按钮：（设置界面）         19；
 *
 * 身份证信息按钮：（我的资料界面）    20；
 * 
 * 从业信息按钮：（我的资料界面）      21；
 * 
 * 联系人信息按钮：（我的资料界面）     22；
 *
 * 授权信息按钮：（我的资料按钮）      23；
 * 
 * 启动app                         24；
 *
 * 关闭app                         25；
 **/
@property (nonatomic, assign) NSInteger opr_type;



























































@end
