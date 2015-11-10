//
//  YCLCarEventBaseModel.m
//  智能车
//
//  Created by user on 15/11/10.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "YCLCarEventBaseModel.h"
#import "PullCenterModel.h"
@implementation YCLCarEventBaseModel


- (NSString *) infoStringFromCodeString:(NSString *)codeString andConfigArray:(NSArray *)configArray{
    NSString *outPut=@"";
    for(int i=0;i<configArray.count;i++){
        NSArray *matchInnerArray = configArray[i];
        NSString *code = [codeString substringWithRange:NSMakeRange(i, 1)];
        //        NSLog(@"code:%@",code);
        for (NSDictionary *codeDictionary in matchInnerArray) {
            if ([code isEqualToString:[codeDictionary valueForKey:@"key"]]) {
                outPut = [outPut stringByAppendingString:[codeDictionary valueForKey:@"value"]];
            }
        }
    }
    return outPut;
}

- (NSString *)analysisCodeWithString: (NSString *)codeString{
    return [self infoStringFromCodeString:codeString andConfigArray:self.configArray];
}

- (void)sendMessage{
    PullCenterModel *phoneModel = [PullCenterModel sharePullCenter] ;
    NSString *phoneNumber = [phoneModel pullPhone];
    NSLog(@"%@",[self description]);
    [self sendMessageWithPhone:phoneNumber content:[NSString stringWithFormat:@"【益车利】%@\n(以上为益车利给您的车载设备的命令,命令类型号: {1})",self.code]];
}
- (NSArray *)configArray{
    return @[
             @[
                 @{@"key":@"3",@"value":@"命令返回3."},
                 @{@"key":@"0",@"value":@"命令返回0."},
                 @{@"key":@"9",@"value":@"命令返回9."},
                 @{@"key":@"6",@"value":@"命令返回6."},
                 ],
             @[
                 @{@"key":@"a",@"value":@"命令起效."},
                 @{@"key":@"0",@"value":@"命令不起效."},
                 
                 ],
             @[
                 @{@"key":@"a",@"value":@"空调未关闭."},
                 @{@"key":@"0",@"value":@"空调关闭."},
                 ],
             @[
                 @{@"key":@"a",@"value":@"有灯未关."},
                 @{@"key":@"0",@"value":@"灯全关."},
                 ],
             @[
                 @{@"key":@"a",@"value":@"门锁未关."},
                 @{@"key":@"0",@"value":@"门锁全关."},
                 ],
             @[
                 @{@"key":@"a",@"value":@"门或后备箱限位开关未关."},
                 @{@"key":@"0",@"value":@"限位开关全关."},
                 ],
             ];
}
- (NSString *)code{return @"0";}
@end
