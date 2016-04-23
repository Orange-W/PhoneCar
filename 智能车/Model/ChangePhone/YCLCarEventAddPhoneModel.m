//
//  YCLCarEventAddPhone.m
//  YCLCar
//
//  Created by user on 16/4/23.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "YCLCarEventAddPhoneModel.h"
#import "PullCenterModel.h"
#import "PhoneChangeViewController.h"

@interface YCLCarEventAddPhoneModel()
@property (copy, nonatomic) NSString *addPhone;
@end

@implementation YCLCarEventAddPhoneModel
static const NSString *staticSendPrefix = @"TA";

- (NSString *)sendPrefix{
    return [staticSendPrefix copy];
}

- (void)sendMessageWithAuthCode:(NSString *)phone{
    self.addPhone = phone;
    [self sendMessage];
}

- (NSString *) infoStringFromCodeString:(NSString *)codeString
                         andConfigArray:(NSArray *)configArray{
    BOOL isHas = NO;
    NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithArray:[codeString componentsSeparatedByString:@"#"]];
    [phoneArray removeObjectAtIndex:0];
    NSLog(@"%@",phoneArray);
    for (NSString *string in phoneArray) {
        if ([string isEqualToString:_addPhone]) {
            isHas=YES;
        }
    }
    
    
    
    return isHas?@"成功":@"不成功";
}

- (NSString *)code{return [NSString stringWithFormat:@"%@%@",self.sendPrefix,self.addPhone];}
- (NSString *)description{return @"添加号码";}
- (NSArray *)configArray{return nil;}
@end
