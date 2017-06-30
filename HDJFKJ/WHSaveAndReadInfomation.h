

#import <Foundation/Foundation.h>

@interface WHSaveAndReadInfomation : NSObject

/**
 * 1.还款计划
 **/
+ (void)saveHuanKuanJiHua:(NSString *)string;
+ (NSString *)readHuanKuanJiHuan;

/**
 * 2.信用分
 **/
+ (void)saveXinYongFen:(NSString *)string;
+ (NSString *)readXinYongFen;

/**
 * 3.用户基本信息
 **/
+ (void)saveBaseInfomation:(id)baseInfo;
+ (id)readBaseInfomation;

/**
 *  4.用户工作信息
 **/
+ (void)saveStudentWorkInfo:(id)studentInfo;
+ (id)readStudentWorkInfo;

+ (void)saveShangBanWorkInfo:(id)shangbanInfo;
+ (id)readShangbanWorkInfo;

+ (void)saveChuangYeWorkInfo:(id)chuangyeInfo;
+ (id)readChunagYeWorkInfo;

/**
 * 5.联系人信息
 **/
+ (void)saveContactInfomation:(id)contactInfo;
+ (id)readContactInfomation;

/**
 * 6.身份证信息
 **/
+ (void)saveIDCardInfo:(id)idCard;
+ (id)readIDCardInfo;

/**
 * 7.信用分界面用户完善程度
 **/
+ (void)saveInfoStepAll:(id)infoStepAll;
+ (id)readInfoStepAll;



/**
 * 8.头像图片
 **/
+ (void)saveUserIcon:(id)userIcon;
+ (id)readUserIcon;


/**
 * 9.分期数据
 **/
+ (void)saveFenQiData:(id)fenqi;
+ (id)readFenQiData;

/**
 * 10.信用分动画加载标识
 *    标示用户是否需要信用分提示动画,"0"表示需要，“1”不需要
 **/
+ (void)saveXYFAnimation:(id)XYFAnimation;
+ (id)readXYFAnimation;

/**
 * 11.通讯录的存储，读取
 **/
+ (void)saveAddressBook:(id)addressBook;
+ (id)readAddressBook;

/**
 * 删除归档文件
 **/
+ (void)deledateArchiveFile;


@end
