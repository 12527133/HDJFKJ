//
//  LDJobStudentInforController.h
//  ceshi
//
//  Created by 石伟浩 on 16/5/18.
//  Copyright © 2016年 石伟浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LDJobStudentInforController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *schoolName;

@property (weak, nonatomic) IBOutlet UITextField *faculty;

@property (weak, nonatomic) IBOutlet UITextField *schoolSity;

@property (weak, nonatomic) IBOutlet UITextView *schoolDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *schoolDetailButton;

@property (weak, nonatomic) IBOutlet UITextView *dormitoryTextView;

@property (weak, nonatomic) IBOutlet UIButton *dormitoryButton;

@property (weak, nonatomic) IBOutlet UITextField *money;

@property (weak, nonatomic) IBOutlet UIButton *schoolButton;

@property (weak, nonatomic) IBOutlet UIButton *nextbutton;


/**
 *  哪个流程
 */
@property (nonatomic,copy) NSString * fromeWhere;

//新的工作类型
@property (nonatomic, strong) NSString * jobType;

//原来的工作类型
//@property (nonatomic, strong) NSString * oldJobType;


@end
