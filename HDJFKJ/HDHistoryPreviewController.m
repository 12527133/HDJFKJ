

#import "HDHistoryPreviewController.h"

#import "HDMaterialOperate.h"
#import "HDHistoryPreView.h"

@interface HDHistoryPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PreViewChange>

@property (nonatomic, strong) UICollectionView * previewCollectionView;

@property (nonatomic, strong) UIButton * backHomePage;

@property (nonatomic, strong) NSIndexPath * currentIndexPath;

@end

@implementation HDHistoryPreviewController

- (NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc]init];
    }
    return _pictureArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预览";
    self.view.backgroundColor = [UIColor whiteColor];
    /** 设置导航栏  */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"矩形-29"] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏的前景色为黑色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //设置导航栏字体颜色为黑色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHColorFromRGB(0x323232)}];
    
    [self createNavLeftButton];
    
    [self createNavRightButton];
    
    /** 创建视图 */
    [self createViewAction];
}

/** 创建右侧按钮*/
- (void)createNavRightButton{
    self.backHomePage = [[UIButton alloc]init];
    self.backHomePage.frame= CGRectMake(0, 0, 80, 30);
    
    [self.backHomePage setTitleColor:WHColorFromRGB(0x051b28) forState:UIControlStateNormal];
    [self.backHomePage setTitle:[NSString stringWithFormat:@"1/%ld 完成",self.pictureArray.count] forState:UIControlStateNormal];
    [self.backHomePage setBackgroundColor:WHColorFromRGB(0xe84c3d)];
    [self.backHomePage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backHomePage.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.backHomePage addTarget:self action:@selector(clickFinishButton:) forControlEvents:UIControlEventTouchUpInside];
    self.backHomePage.layer.cornerRadius = 5.0;
    
    self.backHomePage.layer.borderWidth = 0.0;
    
    self.backHomePage.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.backHomePage];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:leftItem, nil];
    
}
- (void)clickFinishButton:(UIButton *)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        _deletePicBlock(nil);
    }];
}

/** 创建左侧按钮*/
- (void)createNavLeftButton{
    
    
    UIButton * backPage = [[UIButton alloc]init];
    
    backPage.frame =CGRectMake(0, 0, 30, 30);
    
    [backPage setImage:[UIImage imageNamed:@"shenhe_arrow_down"] forState:UIControlStateNormal];
    
    
    [backPage addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backPage];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftItem, nil];
    
}

- (void)ClickdismissButton:(UIButton *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


/**
 * 创建选择照片按钮
 * 创建展示图片的CollectionView
 **/
- (void)createViewAction{
    
  
    /** 1.创建加载图片的CollectionView  */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    self.previewCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0 , LDScreenWidth, self.view.frame.size.height) collectionViewLayout:layout];
    [self.view addSubview:self.previewCollectionView];
    self.previewCollectionView.delegate = self;
    self.previewCollectionView.dataSource = self;
    self.previewCollectionView.backgroundColor = WHColorFromRGB(0xf0f0f0);
    self.previewCollectionView.showsHorizontalScrollIndicator = FALSE; // 去掉滚动条
    self.previewCollectionView.pagingEnabled = YES;
    self.previewCollectionView.scrollEnabled = YES;
    [self.previewCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}

#pragma mark -- collectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.pictureArray.count;
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.currentIndexPath.row != indexPath.row) {
        [self.backHomePage setTitle:[NSString stringWithFormat:@"%ld/%ld 完成",self.currentIndexPath.row+1,self.pictureArray.count] forState:UIControlStateNormal];
    }

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    HDHistoryPreView *preview= nil;
    for (HDHistoryPreView * selectView in cell.contentView.subviews) {
        preview = selectView;
    }
    if (preview == nil) {
        preview = [[HDHistoryPreView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [cell.contentView addSubview:preview];
    }
    
    HDPictureModel * picModel = self.pictureArray[indexPath.row];
    preview.delegate = self;
    [preview setPicture:picModel];
    
    self.currentIndexPath = indexPath;
    
    return cell;
    
}

- (void)changePreView:(HDHistoryPreView *)prview picture:(HDPictureModel *)picture{
    
    /** 图片模型不为空做删除操作  */
    if (picture)
    {
        
        [self deletePicRequest:picture];
    }
    /** 图片模型为空做关闭视图操作  */
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }

}

//设置元素的的大小框

#pragma mark -- UICollectionViewDelegate
//设置每个 UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(LDScreenWidth, LDScreenHeight-64);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0,0);
}

//定义每个UICollectionView 的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}


//删除图片
- (void)deletePicRequest:(HDPictureModel *) picModel{
    
    _deletePicBlock(picModel);
    [self.pictureArray removeObject:picModel];
    
    [self.backHomePage setTitle:[NSString stringWithFormat:@"%ld/%ld 完成",self.currentIndexPath.row+1,self.pictureArray.count] forState:UIControlStateNormal];
    
    if (self.pictureArray.count ==0){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.previewCollectionView reloadData];
    }

    
//    [self showWithImageWithString:@"正在删除"];
//    NSString * str = [NSString stringWithFormat:@"%@customInfo/delpicture",KBaseUrl];
//    NSMutableDictionary * params = [NSMutableDictionary dictionary];
//    
//    [params setObject:[LDUserInformation sharedInstance].UserId forKey:@"id"];
//    [params setObject:[LDUserInformation sharedInstance].token forKey:@"token"];
//    [params setObject:picModel.picId forKey:@"picId"];
//    
//    [[LDNetworkTools sharedTools] request:POST url:str params:params callback:^(id response, NSError *error) {
//        if (error != nil) {
//            [self showFailViewWithString:@"网络错误"];
//        }else{
//            LDLog(@"%@",response);
//            NSString * code = [response objectForKey:@"code"] ;
//            
//            
//            //code == 0请求成功
//            if ([[NSString stringWithFormat:@"%@",code] isEqualToString:@"0"]) {
//                [self showSuccessViewWithString:@"删除成功"];
//                
//                _deletePicBlock(picModel);
//                [self.pictureArray removeObject:picModel];
//                
//                if (self.pictureArray.count ==0){
//                
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }else{
//                
//                    [self.previewCollectionView reloadData];
//                }
//
//                
//                
//            }else{
//                [self showFailViewWithString:@"删除失败"];
//            }
//            
//            
//        }
//    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
