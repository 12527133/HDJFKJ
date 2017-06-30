

#import "HDHistoryPictureController.h"
#import "LDtest2222ViewController.h"
#import "WHSendImageRequest.h"
#import "WHUserLoginModel.h"
#import "AuthorizViewController.h"
#import "SSImageView.h"
#import "WHImageSaveAndLoad.h"
#import "LDNavgationVController.h"
/** 图片模型  */
#import "HDPictureModel.h"

/** 上传图片返回信息模型*/
#import "HDPicBackModel.h"

/** 保存图片到本地，删除本地图片*/
#import "HDMaterialOperate.h"

/** 图片资料模型 */
#import "HDMaterialModel.h"

/** 基本按钮类 */
#import "HDBaseButton.h"

/** collectionViewCell*/
#import "HDHistoryPictureCell.h"

/** 预览CollectionView */
#import "HDHistoryPreviewController.h"

/** 历史资料模型  */
#import "HDHistoryPictureModel.h"

/** 历史资料列表模型 */
#import "HDHistoryPictureList.h"


@interface HDHistoryPictureController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView1;

@property (nonatomic, strong) NSMutableArray * selectImageArray;

@property (nonatomic, strong) HDHistoryPictureModel * materialModel;


@end

@implementation HDHistoryPictureController

- (NSMutableArray *)selectImageArray{
    if (!_selectImageArray) {
        _selectImageArray = [[NSMutableArray alloc]init];
    }
    return _selectImageArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView1 reloadData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择资料信息";
    self.view.backgroundColor = WHColorFromRGB(0xf0f0f0);
    
    
    
    
    [self createViewAction];
    
    [self gethistoryPictureArray];
}

/**
 * 创建选择照片按钮
 * 创建展示图片的CollectionView
**/
- (void)createViewAction{

    float buttonheight = 50 * LDScreenWidth/375;
    
    /** 1.创建加载图片的CollectionView  */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 2; //上下的间距 可以设置0看下效果
    
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    self.collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0 , LDScreenWidth, LDScreenHeight  - buttonheight - 64) collectionViewLayout:layout];
    [self.view addSubview:self.collectionView1];
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    self.collectionView1.backgroundColor = [UIColor whiteColor];
    [self.collectionView1 registerClass:[HDHistoryPictureCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.collectionView1 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    [self.collectionView1 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    
    /** 1.预览按钮  */
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - buttonheight -64, LDScreenWidth/2.0, buttonheight)];
    [button setTitle:@"预览" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:WHColorFromRGB(0xff9000)];
    [button addTarget:self action:@selector(clickYuLan:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 2.生成二维码按钮 */
    UIButton * QRbutton = [[UIButton alloc]initWithFrame:CGRectMake(LDScreenWidth/2, self.view.frame.size.height - buttonheight -64, LDScreenWidth/2.0, buttonheight)];
    [QRbutton setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:QRbutton];
    [QRbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QRbutton setBackgroundColor:WHColorFromRGB(0x3492e9)];
    [QRbutton addTarget:self action:@selector(clickFinish:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)clickFinish:(UIButton *)sender{

    if (self.sendMaterial.otherArray.count == 0) {
        [self.sendMaterial.otherArray addObjectsFromArray:[self.selectImageArray copy]];
    }
    else{
        for (HDPictureModel * picture1 in self.sendMaterial.otherArray) {
            BOOL iszes = NO;
            HDPictureModel * picture2 =nil;
            for (HDPictureModel * picture3 in self.selectImageArray) {
                if ([picture1.picUrl isEqualToString:picture3.picUrl]) {
                    picture2 = picture3;
                    iszes = YES;
                }
            }
            if (iszes) {
                [self.selectImageArray removeObject:picture2];
            }
        }
        
        [self.sendMaterial.otherArray addObjectsFromArray:[self.selectImageArray copy]];
        
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickYuLan:(UIButton *)sender{
    
    if (self.selectImageArray.count > 0) {
        HDHistoryPreviewController * preview = [[HDHistoryPreviewController alloc]init];
        preview.pictureArray = self.selectImageArray;
    
        LDNavgationVController * nav = [[LDNavgationVController alloc]initWithRootViewController:preview];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        
        preview.deletePicBlock = ^(HDPictureModel * pciture){
            //[self clickFinish:nil];
            
            [self.selectImageArray removeObject:pciture];
            if (self.selectImageArray.count == 0) {
                [self clickFinish:nil];
            }
            
            
        };
    }
    else{
        [self showFailViewWithString:@"你还未选择照片"];
    
    }
   
}

#pragma mark -- collectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.materialModel.others.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HDHistoryPictureList * picList = self.materialModel.others[section];
    
    return picList.picList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UINib *nib = [UINib nibWithNibName:@"HDHistoryPictureCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"cell"];
    HDHistoryPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath:indexPath];
   
    cell.subImageView.image = [UIImage imageNamed:@"相机"];
    
    
    HDHistoryPictureList * picList = self.materialModel.others[indexPath.section];
   
    HDPictureModel * picModel = picList.picList[indexPath.row ];
    if ( [picModel.picUrl rangeOfString:@"http"].length > 0) {
        [cell.subImageView sd_setImageWithURL:[NSURL URLWithString:picModel.picUrl] placeholderImage:[UIImage imageNamed:@"相机"]];
    }else{
        cell.subImageView.image = picModel.thumbnail;
    }
   
     cell.selectImageView.hidden = YES;
    for (HDPictureModel * pic in self.selectImageArray) {
        if ([picModel.picId isEqualToString:pic.picId]) {
             cell.selectImageView.hidden = NO;
        }
    }
    
    return cell;
    
}
//设置元素的的大小框

#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((LDScreenWidth -10)/4-2, (LDScreenWidth -10)/4-2);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0,5);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
#pragma mark -- collectionViewDateSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        
        // 从重用队列里面获取
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        // 设置背景颜色
        header.backgroundColor = [UIColor whiteColor];
        
        //设置标题
        UILabel * subLabel = nil;
        for (UILabel * label in header.subviews) {
            
            
            subLabel = label;
            if (label != nil) {
                break;
            }
        }
        if (subLabel == nil) {
            subLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, LDScreenWidth-15, 20)];
            subLabel.textColor = WHColorFromRGB(0x323232);
            subLabel.textAlignment = NSTextAlignmentLeft;
            subLabel.font = [UIFont systemFontOfSize:15];
            [header addSubview:subLabel];
        }
        
        HDHistoryPictureList * hisPicList = self.materialModel.others[indexPath.section];
        subLabel.text = hisPicList.uploadDate;
        
        return header;
        
    }else if (kind == UICollectionElementKindSectionFooter) {
        // footer
        
        // 从重用队列里面获取
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        //设置背景色
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }
    
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(LDScreenWidth, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    return CGSizeMake(LDScreenWidth, 20);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HDHistoryPictureCell * cell = (HDHistoryPictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.selectImageView.hidden = !cell.selectImageView.hidden;
    
    HDHistoryPictureList * hisPicList = self.materialModel.others[indexPath.section];
    
    if (!cell.selectImageView.hidden ) {
        
        
        [self.selectImageArray addObject:hisPicList.picList[indexPath.row]];
    }else{
        
        [self.selectImageArray removeObject:hisPicList.picList[indexPath.row]];
    }  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gethistoryPictureArray{
    
    
    [self showWithImageWithString:@"正在加载"];
    
    NSString * str = [NSString stringWithFormat:@"%@customInfo/historyPictureInfo",KBaseUrl];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
    
    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
        if (error != nil) {
            
            NSLog(@"%@",error);
            
            /** 1.网络请求错误提示*/
            [self showFailViewWithString:@"网络错误"];
            
        }else{
            
            LDLog(@"%@",response);
            
            /** 2.解析返回结果  */
            LDBackInformation * backInfo = [LDBackInformation mj_objectWithKeyValues:response];
            
            /** code == 0请求成功 */
            if ([backInfo.code isEqualToString:@"0"]) {
                
                [self dismissHDLoading];
                
                /** 3.解析返回的照片数据 */
                if (backInfo.result != nil) {
                    self.materialModel = [HDHistoryPictureModel mj_objectWithKeyValues:backInfo.result];
                    
                    [self.collectionView1 reloadData];
                    
                }
 
            }else{
                /** 6.请求异常提示 **/
                [self showFailViewWithString:backInfo.message];
            }
            
            LDLog(@"%@",response);
        }
    }];
}


@end
