//
//  SSImageView.h
//  diancaibao
//
//  Created by jujutec on 15/8/26.
//  Copyright (c) 2015年 jujutec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSImageView :UIView<UIScrollViewDelegate>{
    UIImageView * _imageView;
    UIScrollView * _contentView;
    UIButton * _collectionButton;
    UIButton * _deleteButton;
    UILabel * titleLabel;
    
    NSString * _picID;
}


//- (void) showImage;

- (void) hideImage;

- (void) setImage:(UIImage *) image;

+ (void) viewWithImage:(UIImage *) image picID:(NSString *)picID;


@end

