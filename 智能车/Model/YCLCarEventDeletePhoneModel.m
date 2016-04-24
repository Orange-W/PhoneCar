//
//  YCLCarEventDeletePhone.m
//  YCLCar
//
//  Created by user on 16/4/24.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "YCLCarEventDeletePhoneModel.h"
@interface YCLCarEventDeletePhoneModel()
@property (copy, nonatomic) NSString *deletePhone;
@end

@implementation YCLCarEventDeletePhoneModel
static const NSString *staticSendPrefix = @"TD";

- (NSString *)sendPrefix{
    return [staticSendPrefix copy];
}

- (void)sendMessageWithAuthCode:(NSString *)phone{
    self.deletePhone = phone;
    //[self sendMessage];
}

- (NSString *) infoStringFromCodeString:(NSString *)codeString
                         andConfigArray:(NSArray *)configArray{
    BOOL isHas = NO;
    NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithArray:[codeString componentsSeparatedByString:@"#"]];
    [phoneArray removeObjectAtIndex:0];
    NSLog(@"%@",phoneArray);
    for (NSString *string in phoneArray) {
        if ([string isEqualToString:_deletePhone]) {
            isHas=YES;
        }
    }
    
    return isHas?@"不成功":@"成功";
}

- (NSString *)code{return [NSString stringWithFormat:@"%@%@",self.sendPrefix,self.deletePhone];}
- (NSString *)description{return @"删除号码";}
- (NSArray *)configArray{return nil;}
@end
