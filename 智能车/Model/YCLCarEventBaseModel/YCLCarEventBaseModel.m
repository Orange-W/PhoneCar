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

/**
 *  @author Orange-W, 15-12-04 16:12:18
 *
 *  @brief  解析函数,个别功能重写此函数
 *  @param codeString  车载设备返回的反馈码
 *  @param configArray 配置数组
 *  @return 解析返回字符串
 */
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

/**
 *  @author Orange-W, 15-12-04 16:12:54
 *
 *  @brief  内部调用,不要重写
 *  @param codeString 原始反馈码
 *  @return 解析结果
 */
- (NSString *)analysisCodeWithString: (NSString *)codeString{
    return [self infoStringFromCodeString:codeString andConfigArray:self.configArray];
}

/**
 *  @author Orange-W, 15-12-04 16:12:26
 *
 *  @brief  向车载设备发送命令
 */
- (void)sendMessage{
    NSString *phoneNumber = [self pullPhone];
    NSLog(@"%@",[self description]);
    [self sendMessageWithPhone:phoneNumber content:[NSString stringWithFormat:@"【益车利】%@\n(以上为益车利给您的车载设备的命令码)",self.code]];
}

/**
 *  @author Orange-W, 15-12-04 16:12:50
 *
 *  @brief  配置数组
 */
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

/**
 *  @author Orange-W, 15-12-04 16:12:07
 *
 *  @brief  返回请求中心单例的绑定手机
 *  @return 绑定手机号
 */
- (NSString *)pullPhone{
    PullCenterModel *phoneModel = [PullCenterModel sharePullCenter];
    return [phoneModel pullPhone];
}

/**
 *  @author Orange-W, 15-12-04 16:12:40
 *
 *  @brief  push 去下一个页面,如果使用,需要自己重写(也可进行Present操作)
 *  @param viewController push 去的ViewControll
 */
- (void) pushToNextFromViewController:(UIViewController *)viewController{
    
}

@end
