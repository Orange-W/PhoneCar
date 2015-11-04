//  RequestModel.h
//  智能车
//
//  Created by user on 15/11/3.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestModel : NSObject
@property (strong, nonatomic) NSArray *pullStatusParameter;
@property (strong, nonatomic) NSArray *pullreplyParameter;


- (void)sendMessageWithPhone:(NSString *)phoneNumber
                     content:(NSString *) content;

- (void)getReplyMessagesWithPhone:(NSString *) phoneNumber
                        startTime:(NSDate *) startTime
                          endTime:(NSDate *) endTime;
@end
