//
//  YCLMatchPhoneModel.m
//  YCLCar
//
//  Created by user on 15/11/14.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "YCLMatchPhoneModel.h"
#import "PullCenterModel.h"
#import <MBProgressHUD.h>

@implementation YCLMatchPhoneModel
- (NSString *) infoStringFromCodeString:(NSString *)codeString andConfigArray:(NSArray *)configArray{
    BOOL isContain = [codeString containsString:[self pullPhone]];
    NSLog(@"解析匹配返回");
    if (!isContain) {
        return @"本机不是合法手机，不能进行下一步";
    }
    
    return @"匹配完成";
}

- (NSString *)code{return @"TC0";}
- (NSString *)description{return @"匹配号码";}
- (NSArray *)configArray{return nil;}
-(void)sendMessage{}
@end
