//
//  LDTextTableViewCell.m
//  HDJFKJ
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDBaseInformationCell.h"
#import "LDBasicModel.h"
#import "UserInfo.h"
@interface LDBaseInformationCell ()



















@property (nonatomic, strong) UIDatePicker *datePicker;

@end
@implementation LDBaseInformationCell

- (void)setBaseModel:(LDBasicModel *)baseModel{
    
    _baseModel = baseModel;
    
    self.lable.text = baseModel.lableText;
    
    self.textField.placeholder = baseModel.textFieldPlaceholder;
    self.upLine.hidden = YES;
    self.downLine.hidden = YES;
    
    self.addressBookButton.hidden = YES;
}
    
#pragma mark - 出生日期文本框赋值,监听方法
- (void)dateChange:(UIDatePicker *)datePicker
{
    LDLog(@"%@",datePicker.date);
    // 日期转换字符串
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    
    self.textField.text = dateStr;
}





@end
