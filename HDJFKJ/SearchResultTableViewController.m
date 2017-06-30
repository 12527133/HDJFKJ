//
//  SearchResultTableViewController.m
//  Demo3_Search_Bar
//
//  Created by tarena on 15/7/27.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SearchResultTableViewController.h"
//#import "Product.h"

@interface SearchResultTableViewController ()

@end

@implementation SearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell1"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
    
//    // 按照行号取数据
//    Product *p = self.resultArray[indexPath.row];
//    
//    cell.textLabel.text = p.name;
    
    return cell;
}

@end
