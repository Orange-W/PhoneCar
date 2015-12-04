//
//  RequestModel.m
//  智能车
//
//  Created by user on 15/11/3.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestBaseModel.h"
#import "PullCenterModel.h"
@implementation RequestBaseModel

static const NSInteger replyPageSize = 20;


- (void)sendMessageWithPhone:(NSString *)phoneNumber
                           content:(NSString *) content{
    NSLog(@"content:%@",content);
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
    NSDictionary *paramer = @{
                         @"apikey":APPKEY,
                         @"mobile":phoneNumber,
                         @"start_time":[formatter stringFromDate:trueDate],
                         @"end_time":[formatter stringFromDate:endTime],
                         @"page_num":@1,
                         @"page_size":[NSNumber numberWithInteger:replyPageSize],
                         };
//    NSLog(@"请求参数:%@",paramer);
    NSLog(@"%@",trueDate);
    [NetWork NetRequestPOSTWithRequestURL:kRequestUrlPullReply
                            WithParameter:paramer
                     WithReturnValeuBlock:^(id returnValue) {
                         NSString *returnCode = returnValue[@"code"];
                         if(![returnCode intValue]){
                             [self sucessToDo:returnValue];
                         }else{
//                             NSLog(@"%@0",returnValue);
                             [self failureTodo:[returnCode integerValue]];
                         }
                         
                     } WithFailureBlock:^{
                         PullCenterModel *pullcenter = [PullCenterModel sharePullCenter];
                         [pullcenter.progressHUD setLabelText:@"网络错误,清洁差您的网络状况!"];
                         [pullcenter.progressHUD hide:YES afterDelay:3];
                         
                     }];
}

- (void) sucessToDo:(NSDictionary *)returnValue{
    NSString *simpleChineseString = [returnValue description];
    simpleChineseString = [NSString stringWithCString:[simpleChineseString cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    NSLog(@"%@",[simpleChineseString description]);
}

- (void) failureTodo:(NSInteger)returnCode{
    PullCenterModel *pullcenter = [PullCenterModel sharePullCenter];
    [pullcenter.progressHUD setLabelText:@"操作过于频繁!"];
    [pullcenter.progressHUD hide:YES afterDelay:3];
    
    NSLog(@"错误码:%ld",(long)returnCode);
}



@end
