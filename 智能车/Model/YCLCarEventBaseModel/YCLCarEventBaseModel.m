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
        BOOL isMatch = NO;
        for (NSDictionary *codeDictionary in matchInnerArray) {
            if ([code isEqualToString:[codeDictionary valueForKey:@"key"]]) {
                outPut = [outPut stringByAppendingString:[codeDictionary valueForKey:@"value"]];
                isMatch = YES;
            }
        }
        
        if (!isMatch) {
            outPut = [outPut stringByAppendingString:@"未知 "];
        }
    }
    self.analysisData = outPut;
    return outPut;
}

- (NSString *)analysisCodeWithString: (NSString *)codeString{
    return [self infoStringFromCodeString:codeString andConfigArray:self.configArray];
}

- (void)sendMessage{
    NSString *phoneNumber = [self pullPhone];
    NSLog(@"%@",[self description]);
    [self sendMessageWithPhone:phoneNumber content:[NSString stringWithFormat:@"【益车利】%@\n(以上为益车利给您的车载设备的命令码)",self.code]];
}
- (NSArray *)configArray{
    return @[
             @[ //命令类型
                 @{@"key":@"3",@"value":@"开空调 "},
                 @{@"key":@"0",@"value":@"关空调 "},
                 @{@"key":@"9",@"value":@"开锁 "},
                 @{@"key":@"6",@"value":@"关锁 "},
                 @{@"key":@"1",@"value":@"车辆状况 "},
                 @{@"key":@"2",@"value":@"静音停车 "},
                 @{@"key":@"5",@"value":@"野外寻车 "},
                 ],
             @[ //命令是否起效
                 @{@"key":@"a",@"value":@"起效 "},
                 @{@"key":@"0",@"value":@"不起效 "},
                 ],
             @[ //空调状态
                 @{@"key":@"a",@"value":@"未关闭 "},
                 @{@"key":@"0",@"value":@"全关闭 "},
                 ],
             @[ //灯状态
                 @{@"key":@"a",@"value":@"未关完 "},
                 @{@"key":@"0",@"value":@"全关闭 "},
                 ],
             @[ //门锁状态
                 @{@"key":@"a",@"value":@"部分未锁 "},
                 @{@"key":@"0",@"value":@"全锁 "},
                 ],
             @[ //限位开关或后备箱
                 @{@"key":@"a",@"value":@"未关完全"},
                 @{@"key":@"0",@"value":@"全关"},
                 ],
             ];
}
- (NSString *)code{return @"";}

- (NSString *)pullPhone{
    PullCenterModel *phoneModel = [PullCenterModel sharePullCenter];
    return [phoneModel pullPhone];
}

@end
