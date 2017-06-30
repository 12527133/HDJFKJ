//
//  LDAnotherInforCell.m
//  HDJFKJ
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 LDSmallCat. All rights reserved.
//

#import "LDAnotherInforCell.h"
#import "HDPictureModel.h"
#define CellWidth LDScreenWidth * 80/375


@interface LDAnotherInforCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet UIView *fistPading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendPadding;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threedPadding;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UIView *towPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *towImagePadding;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end


@implementation LDAnotherInforCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.width.constant = CellWidth;

    self.height.constant = CellWidth;

    self.towImagePadding.constant =     (LDScreenWidth - 4 * CellWidth)/5;
    
    self.left.constant =     (LDScreenWidth - 4 * CellWidth)/5;
    self.sendPadding.constant =     (LDScreenWidth - 4 * CellWidth)/5;
    self.threedPadding.constant = (LDScreenWidth - 4 * CellWidth)/5;

}

- (void)setPicArray:(NSMutableArray *)picArray{

    _picArray = picArray;
    
    if (_picArray.count > 0) {
        self.statusLabel.text = @"已完善";
        self.statusLabel.textColor = LDRGBColor(50, 50, 50, 0.5);
    }
    else{
        self.statusLabel.text = @"未完善";
        self.statusLabel.textColor =WHColorFromRGB(0x4279d6) ;
    }
    
    if (_picArray.count == 1) {
        [self setImage1];
    }
    
    if (_picArray.count == 2) {
        
        [self setImage1];
        [self setImage2];
        
    }
    
    if (_picArray.count == 3) {
        [self setImage1];
        [self setImage2];
        [self setImage3];
        
    }
    
    if (_picArray.count > 3) {
        [self setImage1];
        [self setImage2];
        [self setImage3];
        [self setImage4];
    }
}

- (void)setImage1{

    HDPictureModel * picModel = _picArray[0];
    if (picModel.thumbnail == nil) {
        [self.imageView1 sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:picModel.picUrl] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            picModel.thumbnail = [self imageCompressForWidth:image targetWidth:LDScreenWidth/2];
        }];
    }
    else{
    
        self.imageView1.image = picModel.thumbnail;
    }

}

- (void)setImage2{

    HDPictureModel * picModel2 = _picArray[1];
    if (picModel2.thumbnail == nil) {
        [self.imageView2 sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:picModel2.picUrl] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            picModel2.thumbnail = [self imageCompressForWidth:image targetWidth:LDScreenWidth/2];
        }];
    }
    else{
        
        self.imageView2.image = picModel2.thumbnail;
    }

}


- (void)setImage3{

    HDPictureModel * picModel3 = _picArray[2];
    if (picModel3.thumbnail == nil) {
        [self.imageView3 sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:picModel3.picUrl] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            picModel3.thumbnail = [self imageCompressForWidth:image targetWidth:LDScreenWidth/2];
        }];
    }
    else{
        
        self.imageView3.image = picModel3.thumbnail;
    }

}

- (void)setImage4{

    HDPictureModel * picModel4 = _picArray[3];
    if (picModel4.thumbnail == nil) {
        [self.imageView4 sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:picModel4.picUrl] placeholderImage:[UIImage imageNamed:@"商品 1:1"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            picModel4.thumbnail = [self imageCompressForWidth:image targetWidth:LDScreenWidth/2];
        }];
    }
    else{
        
        self.imageView4.image = picModel4.thumbnail;
    }
}


-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
