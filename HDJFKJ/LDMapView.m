//
//  LDMapView.m
//  HDJFKJ
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDMapView.h"
#import "LDMapViewModel.h"

@interface LDMapView ()<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) LDMapViewModel * mapViewModel;
@property (nonatomic,strong) NSMutableArray * aer;
@property (nonatomic,strong) UIView * header;
@property(nonatomic,strong)UISearchController  *searchVC;

@end

@implementation LDMapView
static NSString * const mapCell = @"mapCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    self.view.backgroundColor = LDBackroundColor;

    [self.tableView registerClass:([UITableViewCell class]) forCellReuseIdentifier:mapCell];
    
    self.searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    // 设置搜索控制器的结果更新代理对象
    self.searchVC.searchResultsUpdater = self;
    // 设置显示的searchBar的大小和样式
    self.searchVC.searchBar.frame = CGRectMake(0, 0, LDScreenWidth, 45);
    
    // 将seachBar添加到表头中显示
    self.tableView.tableHeaderView = self.searchVC.searchBar;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 25)];
    self.header.backgroundColor = LDBackroundColor;
    UILabel * lable = [UILabel new];
    [self.header addSubview:lable];
    LDMapViewModel * model = self.dataArray[section];
    lable.text = model.title;
    lable.frame = CGRectMake(18, 0, LDScreenWidth, self.header.frame.size.height);
    return self.header;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController popViewControllerAnimated:YES];
    LDLogFunc;
}
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LDMapViewModel * model = self.dataArray[section];
    
    return model.cities.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDMapViewModel * model = self.dataArray[indexPath.section];
      NSString * str = model.cities[indexPath.row];
   UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mapCell];;

    cell.textLabel.text = str;
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    LDMapViewModel * model = self.dataArray[section];
    return model.title;
}
#pragma mark - tabbleView初始化方法,返回Group模式
-(instancetype)initWithStyle:(UITableViewStyle)style{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    return self;
}
// 右边索引的标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    self.aer = [NSMutableArray array];
    for(int section='A';section<='Z';section++)
    {
        [self.aer addObject:[NSString stringWithFormat:@"%c",section]];
    }
    return self.aer;
    
    
}

#pragma mark - 懒加载,数据源
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        // 加载plist中的字典数组
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        // 字典数组 -> 模型数组
        NSMutableArray *dealArray = [NSMutableArray array];
        
        for (NSDictionary *dic in dictArray) {
            
            self.mapViewModel = [LDMapViewModel mj_objectWithKeyValues:dic];
 
            [dealArray addObject:self.mapViewModel];
            
            
        }
        
        _dataArray = dealArray;
    }
    return _dataArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
@end
