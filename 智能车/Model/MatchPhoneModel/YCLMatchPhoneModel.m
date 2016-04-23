//
//  YCLMatchPhoneModel.m
//  YCLCar
//
//  Created by user on 15/11/14.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "YCLMatchPhoneModel.h"
#import "PullCenterModel.h"
#import "MatchPhoneViewController.h"

@implementation YCLMatchPhoneModel
- (NSString *) infoStringFromCodeString:(NSString *)codeString andConfigArray:(NSArray *)configArray{
    [[NSUserDefaults standardUserDefaults] setObject:codeString forKey:kApplicationUserDefaultPhoneString];
    
    NSString *matchPhone = [[NSUserDefaults standardUserDefaults] stringForKey:kApplicationUserDefaultKeyLocalPhone];
    
    NSRange range = [codeString rangeOfString:matchPhone];
    BOOL isContain = range.length!=0?YES:NO;
    
    NSLog(@"解析匹配返回");
    if (!isContain) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kApplicationUserDefaultKeyLocalPhone];
        return @"本机不是合法手机，不能进行下一步";
    }
    self.analysisData = codeString;
    [[NSUserDefaults standardUserDefaults] setObject:[self pullPhone] forKey:kApplicationUserDefaultKeyPullPhone];
    return @"匹配已完成";
}

- (void)pushToNextFromViewController:(UIViewController *)viewController{
    UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MatchPhoneViewController *matchPhoneViewController = [storyBord instantiateViewControllerWithIdentifier:@"MatchStoryBord"];
    [matchPhoneViewController initViewWithMode:YCLMatchAuthKey];
    [viewController.navigationController pushViewController:matchPhoneViewController animated:YES];
}

- (NSString *)code{return @"TC0";}
- (NSString *)description{return @"匹配号码";}
- (NSArray *)configArray{return nil;}
#warning 测试,
//-(void)sendMessage{}
@end
