//
//  MatchPhoneModel.h
//  智能车
//
//  Created by user on 15/11/4.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "RequestBaseModel.h"

@interface MatchPhoneModel : RequestBaseModel
+(void)matchStartWithPhone:(NSString *)phone andCode:(NSString *)code;
@end
