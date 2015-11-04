//
//  RequestModel.m
//  智能车
//
//  Created by user on 15/11/3.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestModel.h"

@implementation RequestModel

static const NSInteger replyPageSize = 20;


- (void)sendMessageWithPhone:(NSString *)phoneNumber
                           content:(NSString *) content{
    [NetWork NetRequestPOSTWithRequestURL:kRequestUrlSendMessage
                    WithParameter:@{
                                    @"apikey":APPKEY,
                                    @"mobile":phoneNumber,
                                    @"text":content}
                     WithReturnValeuBlock:^(id returnValue) {
                         
                     } WithFailureBlock:nil];
    
}

- (void)getReplyMessagesWithPhone:(NSString *) phoneNumber
                        startTime:(NSDate *) startTime
                          endTime:(NSDate *) endTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];

    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    
    [NetWork NetRequestPOSTWithRequestURL:kRequestUrlPullReply
                            WithParameter:@{
                                            @"apikey":APPKEY,
                                            @"mobile":phoneNumber,
                                            @"start_time":[formatter stringFromDate:startTime],
                                            @"end_time":[formatter stringFromDate:endTime],
                                            @"page_num":@1,
                                            @"page_size":[NSNumber numberWithInteger:replyPageSize],
                                            }
                     WithReturnValeuBlock:^(id returnValue) {
                         NSLog(@"%@",returnValue);
                     } WithFailureBlock:nil];
}

@end
