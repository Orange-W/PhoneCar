//
//  RequestModel.m
//  智能车
//
//  Created by user on 15/11/3.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestBaseModel.h"

@implementation RequestBaseModel

static const NSInteger replyPageSize = 20;


- (void)sendMessageWithPhone:(NSString *)phoneNumber
                           content:(NSString *) content{
    [NetWork NetRequestPOSTWithRequestURL:kRequestUrlSendMessage
                    WithParameter:@{
                                    @"apikey":APPKEY,
                                    @"mobile":phoneNumber,
                                    @"text":content}
                     WithReturnValeuBlock:^(id returnValue) {
                         NSString *returnCode = returnValue[@"code"];
                         if(![returnCode intValue]){
                             [self sucessToDo:returnValue];
                         }else{
                             [self failureTodo:[returnCode integerValue]];
                         }
                     } WithFailureBlock:nil];
    
}

- (void)getReplyMessagesWithPhone:(NSString *) phoneNumber
                        startTime:(NSDate *) startTime
                          endTime:(NSDate *) endTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];

    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    NSDate *trueDate = [NSDate dateWithTimeIntervalSince1970:[startTime timeIntervalSince1970]+3600*8-60];
    
    NSLog(@"%@",trueDate);
    [NetWork NetRequestPOSTWithRequestURL:kRequestUrlPullReply
                            WithParameter:@{
                                            @"apikey":APPKEY,
                                            @"mobile":phoneNumber,
                                            @"start_time":[formatter stringFromDate:trueDate],
                                            @"end_time":[formatter stringFromDate:endTime],
                                            @"page_num":@1,
                                            @"page_size":[NSNumber numberWithInteger:replyPageSize],
                                            }
                     WithReturnValeuBlock:^(id returnValue) {
                         NSString *returnCode = returnValue[@"code"];
                         if(![returnCode intValue]){
                             [self sucessToDo:returnValue];
                         }else{
                             [self failureTodo:[returnCode integerValue]];
                         }
                         
                     } WithFailureBlock:nil];
}

- (void) sucessToDo:(NSDictionary *)returnValue{
    NSString *simpleChineseString = [returnValue description];
    simpleChineseString = [NSString stringWithCString:[simpleChineseString cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    NSLog(@"%@",[simpleChineseString description]);
}

- (void) failureTodo:(NSInteger)returnCode{
    NSLog(@"错误码:%ld",(long)returnCode);
}



@end
