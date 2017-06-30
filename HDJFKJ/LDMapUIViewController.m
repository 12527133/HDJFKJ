//
//  LDMapUIViewController.m
//  HDJFKJ
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDMapUIViewController.h"
#import "LDMapViewModel.h"

@interface LDMapUIViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * mapTableView;
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) LDMapViewModel * mapViewModel;
@property (nonatomic,strong) NSMutableArray * sectionTitle;
@property (nonatomic,strong) NSMutableArray * aer;
@property (nonatomic,strong) UIView * header;
@property(nonatomic,strong)UISearchController  *searchVC;

@end

@implementation LDMapUIViewController
static NSString * const mapCell = @"mapCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    self.view.backgroundColor = LDBackroundColor;
  
    [self creatTableView];
    [self creatSeachBar];
}

- (void)creatSeachBar{
    self.searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];


}
- (void)creatTableView{
    
    self.mapTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, LDScreenHeight, LDScreenHeight - 130) style:UITableViewStyleGrouped];
    self.mapTableView.contentInset = UIEdgeInsetsMake(-45, 0, 0, 0);
    [self.mapTableView registerClass:([UITableViewCell class]) forCellReuseIdentifier:mapCell];
    self.mapTableView.delegate = self;
    self.mapTableView.dataSource = self;
    [self.view addSubview:self.mapTableView];
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
-(NSMutableArray *)sectionTitle{

    if (_sectionTitle == nil) {
        
        _sectionTitle = [NSMutableArray array];
        
        for (LDMapViewModel * model in self.dataArray) {
            
            [_sectionTitle addObject:model.title];
        }
    }
    return _sectionTitle;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LDScreenWidth, 25)];
    self.header.backgroundColor = LDBackroundColor;
    UILabel * lable = [UILabel new];
    [self.header addSubview:lable];
    LDMapViewModel * model = self.dataArray[section];
    lable.text = model.title;
    lable.font = [UIFont systemFontOfSize:13];
    lable.frame = CGRectMake(18, 0, LDScreenWidth, self.header.frame.size.height);
    return self.header;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.navigationController popViewControllerAnimated:YES];
    LDLogFunc;
}

@end
