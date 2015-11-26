//
//  YCLCarEventBaseModel.h
//  智能车
//
//  Created by user on 15/11/10.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestBaseModel.h"

@interface YCLCarEventBaseModel : RequestBaseModel
@property (strong,nonatomic) id analysisData;

- (NSString *)pullPhone;//返回当前绑定手机
- (NSArray *)configArray;//配置数组
- (NSString *)code;//命令码

- (NSString *) analysisCodeWithString:(NSString *)codeString;//解析返回值
- (void)sendMessage;//发送命令



@end
