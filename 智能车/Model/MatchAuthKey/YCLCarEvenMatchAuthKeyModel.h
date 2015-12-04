//
//  YCLCarEvenMatchAuthKeyModel.h
//  
//
//  Created by user on 15/12/1.
//
//

#import "YCLCarEventBaseModel.h"

@interface YCLCarEvenMatchAuthKeyModel : YCLCarEventBaseModel
- (void)sendMessageWithAuthCode:(NSString *)authCode;
@end
