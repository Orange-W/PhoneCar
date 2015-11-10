//
//  YCLCarEventBaseModel.h
//  智能车
//
//  Created by user on 15/11/10.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestBaseModel.h"

@interface YCLCarEventBaseModel : RequestBaseModel

- (NSArray *)configArray;
- (NSString *)code;

- (NSString *) analysisCodeWithString:(NSString *)codeString;
- (void)sendMessage;

/**
 *  @author Orange-W, 15-11-10 13:11:22
 *
 *  @brief  解析函数
 *  @param codeString  返回码
 *  @param configArray 配置数组
 *  @return 结果集
 */
- (NSString *) infoStringFromCodeString:(NSString *)codeString andConfigArray:(NSArray *)configArray;
@end
