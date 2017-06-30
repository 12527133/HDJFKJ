

#import <UIKit/UIKit.h>
#import "HDPictureModel.h"
@class HDHistoryPreView;
@protocol PreViewChange <NSObject>

-(void)changePreView:(HDHistoryPreView*)prview picture:(HDPictureModel *)picture;

@end

@interface HDHistoryPreView : UIView<UIScrollViewDelegate>{
    UIImageView * _imageView;
    UIScrollView * _contentView;
    UIButton * _collectionButton;
    UIButton * _deleteButton;
    
    
    NSString * _picID;
}

@property (nonatomic, strong) id<PreViewChange> delegate;
@property (nonatomic, strong) HDPictureModel * picModel;
- (void) setPicture:(HDPictureModel *) picture;


@end
