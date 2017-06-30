

#import "HDSearchCustController.h"
#import "HDAddressBookCell.h"

@interface HDSearchCustController ()

@end

@implementation HDSearchCustController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDAddressBookCell  class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDAddressBookCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //获得对应的Person对象<替换为你自己的model对象>
    WHAddressBookModel * addBook = self.groupArray[indexPath.row];
    cell.addBookModel = addBook;
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchVC canResignFirstResponder];
    
    WHAddressBookModel * custModel = self.groupArray[indexPath.row];
    
    _completionBlock(custModel);
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
