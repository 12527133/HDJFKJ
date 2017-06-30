

#import "HDCustomRalationVC.h"
#import "HDAddressBookCell.h"
#import "HDSearchCustController.h"
#import "HDRelationSequence.h"
@interface HDCustomRalationVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

/** 联系人列表 */
@property (nonatomic, strong) UITableView * tableView;

/** 搜索窗searchBar*/
@property (nonatomic, strong) UISearchController  *searchVC;
/** 搜索界面 */
@property (nonatomic, strong) HDSearchCustController *resultTVC;

/** 开发测试用的*/
@property (nonatomic, strong) NSMutableArray * groupArray;

/** 搜索的手机号  */
@property (nonatomic, strong) NSString * searchPhone;

/** 搜索的姓名  */
@property (nonatomic, strong) NSString * searchName;

/** 是否搜索 */
@property (nonatomic, assign) BOOL isSearch;

/** 排序后的出现过的拼音首字母数组 */
@property(nonatomic,strong)NSMutableArray *indexArray;

/** 排序好的结果数组 */
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation HDCustomRalationVC


- (void)dealloc{

    LDLog(@"销毁选择联系人界面 ");
}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self dismissHDLoading];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    [self setNavgationBackgroundWight];

    self.view.backgroundColor = LDBackroundColor;
    
    /** 关闭按钮 */
    [self createGobackHomePageButton];
    
    
    /** 数组排序 */
    [self sequenceLoadData:self.dataArray];
    
    /** 创建搜索视图  */
    [self createSearchView];
    
    /** 创建tableView */
    [self createTableView];
    
    self.isSearch = NO;
    
}

/** 数据排序 */
- (void)sequenceLoadData:(NSMutableArray *)array{
    //根据Person对象的 name 属性 按中文 对 Person数组 排序
    self.indexArray = [HDRelationSequence IndexWithArray:array Key:@"name"];
    self.letterResultArr = [HDRelationSequence sortObjectArray:array Key:@"name"];

}

/** 创建联系人列表 */
- (void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, LDScreenWidth, LDScreenHeight - 108 )];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDAddressBookCell  class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
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
/**
 * 创建导航栏右侧关闭按钮
 **/
- (void)createGobackHomePageButton{
    
    
    UIButton * backPage = [[UIButton alloc]init];
    
    backPage.frame =CGRectMake(0, 0, 60, 44);
    
    //[backPage setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [backPage setTitle:@"取消" forState:UIControlStateNormal];
    [backPage setTitleColor:WHColorFromRGB(0x4279d6) forState:UIControlStateNormal];
    backPage.titleLabel.font = [UIFont systemFontOfSize:17];
    [backPage addTarget:self action:@selector(ClickdismissButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /** 缩小控件与屏幕的间距 */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    
    //作为Item的子视图添加上去
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backPage];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    
}
/**
 * 关闭控制器
 **/
- (void)ClickdismissButton:(UIButton *)sender {
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


/**
 * 创建搜索视图
 **/
- (void)createSearchView{
    
    // 将搜索控制器和结果展示控制器实例化并关联
    self.resultTVC = [[HDSearchCustController alloc]init];
    
    self.resultTVC.searchVC = self.searchVC;
    
    __block typeof(self) weakSelf = self;
    self.resultTVC.completionBlock = ^(WHAddressBookModel * custModel){
        
        [weakSelf popSearchViewResult:custModel];
        
    };
    self.searchVC = [[UISearchController alloc]initWithSearchResultsController:self.resultTVC];
    // 设置搜索控制器的结果更新代理对象
    self.searchVC.searchResultsUpdater = self;
    // 设置显示的searchBar的大小和样式
    [self.searchVC.searchBar sizeToFit];
    
    // 将seachBar添加到表头中显示
    [self.view addSubview:self.searchVC.searchBar];
    // 开启在当前控制器中，允许切换另一个视图做呈现
    self.definesPresentationContext = YES;
    
    self.searchVC.searchBar.placeholder = @"输入姓名或手机号";
    
    // 为了感知用户在搜索条上选择了不同的button，设置代理
    self.searchVC.searchBar.delegate = self;
}

- (void)popSearchViewResult:(WHAddressBookModel *)addBook{

    _addressBook(addBook);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //根据用户在searchBar中输入的搜索文本和选择的scopebutton类别，进行搜索动作
    NSString *searchText = searchController.searchBar.text;
    
    //声明一个用于保存搜索结果的数组
    NSMutableArray *searchResultArray = [NSMutableArray array];
    
    //遍历联系人，依次比对
    for (WHAddressBookModel * custModel in self.dataArray) {
        
        //查找输入的文本是否在这个产品的名称中出现过
        NSRange rangeName = [custModel.name rangeOfString:searchText];
        NSRange rangePhone = [custModel.mobile rangeOfString:searchText];
        
        if (rangeName.length>0 || rangePhone.length > 0) {
            [searchResultArray addObject:custModel];
            
        }
    }

    self.resultTVC.groupArray = searchResultArray;
    [self.resultTVC.tableView reloadData];
    
}

/** tableView代理方法 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     HDAddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //获得对应的Person对象<替换为你自己的model对象>
    WHAddressBookModel * addBook = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     cell.addBookModel = addBook;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WHAddressBookModel * addBook = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    _addressBook(addBook);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
