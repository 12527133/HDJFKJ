

#import "HDAddressBookCell.h"
@interface HDAddressBookCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end
@implementation HDAddressBookCell


- (void)setAddBookModel:(WHAddressBookModel *)addBookModel{

    _addBookModel = addBookModel;
    
    self.nameLabel.text = _addBookModel.name;
    
    self.phoneLabel.text = _addBookModel.mobile;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
