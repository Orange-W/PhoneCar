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
-(void)viewDidLoad{
    NSString *pullPhone = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPullPhone];
    NSString *appPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kApplicationUserDefaultKeyPassword];
    _matchTestField.delegate = self;
    _matchTestField.keyboardType = UIKeyboardTypeNumberPad;
    if (appPassword && pullPhone) {
        NSLog(@"登录页面");
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *loginViewController = [storyBord instantiateViewControllerWithIdentifier:@"LoginNav"];
        [self presentViewController:loginViewController animated:NO completion:nil];
    }else if (pullPhone){
        NSLog(@"设置密码");
        UIStoryboard *storyBord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        SetPasswordViewController *setPasswordViewController = [storyBord instantiateViewControllerWithIdentifier:@"SetPasswordNav"];
        [self presentViewController:setPasswordViewController animated:NO completion:nil];
    }else{
        NSLog(@"匹配设备");
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

- (IBAction)isAllowable:(UITextField *)sender {
    NSLog(@"22");
    if (sender.text.length!=11) {
        _warningLabel.text = @"绑定设备号应为11位!";
        _warningLabel.textColor = [UIColor redColor];
    }else{
        _warningLabel.textColor = [UIColor greenColor];
        _warningLabel.text = @"设备号合格!";
        [[NSUserDefaults standardUserDefaults] setObject:sender.text forKey:@"pullPhone"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_matchTestField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
