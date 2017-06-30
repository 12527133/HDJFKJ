//
//  SearchResultTableViewController.h
//  Demo3_Search_Bar
//
//  Created by tarena on 15/7/27.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewController : UITableViewController

//公开一个属性，用于接收即将要显示的搜索结果
@property(nonatomic,strong)NSArray *resultArray;

@end




