//
//  YCLCarEventAddPhone.h
//  YCLCar
//
//  Created by user on 16/4/23.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "YCLCarEventBaseModel.h"

@interface YCLCarEventAddPhoneModel : YCLCarEventBaseModel
@property (strong,readonly,nonatomic) NSString *sendPrefix;
- (void)sendMessageWithAuthCode:(NSString *)authCode;
@end
