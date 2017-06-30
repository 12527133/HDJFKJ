//
//  LDEntrepreneursTableViewController.h
//  ceshi
//
//  Created by 石伟浩 on 16/5/18.
//  Copyright © 2016年 石伟浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDEntrepreneursTableViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *companyName;

@property (weak, nonatomic) IBOutlet UITextField *companyPhone;

@property (weak, nonatomic) IBOutlet UITextField *companyQuHao;

@property (weak, nonatomic) IBOutlet UITextField *companySize;

@property (weak, nonatomic) IBOutlet UITextField *companyPlace;

@property (weak, nonatomic) IBOutlet UITextField *sumYear;

@property (weak, nonatomic) IBOutlet UITextView *conmanyDetailPlace;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *sumYearButton;

@property (weak, nonatomic) IBOutlet UIButton *comanySizeButton;

@property (weak, nonatomic) IBOutlet UIButton *companyDetailButton;

@property (weak, nonatomic) IBOutlet UIButton *companyPlaceButton;


/**
 *  哪个流程
 */
@property (nonatomic,copy) NSString * fromeWhere;

//新的工作类型
@property (nonatomic, strong) NSString * jobType;

//原来的工作类型
//@property (nonatomic, strong) NSString * oldJobType;
@end
