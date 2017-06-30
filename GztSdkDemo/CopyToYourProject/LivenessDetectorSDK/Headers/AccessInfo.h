//
//  AccessInfo.h
//  
//
//  Created by jqshen on 6/24/15.
//  Copyright (c) 2015 Oliveapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessInfo: NSObject

/**
 @param accessId 长度不超过16字节，不能为空
 @param accessKey 长度为32字节
 */
- (void) setAccessId: (NSString*)accessId
       withAccessKey: (NSString*) accessKey;

+ (id) sharedInstance;

-(NSString*) getAccessId;

-(NSString*) getAccessKey;

@end
