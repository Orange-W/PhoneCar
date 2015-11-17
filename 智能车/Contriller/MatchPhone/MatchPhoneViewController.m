//
//  MatchPhoneViewController.m
//  YCLCar
//
//  Created by user on 15/11/14.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "MatchPhoneViewController.h"
#import "PullCenterModel.h"
#import "SetPasswordViewController.h"

@implementation MatchPhoneViewController

-(void)viewDidAppear:(BOOL)animated{
    NSString *pullPhone = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPullPhone];
    NSString *appPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPassword];
    if (appPassword && pullPhone) {
        NSLog(@"传颂主片面");
    }else if (pullPhone){
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SetPasswordViewController *setPasswordViewController = [storyBord instantiateViewControllerWithIdentifier:@"SetPasswordStoryBord"];
        [self presentViewController:setPasswordViewController animated:NO completion:nil];
    }
}

- (IBAction)touchMatchButton:(UIButton *)sender {
    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
     PullCenterModel *pullCenter = [PullCenterModel sharePullCenter];
    number = number?:kTestPhone;
    pullCenter.localViewController = self;
    if(!number){
        NSLog(@"号码不合法");
        MBProgressHUD *HUD = [pullCenter showProgresstoView:self.view];
        HUD.labelText = @"获取手机号失败";
        HUD.detailsLabelText = @"请检查: 设置->电话->本机号码";
        [HUD show:YES];
        [HUD hide:YES afterDelay:3];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:number forKey:kApplicationUserDefaultKeyPullPhone];
        [pullCenter addPullEvent:YCLCarEventMatchPhone forView:self.view];
    }
}
@end
