

#import "WHSaveAndReadInfomation.h"

#define SavePath(content,pathName) [NSKeyedArchiver archiveRootObject:content toFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:pathName]];

#define ReadPath(pathName) [NSKeyedUnarchiver unarchiveObjectWithFile:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:pathName]];

@implementation WHSaveAndReadInfomation


+(instancetype)sharedInstance{
    
    static WHSaveAndReadInfomation *instance;
    
    static dispatch_once_t oneceToken;
    
    dispatch_once(&oneceToken, ^{
        
        instance = [[WHSaveAndReadInfomation alloc] init];
        
    });
    
    return instance;
}

/**
 * 1.还款计划
 **/
+ (void)saveHuanKuanJiHua:(id)string{
    
    SavePath(string, @"HuanKuanJiHua.data");

}

+ (id)readHuanKuanJiHuan{
    
    NSString * huankuanjihua = ReadPath(@"HuanKuanJiHua.data");
    
    return huankuanjihua;
}

/**
 * 2.信用分
 **/
+ (void)saveXinYongFen:(id)string{

    SavePath(string, @"XinYongFen.data");
}

+ (NSString *)readXinYongFen{

    NSString * xinyongfen = ReadPath(@"XinYongFen.data");

    return xinyongfen;
}

/**
 * 3.用户基本信息
 **/
+ (void)saveBaseInfomation:(id)baseInfo{
    
    SavePath(baseInfo, @"BaseInfomation.data");
    
}

+ (id)readBaseInfomation{
    
    NSDictionary * baseInfo = ReadPath(@"BaseInfomation.data");
    
    return baseInfo;
}


/**
 *  4.用户工作信息
 **/
//4.1学生类型
+ (void)saveStudentWorkInfo:(id)studentInfo{
    
    SavePath(studentInfo, @"StudentWorkInfo.data");
}
+ (id)readStudentWorkInfo{
    
    NSDictionary * studentInfo = ReadPath(@"StudentWorkInfo.data");
    
    return studentInfo;

}

//4.2上班族类型
+ (void)saveShangBanWorkInfo:(id)shangbanInfo{
    
    SavePath(shangbanInfo, @"ShangBanWorkInfo.data");

}
+ (id)readShangbanWorkInfo{
    
    NSDictionary * shangbanInfo = ReadPath(@"ShangBanWorkInfo.data");
    
    return shangbanInfo;
}

//4.3创业者类型
+ (void)saveChuangYeWorkInfo:(id)chuangyeInfo{
    
    SavePath(chuangyeInfo, @"ChuangYeWorkInfo.data");

}
+ (id)readChunagYeWorkInfo{
    
    NSDictionary * chuangyeInfo = ReadPath(@"ChuangYeWorkInfo.data");
    
    return chuangyeInfo;

}


/**
 * 5.联系人信息
 **/
+ (void)saveContactInfomation:(id)contactInfo{
    
    SavePath(contactInfo, @"ContactInfomation.data");
}
+ (id)readContactInfomation{
    
    NSDictionary * contactInfo = ReadPath(@"ContactInfomation.data");
    
    return contactInfo;

}

/**
 * 6.身份证信息
 **/
+ (void)saveIDCardInfo:(id)idCard{
    
    SavePath(idCard, @"IDCardInfo.data");

}
+ (id)readIDCardInfo{
    NSDictionary * idCard = ReadPath(@"IDCardInfo.data");
    
    return idCard;
}

/**
 * 7.信用分界面用户完善程度
 **/
+ (void)saveInfoStepAll:(id)infoStepAll{
    
    SavePath(infoStepAll, @"InfoStepAll.data");
}
+ (id)readInfoStepAll{
    NSDictionary * infoStepAll = ReadPath(@"InfoStepAll.data");

    return infoStepAll;

}

/**
 * 8.头像图片
 **/
+ (void)saveUserIcon:(id)userIcon {
    
    SavePath(userIcon, @"UserIcon.data");

}
+ (id)readUserIcon{
    
    UIImage * userIcon = ReadPath(@"UserIcon.data");
    
    return userIcon;
}
/**
 * 9.分期数据
 **/
+ (void)saveFenQiData:(id)fenqi{

    SavePath(fenqi, @"FenQiData.data");

}
+ (id)readFenQiData{

    NSDictionary * fenqi = ReadPath(@"FenQiData.data");
    
    return fenqi;
}

/**
 * 10.信用分动画加载标识
 *    标示用户是否需要信用分提示动画,"0"表示需要，“1”不需要
 **/
+ (void)saveXYFAnimation:(id)XYFAnimation{
    
    SavePath(XYFAnimation, @"Prompt.data");

}
+ (id)readXYFAnimation{

    NSString * XYFAnimation = ReadPath(@"Prompt.data");

    return XYFAnimation;
}

/**
 * 11.通讯录的存储，读取
 **/
+ (void)saveAddressBook:(id)addressBook{

    SavePath(addressBook, @"addressBook.data");
}
+ (id)readAddressBook{

    NSArray * addressBook = ReadPath(@"addressBook.data");
    
    return addressBook;
}


/**
 *  XX.切换账号删除账号相关的数据
 **/
+ (void)deledateArchiveFile{
    
    //删除归档文件
    NSArray * dataFileArr = @[@"HuanKuanJiHua.data",@"XinYongFen.data",@"BaseInfomation.data",@"StudentWorkInfo.data",@"ShangBanWorkInfo.data",@"ChuangYeWorkInfo.data",@"ContactInfomation.data",@"IDCardInfo.data",@"InfoStepAll.data"];
    
    for (int i = 0; i < dataFileArr.count; i++) {
        NSString * fileData = dataFileArr[i];
        NSString * filename =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileData];
        
        
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filename]) {
            [defaultManager removeItemAtPath:filename error:nil];
        }
    }
    
    
}
@end
