//
//  MatchPhoneModel.m
//  智能车
//
//  Created by user on 15/11/4.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "MatchPhoneModel.h"

@implementation MatchPhoneModel
static const NSString *matchStartPrefix = @"a5";

+ (void)matchStartWithPhone:(NSString *)phone andCode:(NSString *)code{
    MatchPhoneModel *model = [[MatchPhoneModel alloc] init];
    NSNumber *n = @([code length]/2);
    
    if ([code length]%2 != 0) {
        [model failureTodo:1001];
        return;
    }
    
    [model sendMessageWithPhone:phone
                        content:[NSString stringWithFormat:@"%@%@%@",matchStartPrefix,n,code]];
}

- (void)failureTodo:(NSInteger)returnCode{
    if (returnCode == 1001) {
        NSLog(@"匹配码不合法");
    }
}

@end
