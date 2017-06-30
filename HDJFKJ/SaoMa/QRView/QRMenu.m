//
//  QRMenu.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/30.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRMenu.h"

@implementation QRMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
     
        [self setupQRItem];
        //self.backgroundColor = [UIColor colorWithRed:47/255.0 green:47/255.0 blue:49/255.0 alpha:0.6];
        self.backgroundColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
    }
    
    return self;
}

- (void)setupQRItem {
    
    QRItem *qrItem = [[QRItem alloc] initWithFrame:(CGRect){
        .origin.x = 0,
        .origin.y = 15,
        .size.width = self.bounds.size.width / 2,
        .size.height = self.bounds.size.height
    } titile:@"二维码扫描"];
    qrItem.type = QRItemTypeQRCode;
    [self addSubview:qrItem];
    
    QRItem * qrButton = [[QRItem alloc] initWithFrame:(CGRect){
        .origin.x = self.bounds.size.width / 4 - 17,
        .origin.y = 10,
        .size.width = 35,
        .size.height = 35
    } titile:nil];
    qrButton.type = QRItemTypeQRCode;
    [qrButton setBackgroundImage:[UIImage imageNamed:@"扫一扫_23.png"] forState:UIControlStateNormal];
    [self addSubview:qrButton];
    
    
    
    QRItem *otherItem = [[QRItem alloc] initWithFrame: (CGRect){
        
        .origin.x = self.bounds.size.width / 2,
        .origin.y = 15,
        .size.width = self.bounds.size.width / 2,
        .size.height = self.bounds.size.height
    } titile:@"条形码扫描"];
    otherItem.type = QRItemTypeOther;
    [self addSubview:otherItem];
    
    
    QRItem * otherButton = [[QRItem alloc] initWithFrame:(CGRect){
        .origin.x = self.bounds.size.width / 4 *3 - 17,
        .origin.y = 10,
        .size.width = 35,
        .size.height = 35
    } titile:nil];
    otherButton.type = QRItemTypeOther;
    [otherButton setBackgroundImage:[UIImage imageNamed:@"扫一扫_26.png"] forState:UIControlStateNormal];
    [self addSubview:otherButton];
    
    
    
    [qrItem addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
    [otherItem addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
    
    [qrButton addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
    [otherButton addTarget:self action:@selector(qrScan:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - Action

- (void)qrScan:(QRItem *)qrItem {
    
    if (self.didSelectedBlock) {
        
        self.didSelectedBlock(qrItem);
    }
}



@end
