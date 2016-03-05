//
//  YCLCarEvenMatchAuthKeyModel.m
//  
//
//  Created by user on 15/12/1.
//
//

#import "YCLCarEvenMatchAuthKeyModel.h"
#import "PullCenterModel.h"
#import "SetPasswordViewController.h"

@interface YCLCarEvenMatchAuthKeyModel()
@property (copy, nonatomic) NSString *authKey;
@end

@implementation YCLCarEvenMatchAuthKeyModel
static const NSString *matchSendPrefix = @"a5";
static const NSString *matchReturnPrefix = @"6b";

- (NSString *)authPrefix{
    return [matchReturnPrefix copy];
}

- (void)sendMessageWithAuthCode:(NSString *)authCode{
    NSNumber *n = @((int)([authCode length]/2));
    
    self.authKey = [NSString stringWithFormat:@"%@%@",n,authCode];
    [self sendMessage];
}

- (NSString *) infoStringFromCodeString:(NSString *)codeString andConfigArray:(NSArray *)configArray{
    NSString *trueBackString = [NSString stringWithFormat:@"%@%@",matchReturnPrefix,self.authKey];
    NSLog(@"%@-%@",codeString,trueBackString);
    if ([codeString isEqualToString:trueBackString]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kApplicationUserDefaultHasMatchAuthKey];
        return @"匹配已完成";
    }
    
    return @"匹配不成功";
}

- (void)pushToNextFromViewController:(UIViewController *)viewController{
    UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SetPasswordViewController *setPasswordViewController = [storyBord instantiateViewControllerWithIdentifier:@"SetPasswordStoryBord"];
    [viewController.navigationController pushViewController:setPasswordViewController animated:YES];
}



- (NSString *)code{return [NSString stringWithFormat:@"%@%@",matchSendPrefix,self.authKey];}
- (NSString *)description{return @"验证授权";}
- (NSArray *)configArray{return nil;}

@end
