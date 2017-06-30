//
//  CameraPreviewHandler.h
//
//
//  Created by jqshen on 6/24/15.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoImage.h"

@protocol CameraPreviewDelegate <NSObject>

@required

- (void)onPreviewFrame: (PhotoImage*) image;

@end