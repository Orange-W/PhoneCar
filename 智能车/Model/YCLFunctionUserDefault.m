//
//  YCLFunctionUserDefault.m
//  YCLCar
//
//  Created by user on 16/3/5.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "YCLFunctionUserDefault.h"

@implementation YCLFunctionUserDefault
+ (NSArray *)userDefaultArray{
    return @[kApplicationUserDefaultKeyPullPhone,//设备号码
             kApplicationUserDefaultKeyLocalPhone,//本机号码
             kApplicationUserDefaultKeyPassword,//应用密码
             kApplicationUserDefaultHasMatchAuthKey,//是否完成授权验证
             ];
}




#pragma mark - 清除
/**
 *  @author Orange-W, 16-03-05 18:03:27
 *
 *  @brief 清除所有用户信息
 *  @return 成功/失败
 */
+ (BOOL)clearAll{
    return [YCLFunctionUserDefault clearWithNameArray:[YCLFunctionUserDefault userDefaultArray]];
}

/**
 *  @author Orange-W, 16-03-05 18:03:02
 *
 *  @brief 清除单个 UserDefault
 *  @param name 陈述
 *  @return 成功/失败
 */
+ (BOOL)clearWithName:(NSString *)name{
    return [YCLFunctionUserDefault clearWithNameArray:@[name]];
}


#pragma mark 核心方法
/**
 *  @author Orange-W, 16-03-05 18:03:48
 *
 *  @brief 批量清除UserDefault
 *  @param array UserDefault陈述数组
 *  @return 成功/失败
 */
+ (BOOL)clearWithNameArray:(NSArray *)array{
    if (array.count < 1) {
        return NO;
    }
    for (NSString *name in array) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:name];
    }
    return  [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
